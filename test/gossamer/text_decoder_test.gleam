import gleeunit/should
import gossamer/encoding
import gossamer/text_decoder

pub fn new_test() {
  let decoder = text_decoder.new()
  text_decoder.encoding(decoder) |> should.equal(encoding.Utf8)
}

pub fn new_with_utf8_test() {
  let assert Ok(decoder) = text_decoder.new_with("utf-8", [])
  text_decoder.encoding(decoder) |> should.equal(encoding.Utf8)
}

pub fn new_with_invalid_test() {
  text_decoder.new_with("not-a-real-encoding", [])
  |> should.be_error
}

pub fn new_with_fatal_test() {
  let assert Ok(decoder) = text_decoder.new_with("utf-8", [text_decoder.Fatal])
  text_decoder.is_fatal(decoder) |> should.be_true
}

pub fn new_with_ignore_bom_test() {
  let assert Ok(decoder) =
    text_decoder.new_with("utf-8", [text_decoder.IgnoreBom])
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
  let assert Ok(decoded) =
    text_decoder.decode(<<"utf-8 text":utf8>>, "utf-8", [])
  should.equal(decoded, "utf-8 text")
}

pub fn decode_chunk_test() {
  let decoder = text_decoder.new()
  let assert Ok(decoded) =
    text_decoder.decode_chunk(decoder, <<"chunk data":utf8>>)
  should.equal(decoded, "chunk data")
}

pub fn flush_test() {
  let decoder = text_decoder.new()
  let assert Ok(flushed) = text_decoder.flush(decoder)
  should.equal(flushed, "")
}
