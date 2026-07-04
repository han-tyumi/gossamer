import gleeunit/should
import gossamer/encoding
import gossamer/encoding/text_decoder
import runtime

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

pub fn decode_fatal_malformed_test() {
  text_decoder.decode(
    <<0xff>>,
    with: text_decoder.new("utf-8") |> text_decoder.with_fatal(True),
  )
  |> should.equal(Error(encoding.MalformedInput))
}

pub fn decode_unsupported_encoding_test() {
  text_decoder.decode(<<>>, with: text_decoder.new("not-a-real-encoding"))
  |> should.equal(Error(encoding.UnsupportedEncoding("not-a-real-encoding")))
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

pub fn decode_chunk_fatal_malformed_test() {
  let assert Ok(decoder) =
    text_decoder.new("utf-8")
    |> text_decoder.with_fatal(True)
    |> text_decoder.build
  text_decoder.decode_chunk(decoder, <<0xff>>)
  |> should.equal(Error(encoding.MalformedInput))
}

pub fn flush_fatal_incomplete_sequence_test() {
  let assert Ok(decoder) =
    text_decoder.new("utf-8")
    |> text_decoder.with_fatal(True)
    |> text_decoder.build
  let assert Ok("") = text_decoder.decode_chunk(decoder, <<0xe2>>)
  text_decoder.flush(decoder) |> should.equal(Error(encoding.MalformedInput))
}

pub fn build_legacy_single_byte_test() {
  use <- runtime.skip_on(runtime.Bun)
  text_decoder.new("iso-8859-2") |> text_decoder.build |> should.be_ok
}

/// Bun's ICU data omits 16 legacy single-byte encodings, so building a
/// decoder for one returns `UnsupportedEncoding` where Node and Deno
/// succeed.
pub fn build_legacy_single_byte_bun_divergence_test() {
  use <- runtime.only_on(runtime.Bun)
  text_decoder.new("iso-8859-2") |> text_decoder.build |> should.be_error
}
