import gossamer/array_buffer.{type ArrayBuffer}
import gossamer/text_decoder/text_decoder_option.{type TextDecoderOption}

/// Represents a decoder for a specific text encoding, allowing you to convert
/// binary data into a string given the encoding.
///
@external(javascript, "./text_decoder.ffi.ts", "TextDecoder$")
pub type TextDecoder

@external(javascript, "./text_decoder.ffi.mjs", "new_")
pub fn new() -> TextDecoder

@external(javascript, "./text_decoder.ffi.mjs", "new_with")
pub fn new_with(label: String, options: List(TextDecoderOption)) -> TextDecoder

/// Returns encoding's name, lowercased.
///
@external(javascript, "./text_decoder.ffi.mjs", "encoding")
pub fn encoding(decoder: TextDecoder) -> String

/// Returns true if error mode is "fatal", otherwise false.
///
@external(javascript, "./text_decoder.ffi.mjs", "fatal")
pub fn fatal(decoder: TextDecoder) -> Bool

/// Returns the value of ignore BOM.
///
@external(javascript, "./text_decoder.ffi.mjs", "ignore_bom")
pub fn ignore_bom(decoder: TextDecoder) -> Bool

@external(javascript, "./text_decoder.ffi.mjs", "decode_chunk")
pub fn decode_chunk(decoder: TextDecoder, input: ArrayBuffer) -> String

@external(javascript, "./text_decoder.ffi.mjs", "flush")
pub fn flush(decoder: TextDecoder) -> String

/// Turns binary data, often in the form of a Uint8Array, into a string given
/// the encoding.
///
@external(javascript, "./text_decoder.ffi.mjs", "decode")
pub fn decode(input: ArrayBuffer) -> String

@external(javascript, "./text_decoder.ffi.mjs", "decode_with")
pub fn decode_with(
  input: ArrayBuffer,
  label: String,
  options: List(TextDecoderOption),
) -> String
