import gossamer/encoding.{type Encoding}
import gossamer/readable_stream.{type ReadableStream}
import gossamer/uint8_array.{type Uint8Array}
import gossamer/writable_stream.{type WritableStream}

@external(javascript, "./text_encoder_stream.type.ts", "TextEncoderStream$")
pub type TextEncoderStream

@external(javascript, "./text_encoder_stream.ffi.mjs", "new_")
pub fn new() -> TextEncoderStream

@external(javascript, "./text_encoder_stream.ffi.mjs", "readable")
pub fn readable(of encoder: TextEncoderStream) -> ReadableStream(Uint8Array)

@external(javascript, "./text_encoder_stream.ffi.mjs", "writable")
pub fn writable(of encoder: TextEncoderStream) -> WritableStream(String)

@external(javascript, "./text_encoder_stream.ffi.mjs", "encoding")
pub fn encoding(of encoder: TextEncoderStream) -> Encoding
