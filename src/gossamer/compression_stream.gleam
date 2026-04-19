import gossamer/compression_format.{type CompressionFormat}
import gossamer/readable_stream.{type ReadableStream}
import gossamer/uint8_array.{type Uint8Array}
import gossamer/writable_stream.{type WritableStream}

/// A transform stream that compresses its input.
///
/// See [CompressionStream](https://developer.mozilla.org/en-US/docs/Web/API/CompressionStream) on MDN.
///
/// ## Examples
///
/// ```gleam
/// let assert Ok(compressor) = compression_stream.new(compression_format.Gzip)
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

/// Returns an error if the format is not supported.
///
@external(javascript, "./compression_stream.ffi.mjs", "new_")
pub fn new(format: CompressionFormat) -> Result(CompressionStream, String)

@external(javascript, "./compression_stream.ffi.mjs", "readable")
pub fn readable(of stream: CompressionStream) -> ReadableStream(Uint8Array)

@external(javascript, "./compression_stream.ffi.mjs", "writable")
pub fn writable(of stream: CompressionStream) -> WritableStream(Uint8Array)
