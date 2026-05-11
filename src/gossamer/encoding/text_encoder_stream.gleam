import gossamer/encoding.{type Encoding}
import gossamer/readable_stream.{type ReadableStream}
import gossamer/writable_stream.{type WritableStream}

/// A stream-based encoder: writes text to the writable side, reads UTF-8
/// bytes from the readable side.
///
/// See [TextEncoderStream](https://developer.mozilla.org/en-US/docs/Web/API/TextEncoderStream) on MDN.
///
@external(javascript, "./text_encoder_stream.type.ts", "TextEncoderStream$")
pub type TextEncoderStream

@external(javascript, "./text_encoder_stream.ffi.mjs", "new_")
pub fn new() -> TextEncoderStream

@external(javascript, "./text_encoder_stream.ffi.mjs", "readable")
pub fn readable(encoder: TextEncoderStream) -> ReadableStream(BitArray)

@external(javascript, "./text_encoder_stream.ffi.mjs", "writable")
pub fn writable(encoder: TextEncoderStream) -> WritableStream(String)

@external(javascript, "./text_encoder_stream.ffi.mjs", "encoding")
pub fn encoding(encoder: TextEncoderStream) -> Encoding
