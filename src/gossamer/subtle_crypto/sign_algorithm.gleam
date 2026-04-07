pub type SignAlgorithm {
  Name(String)
  Hmac
  RsassaPkcs1V15
  RsaPss(salt_length: Int)
  Ecdsa(hash: String)
}
