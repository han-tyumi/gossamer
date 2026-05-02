import gleam/option.{None}
import gleeunit/should
import gossamer/encoding
import gossamer/promise
import gossamer/readable_stream
import gossamer/readable_stream/default_controller
import gossamer/readable_stream/read_result
import gossamer/readable_stream/reader
import gossamer/text_decoder_stream
import gossamer/text_encoder_stream

pub fn text_encoder_stream_new_test() {
  let encoder = text_encoder_stream.new()
  text_encoder_stream.encoding(encoder) |> should.equal(encoding.Utf8)
}

pub fn text_encoder_stream_readable_writable_test() {
  let encoder = text_encoder_stream.new()
  let _readable = text_encoder_stream.readable(encoder)
  let _writable = text_encoder_stream.writable(encoder)
}

pub fn text_decoder_stream_new_test() {
  let decoder = text_decoder_stream.new()
  text_decoder_stream.encoding(decoder) |> should.equal(encoding.Utf8)
  text_decoder_stream.is_fatal(decoder) |> should.be_false
  text_decoder_stream.is_ignore_bom(decoder) |> should.be_false
}

pub fn text_decoder_stream_new_with_test() {
  let assert Ok(decoder) = text_decoder_stream.new_with("utf-8", [])
  text_decoder_stream.encoding(decoder) |> should.equal(encoding.Utf8)
}

pub fn text_decoder_stream_readable_writable_test() {
  let decoder = text_decoder_stream.new()
  let _readable = text_decoder_stream.readable(decoder)
  let _writable = text_decoder_stream.writable(decoder)
}

pub fn text_decoder_stream_read_write_pair_test() {
  let decoder = text_decoder_stream.new()
  let #(_readable, _writable) = text_decoder_stream.read_write_pair(decoder)
}

pub fn text_encode_decode_stream_roundtrip_test() {
  let encoder = text_encoder_stream.new()

  let assert Ok(source) =
    readable_stream.from_start(fn(controller) {
      let _ = default_controller.enqueue(controller, "hello stream")
      let _ = default_controller.close(controller)
      Nil
    })

  let assert Ok(encoded) =
    readable_stream.pipe_through(
      source,
      #(
        text_encoder_stream.readable(encoder),
        text_encoder_stream.writable(encoder),
      ),
      [],
    )

  let decoder = text_decoder_stream.new()

  let assert Ok(decoded) =
    readable_stream.pipe_through(
      encoded,
      #(
        text_decoder_stream.readable(decoder),
        text_decoder_stream.writable(decoder),
      ),
      [],
    )

  let assert Ok(r) = readable_stream.get_reader(decoded)

  use result <- promise.then(reader.read(r))
  should.equal(result, Ok(read_result.Value("hello stream")))

  use result <- promise.then(reader.read(r))
  should.equal(result, Ok(read_result.Done(None)))
  promise.resolve(Nil)
}
