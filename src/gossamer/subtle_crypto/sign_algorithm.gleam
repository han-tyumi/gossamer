import gossamer/hash_algorithm.{type HashAlgorithm}

/// Algorithm parameters for `subtle_crypto.sign` and `verify`.
///
/// Non-standard or unnamed algorithms use `Other(String)`.
///
pub type SignAlgorithm {
  Hmac
  RsassaPkcs1V15
  RsaPss(salt_length: Int)
  Ecdsa(hash: HashAlgorithm)
  Other(String)
}
