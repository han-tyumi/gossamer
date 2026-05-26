import gleam/javascript/promise
import gleam/option.{None, Some}
import gleeunit/should
import gossamer/encoding/text_decoder_stream
import gossamer/encoding/text_encoder_stream
import gossamer/stream/readable_stream
import gossamer/stream/readable_stream/default_controller
import gossamer/stream/readable_stream/reader

pub fn text_encoder_stream_readable_writable_test() {
  let encoder = text_encoder_stream.new()
  let _readable = text_encoder_stream.readable(encoder)
  let _writable = text_encoder_stream.writable(encoder)
}

pub fn text_decoder_stream_build_test() {
  let assert Ok(decoder) =
    text_decoder_stream.new("utf-8") |> text_decoder_stream.build
  text_decoder_stream.encoding(decoder) |> should.equal("utf-8")
  text_decoder_stream.is_fatal(decoder) |> should.be_false
  text_decoder_stream.is_ignore_bom(decoder) |> should.be_false
}

pub fn text_decoder_stream_build_invalid_test() {
  text_decoder_stream.new("not-a-real-encoding")
  |> text_decoder_stream.build
  |> should.be_error
}

pub fn text_decoder_stream_readable_writable_test() {
  let assert Ok(decoder) =
    text_decoder_stream.new("utf-8") |> text_decoder_stream.build
  let _readable = text_decoder_stream.readable(decoder)
  let _writable = text_decoder_stream.writable(decoder)
}

pub fn text_decoder_stream_read_write_pair_test() {
  let assert Ok(decoder) =
    text_decoder_stream.new("utf-8") |> text_decoder_stream.build
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
      readable_stream.pipe_options(),
    )

  let assert Ok(decoder) =
    text_decoder_stream.new("utf-8") |> text_decoder_stream.build

  let assert Ok(decoded) =
    readable_stream.pipe_through(
      encoded,
      #(
        text_decoder_stream.readable(decoder),
        text_decoder_stream.writable(decoder),
      ),
      readable_stream.pipe_options(),
    )

  let assert Ok(r) = readable_stream.get_reader(decoded)

  use result <- promise.await(reader.read(r))
  should.equal(result, Ok(Some("hello stream")))

  use result <- promise.await(reader.read(r))
  should.equal(result, Ok(None))
  promise.resolve(Nil)
}
