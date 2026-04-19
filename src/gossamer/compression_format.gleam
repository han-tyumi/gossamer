/// Compression algorithms supported by `CompressionStream` and
/// `DecompressionStream`.
///
pub type CompressionFormat {
  Deflate
  DeflateRaw
  Gzip
  Brotli
  Other(String)
}
