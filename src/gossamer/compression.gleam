//// Parent module for the compression family — `CompressionStream`
//// and `DecompressionStream`. Hosts `CompressionFormat`, the shared
//// format enum.

/// Compression algorithms supported by `CompressionStream` and
/// `DecompressionStream`.
///
/// Unrecognized or non-standard formats use `Other(String)`.
///
pub type CompressionFormat {
  Deflate
  DeflateRaw
  Gzip
  Brotli
  Other(String)
}
