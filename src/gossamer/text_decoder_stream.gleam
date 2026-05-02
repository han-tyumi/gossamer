import gossamer/encoding.{type Encoding}
import gossamer/js_error.{type JsError}
import gossamer/readable_stream.{type ReadableStream}
import gossamer/text_decoder.{type TextDecoderOption}
import gossamer/writable_stream.{type WritableStream}

/// A stream-based decoder: writes bytes to the writable side, reads text
/// from the readable side.
///
/// See [TextDecoderStream](https://developer.mozilla.org/en-US/docs/Web/API/TextDecoderStream) on MDN.
///
@external(javascript, "./text_decoder_stream.type.ts", "TextDecoderStream$")
pub type TextDecoderStream

@external(javascript, "./text_decoder_stream.ffi.mjs", "new_")
pub fn new() -> TextDecoderStream

/// Creates a `TextDecoderStream` with the given encoding label and
/// options. Returns an error if the label isn't a recognized encoding.
///
@external(javascript, "./text_decoder_stream.ffi.mjs", "new_with")
pub fn new_with(
  label: String,
  with options: List(TextDecoderOption),
) -> Result(TextDecoderStream, JsError)

@external(javascript, "./text_decoder_stream.ffi.mjs", "readable")
pub fn readable(of decoder: TextDecoderStream) -> ReadableStream(String)

@external(javascript, "./text_decoder_stream.ffi.mjs", "writable")
pub fn writable(of decoder: TextDecoderStream) -> WritableStream(w)

@external(javascript, "./text_decoder_stream.ffi.mjs", "encoding")
pub fn encoding(of decoder: TextDecoderStream) -> Encoding

@external(javascript, "./text_decoder_stream.ffi.mjs", "is_fatal")
pub fn is_fatal(decoder: TextDecoderStream) -> Bool

@external(javascript, "./text_decoder_stream.ffi.mjs", "is_ignore_bom")
pub fn is_ignore_bom(decoder: TextDecoderStream) -> Bool

pub fn read_write_pair(
  of decoder: TextDecoderStream,
) -> #(ReadableStream(String), WritableStream(w)) {
  #(decoder |> readable, decoder |> writable)
}
