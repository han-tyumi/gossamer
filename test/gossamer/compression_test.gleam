import gleam/bit_array
import gleam/javascript/promise
import gleam/option.{None, Some}
import gleeunit/should
import gossamer/compression
import gossamer/compression/compression_stream
import gossamer/compression/decompression_stream
import gossamer/stream/readable_stream
import gossamer/stream/readable_stream/default_controller
import gossamer/stream/readable_stream/reader

fn round_trip(format: compression.CompressionFormat) {
  let data = <<"Hello, compression!":utf8>>

  let assert Ok(input) =
    readable_stream.from_start(fn(controller) {
      let _ = default_controller.enqueue(controller, data)
      let _ = default_controller.close(controller)
      Nil
    })

  let compressor = compression_stream.new(format)
  let decompressor = decompression_stream.new(format)

  let assert Ok(first) =
    input
    |> readable_stream.pipe_through(
      compression_stream.read_write_pair(compressor),
      readable_stream.pipe_options(),
    )
  let assert Ok(output) =
    first
    |> readable_stream.pipe_through(
      decompression_stream.read_write_pair(decompressor),
      readable_stream.pipe_options(),
    )

  let assert Ok(reader) = readable_stream.get_reader(output)

  use result <- promise.map(reader.read(reader))
  let assert Ok(read) = result
  case read {
    Some(chunk) -> {
      let assert Ok(text) = bit_array.to_string(chunk)
      should.equal(text, "Hello, compression!")
    }
    None -> should.fail()
  }
}

pub fn gzip_round_trip_test() {
  round_trip(compression.Gzip)
}

pub fn brotli_round_trip_test() {
  round_trip(compression.Brotli)
}
