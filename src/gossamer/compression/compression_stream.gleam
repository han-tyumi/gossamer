//// A transform stream that compresses its input. Pipe uncompressed
//// bytes through to produce a compressed byte stream. Pair with
//// [`gossamer/compression/decompression_stream`](./decompression_stream.html)
//// for the inverse.

import gossamer/compression.{type CompressionFormat}
import gossamer/stream/readable_stream.{type ReadableStream}
import gossamer/stream/writable_stream.{type WritableStream}

/// A transform stream that compresses its input. Write uncompressed
/// bytes to `writable(stream)`; read compressed bytes from
/// `readable(stream)`.
///
/// See [CompressionStream](https://developer.mozilla.org/en-US/docs/Web/API/CompressionStream) on MDN.
///
/// ## Examples
///
/// ```gleam
/// let compressor = compression_stream.new(compression.Gzip)
/// ```
///
@external(javascript, "./compression_stream.type.ts", "CompressionStream$")
pub type CompressionStream

/// Creates a `CompressionStream` for the given format.
///
@external(javascript, "./compression_stream.ffi.mjs", "new_")
pub fn new(format: CompressionFormat) -> CompressionStream

/// The readable side of the stream — produces compressed bytes.
///
@external(javascript, "./compression_stream.ffi.mjs", "readable")
pub fn readable(stream: CompressionStream) -> ReadableStream(BitArray)

/// The writable side of the stream — accepts uncompressed byte chunks.
///
@external(javascript, "./compression_stream.ffi.mjs", "writable")
pub fn writable(stream: CompressionStream) -> WritableStream(BitArray)

/// Returns the readable and writable sides of the stream as a tuple.
/// Convenient for passing directly to
/// [`readable_stream.pipe_through`](../stream/readable_stream.html#pipe_through).
///
pub fn read_write_pair(
  stream: CompressionStream,
) -> #(ReadableStream(BitArray), WritableStream(BitArray)) {
  #(stream |> readable, stream |> writable)
}
