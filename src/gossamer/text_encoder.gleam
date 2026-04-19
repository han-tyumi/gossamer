//// Encodes text as UTF-8 bytes.
////
//// See [TextEncoder](https://developer.mozilla.org/en-US/docs/Web/API/TextEncoder) on MDN.

import gossamer/encoding.{type Encoding}
import gossamer/uint8_array.{type Uint8Array}

pub type EncodeIntoResult {
  EncodeIntoResult(read: Int, written: Int)
}

@external(javascript, "./text_encoder.ffi.mjs", "encoding")
pub fn encoding() -> Encoding

@external(javascript, "./text_encoder.ffi.mjs", "encode")
pub fn encode(input: String) -> Uint8Array

@external(javascript, "./text_encoder.ffi.mjs", "encode_into")
pub fn encode_into(input: String, dest: Uint8Array) -> EncodeIntoResult
