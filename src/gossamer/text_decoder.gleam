import gossamer/array_buffer.{type ArrayBuffer}
import gossamer/encoding.{type Encoding}

/// Decodes a stream of bytes into text using a specified character
/// encoding.
///
/// See [TextDecoder](https://developer.mozilla.org/en-US/docs/Web/API/TextDecoder) on MDN.
///
@external(javascript, "./text_decoder.type.ts", "TextDecoder$")
pub type TextDecoder

pub type TextDecoderOption {
  /// When set, decoding invalid data returns an error instead of substituting
  /// malformed data with a replacement character.
  ///
  Fatal

  /// Indicates whether the [byte order mark](https://www.w3.org/International/questions/qa-byte-order-mark)
  /// will be included in the output or skipped over. It defaults to false,
  /// which means that the byte order mark will be skipped over when decoding
  /// and will not be included in the decoded text.
  ///
  IgnoreBom
}

@external(javascript, "./text_decoder.ffi.mjs", "new_")
pub fn new() -> TextDecoder

/// Creates a `TextDecoder` with the given encoding label and options.
/// Returns an error if the label isn't a recognized encoding.
///
@external(javascript, "./text_decoder.ffi.mjs", "new_with")
pub fn new_with(
  label: String,
  with options: List(TextDecoderOption),
) -> Result(TextDecoder, String)

@external(javascript, "./text_decoder.ffi.mjs", "encoding")
pub fn encoding(of decoder: TextDecoder) -> Encoding

@external(javascript, "./text_decoder.ffi.mjs", "is_fatal")
pub fn is_fatal(decoder: TextDecoder) -> Bool

@external(javascript, "./text_decoder.ffi.mjs", "is_ignore_bom")
pub fn is_ignore_bom(decoder: TextDecoder) -> Bool

/// Decodes a chunk of bytes, keeping state for multi-byte sequences that
/// span chunks. Returns an error if the decoder was created with `Fatal`
/// and the input contains malformed data.
///
@external(javascript, "./text_decoder.ffi.mjs", "decode_chunk")
pub fn decode_chunk(
  decoder: TextDecoder,
  input: ArrayBuffer,
) -> Result(String, String)

/// Emits any remaining bytes buffered from prior `decode_chunk` calls.
/// Returns an error if the decoder was created with `Fatal` and an
/// incomplete multi-byte sequence was left in the buffer.
///
@external(javascript, "./text_decoder.ffi.mjs", "flush")
pub fn flush(decoder: TextDecoder) -> Result(String, String)

/// Turns binary data, often in the form of a Uint8Array, into a string given
/// the encoding.
///
@external(javascript, "./text_decoder.ffi.mjs", "decode")
pub fn decode(input: ArrayBuffer) -> String

/// Turns binary data into a string using the given encoding and options.
/// Returns an error if `label` isn't a recognized encoding, or if the
/// options include `Fatal` and decoding encounters malformed data.
///
@external(javascript, "./text_decoder.ffi.mjs", "decode_with")
pub fn decode_with(
  input: ArrayBuffer,
  label: String,
  with options: List(TextDecoderOption),
) -> Result(String, String)
