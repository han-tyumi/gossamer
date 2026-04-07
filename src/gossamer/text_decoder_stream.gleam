import gossamer/readable_stream.{type ReadableStream}
import gossamer/text_decoder/text_decoder_option.{type TextDecoderOption}
import gossamer/writable_stream.{type WritableStream}

@external(javascript, "./text_decoder_stream.ffi.ts", "TextDecoderStream$")
pub type TextDecoderStream

@external(javascript, "./text_decoder_stream.ffi.mjs", "new_")
pub fn new() -> TextDecoderStream

@external(javascript, "./text_decoder_stream.ffi.mjs", "new_with")
pub fn new_with(
  label: String,
  options: List(TextDecoderOption),
) -> TextDecoderStream

@external(javascript, "./text_decoder_stream.ffi.mjs", "readable")
pub fn readable(decoder: TextDecoderStream) -> ReadableStream(String)

@external(javascript, "./text_decoder_stream.ffi.mjs", "writable")
pub fn writable(decoder: TextDecoderStream) -> WritableStream(w)

@external(javascript, "./text_decoder_stream.ffi.mjs", "encoding")
pub fn encoding(decoder: TextDecoderStream) -> String

@external(javascript, "./text_decoder_stream.ffi.mjs", "fatal")
pub fn fatal(decoder: TextDecoderStream) -> Bool

@external(javascript, "./text_decoder_stream.ffi.mjs", "ignore_bom")
pub fn ignore_bom(decoder: TextDecoderStream) -> Bool

pub fn read_write_pair(
  decoder: TextDecoderStream,
) -> #(ReadableStream(String), WritableStream(w)) {
  #(decoder |> readable, decoder |> writable)
}
