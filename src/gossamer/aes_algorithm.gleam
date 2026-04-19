/// AES cipher modes supported by `subtle_crypto`.
///
pub type AesAlgorithm {
  AesCbc
  AesCtr
  AesGcm
  AesKw
  Other(String)
}
