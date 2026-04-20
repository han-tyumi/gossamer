/// AES cipher modes supported by `subtle_crypto`.
///
/// Unrecognized or non-standard algorithms use `Other(String)`.
///
pub type AesAlgorithm {
  AesCbc
  AesCtr
  AesGcm
  AesKw
  Other(String)
}
