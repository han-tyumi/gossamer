//// Parent module for the compression family — `CompressionStream`
//// and `DecompressionStream`. Hosts the shared
//// [`CompressionFormat`](#CompressionFormat) type.

/// Compression algorithms supported by `CompressionStream` and
/// `DecompressionStream`.
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

  /// Brotli compression.
  Brotli
}
