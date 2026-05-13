//// A stream-based UTF-8 encoder. Wire `writable(encoder)` to a
//// `String` source and `readable(encoder)` to a `BitArray` consumer
//// to pipe text through encoding without buffering the whole input.

import gossamer/encoding.{type Encoding}
import gossamer/stream/readable_stream.{type ReadableStream}
import gossamer/stream/writable_stream.{type WritableStream}

/// A stream-based encoder: writes text to the writable side, reads UTF-8
/// bytes from the readable side.
///
/// See [TextEncoderStream](https://developer.mozilla.org/en-US/docs/Web/API/TextEncoderStream) on MDN.
///
@external(javascript, "./text_encoder_stream.type.ts", "TextEncoderStream$")
pub type TextEncoderStream

/// Creates a new `TextEncoderStream` that encodes text as UTF-8.
///
@external(javascript, "./text_encoder_stream.ffi.mjs", "new_")
pub fn new() -> TextEncoderStream

/// The readable side of the stream — produces UTF-8 encoded bytes.
///
@external(javascript, "./text_encoder_stream.ffi.mjs", "readable")
pub fn readable(encoder: TextEncoderStream) -> ReadableStream(BitArray)

/// The writable side of the stream — accepts text chunks to encode.
///
@external(javascript, "./text_encoder_stream.ffi.mjs", "writable")
pub fn writable(encoder: TextEncoderStream) -> WritableStream(String)

/// The encoding used by the stream — always `Utf8`. Provided for
/// symmetry with `text_decoder_stream.encoding`.
///
@external(javascript, "./text_encoder_stream.ffi.mjs", "encoding")
pub fn encoding(encoder: TextEncoderStream) -> Encoding
