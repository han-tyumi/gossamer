//// Parent module for the compression family — `CompressionStream`
//// and `DecompressionStream`. Hosts `CompressionFormat` (the shared
//// format enum) and `CompressionError` (the shared error type).

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

/// Errors raised by `CompressionStream` and `DecompressionStream`
/// operations.
pub type CompressionError {
  /// The compression format is not supported by the current runtime.
  UnsupportedFormat
}
