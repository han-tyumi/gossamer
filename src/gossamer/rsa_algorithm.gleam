/// RSA algorithms supported by `subtle_crypto`.
///
/// Unrecognized or non-standard algorithms use `Other(String)`.
///
pub type RsaAlgorithm {
  RsaOaep
  RsaPss
  RsassaPkcs1V15
  Other(String)
}
