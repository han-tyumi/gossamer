import gossamer/encoding.{type Encoding}
import gossamer/text_encoder/encode_into_result.{type EncodeIntoResult}
import gossamer/uint8_array.{type Uint8Array}

@external(javascript, "./text_encoder.ffi.mjs", "encoding")
pub fn encoding() -> Encoding

@external(javascript, "./text_encoder.ffi.mjs", "encode")
pub fn encode(input: String) -> Uint8Array

@external(javascript, "./text_encoder.ffi.mjs", "encode_into")
pub fn encode_into(input: String, dest: Uint8Array) -> EncodeIntoResult
