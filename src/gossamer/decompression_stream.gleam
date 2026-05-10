import gossamer/compression_stream.{type CompressionFormat}
import gossamer/js_error.{type JsError}
import gossamer/readable_stream.{type ReadableStream}
import gossamer/writable_stream.{type WritableStream}

/// A transform stream that decompresses its input.
///
/// See [DecompressionStream](https://developer.mozilla.org/en-US/docs/Web/API/DecompressionStream) on MDN.
///
/// ## Examples
///
/// ```gleam
/// let assert Ok(input) = deno.open_sync("./file.txt.gz", [open.Read])
/// let assert Ok(output) = deno.create_sync("./file.txt")
/// let assert Ok(decompressor) = decompression_stream.new(compression_stream.Gzip)
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

/// Returns an error if the format is not supported.
///
@external(javascript, "./decompression_stream.ffi.mjs", "new_")
pub fn new(format: CompressionFormat) -> Result(DecompressionStream, JsError)

@external(javascript, "./decompression_stream.ffi.mjs", "readable")
pub fn readable(stream: DecompressionStream) -> ReadableStream(BitArray)

@external(javascript, "./decompression_stream.ffi.mjs", "writable")
pub fn writable(stream: DecompressionStream) -> WritableStream(BitArray)
