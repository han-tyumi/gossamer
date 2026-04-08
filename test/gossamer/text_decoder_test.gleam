import gleeunit/should
import gossamer/array_buffer
import gossamer/text_decoder
import gossamer/text_decoder/text_decoder_option
import gossamer/text_encoder
import gossamer/uint8_array

pub fn new_test() {
  let decoder = text_decoder.new()
  text_decoder.encoding(decoder) |> should.equal("utf-8")
}

pub fn new_with_utf8_test() {
  let assert Ok(decoder) = text_decoder.new_with("utf-8", [])
  text_decoder.encoding(decoder) |> should.equal("utf-8")
}

pub fn new_with_invalid_test() {
  text_decoder.new_with("not-a-real-encoding", [])
  |> should.be_error
}

pub fn new_with_fatal_test() {
  let assert Ok(decoder) =
    text_decoder.new_with("utf-8", [text_decoder_option.Fatal])
  text_decoder.is_fatal(decoder) |> should.be_true
}

pub fn new_with_ignore_bom_test() {
  let assert Ok(decoder) =
    text_decoder.new_with("utf-8", [text_decoder_option.IgnoreBom])
  text_decoder.is_ignore_bom(decoder) |> should.be_true
}

pub fn is_fatal_default_test() {
  let decoder = text_decoder.new()
  text_decoder.is_fatal(decoder) |> should.be_false
}

pub fn is_ignore_bom_default_test() {
  let decoder = text_decoder.new()
  text_decoder.is_ignore_bom(decoder) |> should.be_false
}

pub fn decode_test() {
  let encoded = text_encoder.encode("hello world")
  let buffer = uint8_array.buffer(encoded)
  text_decoder.decode(buffer) |> should.equal("hello world")
}

pub fn decode_with_test() {
  let encoded = text_encoder.encode("utf-8 text")
  let buffer = uint8_array.buffer(encoded)
  let assert Ok(decoded) = text_decoder.decode_with(buffer, "utf-8", [])
  should.equal(decoded, "utf-8 text")
}

pub fn decode_chunk_test() {
  let decoder = text_decoder.new()
  let encoded = text_encoder.encode("chunk data")
  let buffer = uint8_array.buffer(encoded)
  let assert Ok(decoded) = text_decoder.decode_chunk(decoder, buffer)
  should.equal(decoded, "chunk data")
}

pub fn flush_test() {
  let decoder = text_decoder.new()
  let assert Ok(flushed) = text_decoder.flush(decoder)
  should.equal(flushed, "")
}

pub fn decode_empty_buffer_test() {
  let buffer = array_buffer.new(0)
  text_decoder.decode(buffer) |> should.equal("")
}
