import gossamer/js_error.{type JsError}
import gossamer/readable_stream.{type ReadableStream}
import gossamer/writable_stream.{type WritableStream}

/// A transform stream that compresses its input.
///
/// See [CompressionStream](https://developer.mozilla.org/en-US/docs/Web/API/CompressionStream) on MDN.
///
/// ## Examples
///
/// ```gleam
/// let assert Ok(compressor) = compression_stream.new(compression_stream.Gzip)
///
/// stdin.readable()
/// |> readable_stream.pipe_through(
///   #(
///     compression_stream.readable(compressor),
///     compression_stream.writable(compressor),
///   ),
///   [],
/// )
/// |> readable_stream.pipe_to(stdout.writable(), [])
/// ```
///
@external(javascript, "./compression_stream.type.ts", "CompressionStream$")
pub type CompressionStream

/// Compression algorithms supported by `CompressionStream` and
/// `DecompressionStream`.
///
/// Unrecognized or non-standard formats use `Other(String)`.
///
pub type CompressionFormat {
  Deflate
  DeflateRaw
  Gzip
  Brotli
  Other(String)
}

/// Returns an error if the format is not supported.
///
@external(javascript, "./compression_stream.ffi.mjs", "new_")
pub fn new(format: CompressionFormat) -> Result(CompressionStream, JsError)

@external(javascript, "./compression_stream.ffi.mjs", "readable")
pub fn readable(stream: CompressionStream) -> ReadableStream(BitArray)

@external(javascript, "./compression_stream.ffi.mjs", "writable")
pub fn writable(stream: CompressionStream) -> WritableStream(BitArray)
