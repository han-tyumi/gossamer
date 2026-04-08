import gleeunit/should
import gossamer/text_encoder
import gossamer/uint8_array

pub fn encoding_test() {
  text_encoder.encoding() |> should.equal("utf-8")
}

pub fn encode_test() {
  let encoded = text_encoder.encode("hello")
  uint8_array.byte_length(encoded) |> should.equal(5)
  uint8_array.to_list(encoded)
  |> should.equal([104, 101, 108, 108, 111])
}

pub fn encode_empty_test() {
  let encoded = text_encoder.encode("")
  uint8_array.byte_length(encoded) |> should.equal(0)
}

pub fn encode_unicode_test() {
  let encoded = text_encoder.encode("é")
  // é is 2 bytes in UTF-8.
  uint8_array.byte_length(encoded) |> should.equal(2)
}

pub fn encode_into_test() {
  let dest = uint8_array.from_length(10)
  let result = text_encoder.encode_into("hello", dest)
  result.read |> should.equal(5)
  result.written |> should.equal(5)
}
