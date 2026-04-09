import gossamer/array_buffer.{type ArrayBuffer}
import gossamer/text_decoder/text_decoder_option.{type TextDecoderOption}

@external(javascript, "./text_decoder.type.ts", "TextDecoder$")
pub type TextDecoder

@external(javascript, "./text_decoder.ffi.mjs", "new_")
pub fn new() -> TextDecoder

@external(javascript, "./text_decoder.ffi.mjs", "new_with")
pub fn new_with(
  label: String,
  with options: List(TextDecoderOption),
) -> Result(TextDecoder, String)

@external(javascript, "./text_decoder.ffi.mjs", "encoding")
pub fn encoding(of decoder: TextDecoder) -> String

@external(javascript, "./text_decoder.ffi.mjs", "is_fatal")
pub fn is_fatal(decoder: TextDecoder) -> Bool

@external(javascript, "./text_decoder.ffi.mjs", "is_ignore_bom")
pub fn is_ignore_bom(decoder: TextDecoder) -> Bool

@external(javascript, "./text_decoder.ffi.mjs", "decode_chunk")
pub fn decode_chunk(
  decoder: TextDecoder,
  input: ArrayBuffer,
) -> Result(String, String)

@external(javascript, "./text_decoder.ffi.mjs", "flush")
pub fn flush(decoder: TextDecoder) -> Result(String, String)

/// Turns binary data, often in the form of a Uint8Array, into a string given
/// the encoding.
///
@external(javascript, "./text_decoder.ffi.mjs", "decode")
pub fn decode(input: ArrayBuffer) -> String

@external(javascript, "./text_decoder.ffi.mjs", "decode_with")
pub fn decode_with(
  input: ArrayBuffer,
  label: String,
  with options: List(TextDecoderOption),
) -> Result(String, String)
