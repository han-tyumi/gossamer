//// A transform stream that decompresses its input. Pipe compressed
//// bytes through to recover the original byte stream. Pair with
//// [`gossamer/compression/compression_stream`](./compression_stream.html)
//// for the inverse.

import gossamer/compression.{type CompressionFormat}
import gossamer/stream/readable_stream.{type ReadableStream}
import gossamer/stream/writable_stream.{type WritableStream}

/// A transform stream that decompresses its input. Write compressed
/// bytes to `writable(stream)`; read uncompressed bytes from
/// `readable(stream)`.
///
/// See [DecompressionStream](https://developer.mozilla.org/en-US/docs/Web/API/DecompressionStream) on MDN.
///
/// ## Examples
///
/// ```gleam
/// let assert Ok(decompressor) = decompression_stream.new(compression.Gzip)
/// ```
///
@external(javascript, "./decompression_stream.type.ts", "DecompressionStream$")
pub type DecompressionStream

/// Creates a `DecompressionStream` for the given format. Returns an
/// error if the format is not supported by the current runtime.
/// `Brotli` is not supported on Bun.
///
@external(javascript, "./decompression_stream.ffi.mjs", "new_")
pub fn new(format: CompressionFormat) -> Result(DecompressionStream, Nil)

/// The readable side of the stream — produces uncompressed bytes.
///
@external(javascript, "./decompression_stream.ffi.mjs", "readable")
pub fn readable(stream: DecompressionStream) -> ReadableStream(BitArray)

/// The writable side of the stream — accepts compressed byte chunks.
///
@external(javascript, "./decompression_stream.ffi.mjs", "writable")
pub fn writable(stream: DecompressionStream) -> WritableStream(BitArray)

/// Returns the readable and writable sides of the stream as a tuple.
/// Convenient for passing directly to
/// [`readable_stream.pipe_through`](../stream/readable_stream.html#pipe_through).
///
pub fn read_write_pair(
  stream: DecompressionStream,
) -> #(ReadableStream(BitArray), WritableStream(BitArray)) {
  #(stream |> readable, stream |> writable)
}
