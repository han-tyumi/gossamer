import gleeunit/should
import gossamer/encoding/text_decoder

pub fn build_default_test() {
  let assert Ok(decoder) = text_decoder.new("utf-8") |> text_decoder.build
  text_decoder.encoding(decoder) |> should.equal("utf-8")
}

pub fn build_invalid_test() {
  text_decoder.new("not-a-real-encoding")
  |> text_decoder.build
  |> should.be_error
}

pub fn with_fatal_test() {
  let assert Ok(decoder) =
    text_decoder.new("utf-8")
    |> text_decoder.with_fatal(True)
    |> text_decoder.build
  text_decoder.is_fatal(decoder) |> should.be_true
}

pub fn with_ignore_bom_test() {
  let assert Ok(decoder) =
    text_decoder.new("utf-8")
    |> text_decoder.with_ignore_bom(True)
    |> text_decoder.build
  text_decoder.is_ignore_bom(decoder) |> should.be_true
}

pub fn is_fatal_default_test() {
  let assert Ok(decoder) = text_decoder.new("utf-8") |> text_decoder.build
  text_decoder.is_fatal(decoder) |> should.be_false
}

pub fn is_ignore_bom_default_test() {
  let assert Ok(decoder) = text_decoder.new("utf-8") |> text_decoder.build
  text_decoder.is_ignore_bom(decoder) |> should.be_false
}

pub fn decode_test() {
  let assert Ok(decoded) =
    text_decoder.decode(<<"utf-8 text":utf8>>, with: text_decoder.new("utf-8"))
  should.equal(decoded, "utf-8 text")
}

pub fn decode_chunk_test() {
  let assert Ok(decoder) = text_decoder.new("utf-8") |> text_decoder.build
  let assert Ok(decoded) =
    text_decoder.decode_chunk(decoder, <<"chunk data":utf8>>)
  should.equal(decoded, "chunk data")
}

pub fn flush_test() {
  let assert Ok(decoder) = text_decoder.new("utf-8") |> text_decoder.build
  let assert Ok(flushed) = text_decoder.flush(decoder)
  should.equal(flushed, "")
}
