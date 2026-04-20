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
