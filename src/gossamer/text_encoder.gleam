import gossamer/text_encoder/encode_into_result.{type EncodeIntoResult}
import gossamer/uint8_array.{type Uint8Array}

/// Turns a string into binary data (in the form of a Uint8Array) using UTF-8
/// encoding.
///
@external(javascript, "./text_encoder.ffi.mjs", "encode")
pub fn encode(input: String) -> Uint8Array

/// Encodes a string into the destination Uint8Array and returns the result of
/// the encoding.
///
@external(javascript, "./text_encoder.ffi.mjs", "encode_into")
pub fn encode_into(input: String, dest: Uint8Array) -> EncodeIntoResult
