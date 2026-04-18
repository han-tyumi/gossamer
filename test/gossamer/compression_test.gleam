import gleeunit/should
import gossamer/compression_format
import gossamer/compression_stream
import gossamer/decompression_stream
import gossamer/promise
import gossamer/readable_stream
import gossamer/readable_stream/default_controller
import gossamer/readable_stream/read_result
import gossamer/readable_stream/reader
import gossamer/text_decoder
import gossamer/text_encoder
import gossamer/uint8_array

pub fn gzip_round_trip_test() {
  let data = text_encoder.encode("Hello, compression!")

  let input =
    readable_stream.from_start(fn(controller) {
      let _ = default_controller.enqueue(controller, data)
      let _ = default_controller.close(controller)
      Nil
    })

  let assert Ok(compressor) = compression_stream.new(compression_format.Gzip)
  let assert Ok(decompressor) =
    decompression_stream.new(compression_format.Gzip)

  let assert Ok(first) =
    input
    |> readable_stream.pipe_through(
      #(
        compression_stream.readable(compressor),
        compression_stream.writable(compressor),
      ),
      [],
    )
  let assert Ok(output) =
    first
    |> readable_stream.pipe_through(
      #(
        decompression_stream.readable(decompressor),
        decompression_stream.writable(decompressor),
      ),
      [],
    )

  let assert Ok(reader) = readable_stream.get_reader(output)

  use result <- promise.then(reader.read(reader))
  let assert Ok(read) = result
  case read {
    read_result.Value(chunk) -> {
      let text = text_decoder.decode(uint8_array.buffer(chunk))
      should.equal(text, "Hello, compression!")
    }
    read_result.Done(_) -> {
      should.fail()
    }
  }
}
