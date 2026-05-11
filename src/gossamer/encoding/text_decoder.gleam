import gossamer/encoding.{type DecoderError, type Encoding}

/// Decodes a stream of bytes into text using a specified character
/// encoding.
///
/// See [TextDecoder](https://developer.mozilla.org/en-US/docs/Web/API/TextDecoder) on MDN.
///
@external(javascript, "./text_decoder.type.ts", "TextDecoder$")
pub type TextDecoder

/// The configuration for a `TextDecoder`. Construct with `new`, refine
/// with `with_fatal` and `with_ignore_bom`, then call `build` (or
/// `decode` for one-shot use).
///
pub type Builder {
  Builder(label: String, fatal: Bool, ignore_bom: Bool)
}

/// Creates a new `Builder` for the given encoding label. Both flags
/// default to `False`.
///
pub fn new(label: String) -> Builder {
  Builder(label:, fatal: False, ignore_bom: False)
}

/// Sets whether decoding malformed data returns an error instead of
/// substituting it with a replacement character.
///
pub fn with_fatal(builder: Builder, value: Bool) -> Builder {
  Builder(..builder, fatal: value)
}

/// Sets whether the [byte order mark](https://www.w3.org/International/questions/qa-byte-order-mark)
/// is included in the decoded output (`False`) or skipped over (`True`).
///
pub fn with_ignore_bom(builder: Builder, value: Bool) -> Builder {
  Builder(..builder, ignore_bom: value)
}

/// Constructs a `TextDecoder` from the configured `Builder`. Returns
/// `UnsupportedEncoding` if the label isn't a recognized encoding.
///
@external(javascript, "./text_decoder.ffi.mjs", "build")
pub fn build(builder: Builder) -> Result(TextDecoder, DecoderError)

/// The decoder's resolved encoding.
///
@external(javascript, "./text_decoder.ffi.mjs", "encoding")
pub fn encoding(decoder: TextDecoder) -> Encoding

/// Whether decoding malformed data returns an error instead of
/// substituting it with a replacement character.
///
@external(javascript, "./text_decoder.ffi.mjs", "is_fatal")
pub fn is_fatal(decoder: TextDecoder) -> Bool

/// Whether the byte order mark is skipped over rather than included in
/// the decoded output.
///
@external(javascript, "./text_decoder.ffi.mjs", "is_ignore_bom")
pub fn is_ignore_bom(decoder: TextDecoder) -> Bool

/// Decodes `input`, keeping state for multi-byte sequences that span
/// chunks. Returns `MalformedInput` if the decoder is fatal and
/// `input` contains bytes that don't form a valid sequence.
///
@external(javascript, "./text_decoder.ffi.mjs", "decode_chunk")
pub fn decode_chunk(
  decoder: TextDecoder,
  input: BitArray,
) -> Result(String, DecoderError)

/// Emits any remaining bytes buffered from prior `decode_chunk` calls.
/// Returns `MalformedInput` if the decoder is fatal and an incomplete
/// multi-byte sequence was left in the buffer.
///
@external(javascript, "./text_decoder.ffi.mjs", "flush")
pub fn flush(decoder: TextDecoder) -> Result(String, DecoderError)

/// Decodes `input` using the given builder configuration in a single
/// shot (no streaming state retained). Returns `UnsupportedEncoding`
/// if the builder's label isn't a recognized encoding, or
/// `MalformedInput` if the builder is fatal and decoding encounters
/// bytes that don't form a valid sequence. For default UTF-8 decoding,
/// use `gleam/bit_array.to_string`.
///
@external(javascript, "./text_decoder.ffi.mjs", "decode")
pub fn decode(
  input: BitArray,
  with builder: Builder,
) -> Result(String, DecoderError)
