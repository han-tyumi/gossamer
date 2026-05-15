//// A transform stream that decodes bytes into text in a specified
//// character encoding. Pipe a byte-producing `ReadableStream` through
//// the writable side and read decoded strings off the readable side.
//// Pair with
//// [`readable_stream.pipe_through`](../stream/readable_stream.html#pipe_through)
//// via [`read_write_pair`](#read_write_pair).

import gossamer/encoding.{type DecoderError, type Encoding}
import gossamer/stream/readable_stream.{type ReadableStream}
import gossamer/stream/writable_stream.{type WritableStream}

/// A stream-based decoder: writes bytes to the writable side, reads text
/// from the readable side.
///
/// See [TextDecoderStream](https://developer.mozilla.org/en-US/docs/Web/API/TextDecoderStream) on MDN.
///
@external(javascript, "./text_decoder_stream.type.ts", "TextDecoderStream$")
pub type TextDecoderStream

/// The configuration for a [`TextDecoderStream`](#TextDecoderStream).
///
pub opaque type Builder {
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
/// Returns `UnsupportedEncoding` if the label isn't a recognized
/// encoding.
///
pub fn build(builder: Builder) -> Result(TextDecoderStream, DecoderError) {
  do_build(builder.label, builder.fatal, builder.ignore_bom)
}

@external(javascript, "./text_decoder_stream.ffi.mjs", "build")
@internal
pub fn do_build(
  label: String,
  fatal: Bool,
  ignore_bom: Bool,
) -> Result(TextDecoderStream, DecoderError)

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
/// Convenient for passing directly to
/// [`readable_stream.pipe_through`](../stream/readable_stream.html#pipe_through).
///
pub fn read_write_pair(
  decoder: TextDecoderStream,
) -> #(ReadableStream(String), WritableStream(BitArray)) {
  #(decoder |> readable, decoder |> writable)
}
