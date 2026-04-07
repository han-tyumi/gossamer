import gossamer/compression_format.{type CompressionFormat}
import gossamer/readable_stream.{type ReadableStream}
import gossamer/uint8_array.{type Uint8Array}
import gossamer/writable_stream.{type WritableStream}

/// An API for decompressing a stream of data.
///
/// ## Examples
///
/// ```gleam
/// let assert Ok(input) = deno.open_sync("./file.txt.gz", [open.Read])
/// let assert Ok(output) = deno.create_sync("./file.txt")
/// let assert Ok(decompressor) = decompression_stream.new(compression_format.Gzip)
///
/// fs_file.readable(input)
/// |> readable_stream.pipe_through(
///   #(
///     decompression_stream.readable(decompressor),
///     decompression_stream.writable(decompressor),
///   ),
///   [],
/// )
/// |> readable_stream.pipe_to(fs_file.writable(output), [])
/// ```
///
@external(javascript, "./decompression_stream.type.ts", "DecompressionStream$")
pub type DecompressionStream

/// Returns an error if the format is not supported.
///
@external(javascript, "./decompression_stream.ffi.mjs", "new_")
pub fn new(format: CompressionFormat) -> Result(DecompressionStream, String)

@external(javascript, "./decompression_stream.ffi.mjs", "readable")
pub fn readable(stream: DecompressionStream) -> ReadableStream(Uint8Array)

@external(javascript, "./decompression_stream.ffi.mjs", "writable")
pub fn writable(stream: DecompressionStream) -> WritableStream(Uint8Array)
