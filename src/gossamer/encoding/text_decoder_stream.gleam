import gossamer/encoding.{type Encoding}
import gossamer/js_error.{type JsError}
import gossamer/readable_stream.{type ReadableStream}
import gossamer/writable_stream.{type WritableStream}

/// A stream-based decoder: writes bytes to the writable side, reads text
/// from the readable side.
///
/// See [TextDecoderStream](https://developer.mozilla.org/en-US/docs/Web/API/TextDecoderStream) on MDN.
///
@external(javascript, "./text_decoder_stream.type.ts", "TextDecoderStream$")
pub type TextDecoderStream

/// The configuration for a `TextDecoderStream`. Construct with `new`,
/// refine with `with_fatal` and `with_ignore_bom`, then call `build`.
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

/// Sets whether decoding malformed data emits an error on the stream
/// instead of substituting it with a replacement character.
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

/// Constructs a `TextDecoderStream` from the configured `Builder`.
/// Returns an error if the label isn't a recognized encoding.
///
@external(javascript, "./text_decoder_stream.ffi.mjs", "build")
pub fn build(builder: Builder) -> Result(TextDecoderStream, JsError)

/// The readable side of the decoder, yielding decoded strings.
///
@external(javascript, "./text_decoder_stream.ffi.mjs", "readable")
pub fn readable(decoder: TextDecoderStream) -> ReadableStream(String)

/// The writable side of the decoder, accepting input bytes.
///
@external(javascript, "./text_decoder_stream.ffi.mjs", "writable")
pub fn writable(decoder: TextDecoderStream) -> WritableStream(BitArray)

/// The decoder's resolved encoding.
///
@external(javascript, "./text_decoder_stream.ffi.mjs", "encoding")
pub fn encoding(decoder: TextDecoderStream) -> Encoding

/// Whether decoding malformed data emits an error on the stream
/// instead of substituting it with a replacement character.
///
@external(javascript, "./text_decoder_stream.ffi.mjs", "is_fatal")
pub fn is_fatal(decoder: TextDecoderStream) -> Bool

/// Whether the byte order mark is skipped over rather than included in
/// the decoded output.
///
@external(javascript, "./text_decoder_stream.ffi.mjs", "is_ignore_bom")
pub fn is_ignore_bom(decoder: TextDecoderStream) -> Bool

/// Returns the readable and writable sides of the decoder as a tuple.
///
pub fn read_write_pair(
  decoder: TextDecoderStream,
) -> #(ReadableStream(String), WritableStream(BitArray)) {
  #(decoder |> readable, decoder |> writable)
}
