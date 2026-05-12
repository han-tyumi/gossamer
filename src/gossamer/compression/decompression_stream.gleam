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

/// Returns an error if the format is not supported by the current
/// runtime.
///
@external(javascript, "./decompression_stream.ffi.mjs", "new_")
pub fn new(format: CompressionFormat) -> Result(DecompressionStream, Nil)

@external(javascript, "./decompression_stream.ffi.mjs", "readable")
pub fn readable(stream: DecompressionStream) -> ReadableStream(BitArray)

@external(javascript, "./decompression_stream.ffi.mjs", "writable")
pub fn writable(stream: DecompressionStream) -> WritableStream(BitArray)
