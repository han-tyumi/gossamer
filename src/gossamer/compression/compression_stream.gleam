import gossamer/compression.{type CompressionError, type CompressionFormat}
import gossamer/stream/readable_stream.{type ReadableStream}
import gossamer/stream/writable_stream.{type WritableStream}

/// A transform stream that compresses its input.
///
/// See [CompressionStream](https://developer.mozilla.org/en-US/docs/Web/API/CompressionStream) on MDN.
///
/// ## Examples
///
/// ```gleam
/// let assert Ok(compressor) = compression_stream.new(compression.Gzip)
///
/// stdin.readable()
/// |> readable_stream.pipe_through(
///   #(
///     compression_stream.readable(compressor),
///     compression_stream.writable(compressor),
///   ),
///   readable_stream.pipe_options(),
/// )
/// |> readable_stream.pipe_to(stdout.writable(), readable_stream.pipe_options())
/// ```
///
@external(javascript, "./compression_stream.type.ts", "CompressionStream$")
pub type CompressionStream

/// Returns `UnsupportedFormat` if the format is not supported by the
/// current runtime.
///
@external(javascript, "./compression_stream.ffi.mjs", "new_")
pub fn new(
  format: CompressionFormat,
) -> Result(CompressionStream, CompressionError)

@external(javascript, "./compression_stream.ffi.mjs", "readable")
pub fn readable(stream: CompressionStream) -> ReadableStream(BitArray)

@external(javascript, "./compression_stream.ffi.mjs", "writable")
pub fn writable(stream: CompressionStream) -> WritableStream(BitArray)
