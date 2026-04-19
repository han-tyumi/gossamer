/// RSA algorithms supported by `subtle_crypto`.
///
pub type RsaAlgorithm {
  RsaOaep
  RsaPss
  RsassaPkcs1V15
  Other(String)
}
