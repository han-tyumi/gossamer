import gleam/bit_array
import gleam/javascript/promise
import gleeunit/should
import gossamer/compression_stream
import gossamer/decompression_stream
import gossamer/stream/readable_stream
import gossamer/stream/readable_stream/default_controller
import gossamer/stream/readable_stream/read_result
import gossamer/stream/readable_stream/reader

pub fn gzip_round_trip_test() {
  let data = <<"Hello, compression!":utf8>>

  let assert Ok(input) =
    readable_stream.from_start(fn(controller) {
      let _ = default_controller.enqueue(controller, data)
      let _ = default_controller.close(controller)
      Nil
    })

  let assert Ok(compressor) = compression_stream.new(compression_stream.Gzip)
  let assert Ok(decompressor) =
    decompression_stream.new(compression_stream.Gzip)

  let assert Ok(first) =
    input
    |> readable_stream.pipe_through(
      #(
        compression_stream.readable(compressor),
        compression_stream.writable(compressor),
      ),
      readable_stream.pipe_options(),
    )
  let assert Ok(output) =
    first
    |> readable_stream.pipe_through(
      #(
        decompression_stream.readable(decompressor),
        decompression_stream.writable(decompressor),
      ),
      readable_stream.pipe_options(),
    )

  let assert Ok(reader) = readable_stream.get_reader(output)

  use result <- promise.map(reader.read(reader))
  let assert Ok(read) = result
  case read {
    read_result.Value(chunk) -> {
      let assert Ok(text) = bit_array.to_string(chunk)
      should.equal(text, "Hello, compression!")
    }
    read_result.Done(_) -> {
      should.fail()
    }
  }
}
