import gossamer/compression_format.{type CompressionFormat}
import gossamer/readable_stream.{type ReadableStream}
import gossamer/uint8_array.{type Uint8Array}
import gossamer/writable_stream.{type WritableStream}

/// An API for compressing a stream of data.
///
/// ## Examples
///
/// ```gleam
/// let compressor = compression_stream.new(compression_format.Gzip)
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

/// Creates a new `CompressionStream` object which compresses a stream of
/// data.
///
/// Throws a `TypeError` if the format passed to the constructor is not
/// supported.
///
@external(javascript, "./compression_stream.ffi.mjs", "new_")
pub fn new(format: CompressionFormat) -> CompressionStream

@external(javascript, "./compression_stream.ffi.mjs", "readable")
pub fn readable(stream: CompressionStream) -> ReadableStream(Uint8Array)

@external(javascript, "./compression_stream.ffi.mjs", "writable")
pub fn writable(stream: CompressionStream) -> WritableStream(Uint8Array)
