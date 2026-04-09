import gossamer/hash_algorithm.{type HashAlgorithm}

pub type SignAlgorithm {
  Hmac
  RsassaPkcs1V15
  RsaPss(salt_length: Int)
  Ecdsa(hash: HashAlgorithm)
  Other(String)
}
