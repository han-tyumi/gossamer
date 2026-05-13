//// Parent module for the compression family — `CompressionStream`
//// and `DecompressionStream`. Hosts `CompressionFormat`, the shared
//// format enum.

/// Compression algorithms supported by `CompressionStream` and
/// `DecompressionStream`.
///
/// Unrecognized or non-standard formats use `Other(String)`.
///
pub type CompressionFormat {
  /// Zlib-wrapped DEFLATE — DEFLATE compressed data inside a zlib
  /// header and Adler-32 trailer.
  Deflate

  /// Raw DEFLATE — DEFLATE compressed data with no wrapper.
  DeflateRaw

  /// Gzip — DEFLATE compressed data wrapped in a gzip header and
  /// CRC-32 trailer.
  Gzip

  /// Brotli compression. Supported by browsers and Node; check
  /// runtime availability before using on Deno and Bun.
  Brotli

  /// Any format name the binding doesn't recognize, passed through
  /// verbatim to the runtime.
  Other(String)
}
