import gossamer/compression.{type CompressionError, type CompressionFormat}
import gossamer/stream/readable_stream.{type ReadableStream}
import gossamer/stream/writable_stream.{type WritableStream}

/// A transform stream that decompresses its input.
///
/// See [DecompressionStream](https://developer.mozilla.org/en-US/docs/Web/API/DecompressionStream) on MDN.
///
/// ## Examples
///
/// ```gleam
/// let assert Ok(input) = deno.open_sync("./file.txt.gz", [open.Read])
/// let assert Ok(output) = deno.create_sync("./file.txt")
/// let assert Ok(decompressor) = decompression_stream.new(compression.Gzip)
///
/// fs_file.readable(input)
/// |> readable_stream.pipe_through(
///   #(
///     decompression_stream.readable(decompressor),
///     decompression_stream.writable(decompressor),
///   ),
///   readable_stream.pipe_options(),
/// )
/// |> readable_stream.pipe_to(
///   fs_file.writable(output),
///   readable_stream.pipe_options(),
/// )
/// ```
///
@external(javascript, "./decompression_stream.type.ts", "DecompressionStream$")
pub type DecompressionStream

/// Returns `UnsupportedFormat` if the format is not supported by the
/// current runtime.
///
@external(javascript, "./decompression_stream.ffi.mjs", "new_")
pub fn new(
  format: CompressionFormat,
) -> Result(DecompressionStream, CompressionError)

@external(javascript, "./decompression_stream.ffi.mjs", "readable")
pub fn readable(stream: DecompressionStream) -> ReadableStream(BitArray)

@external(javascript, "./decompression_stream.ffi.mjs", "writable")
pub fn writable(stream: DecompressionStream) -> WritableStream(BitArray)
