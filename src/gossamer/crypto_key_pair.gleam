import gossamer/crypto_key.{type CryptoKey}

/// The CryptoKeyPair dictionary of the Web Crypto API represents a key
/// pair for an asymmetric cryptography algorithm, also known as a
/// public-key algorithm.
///
pub type CryptoKeyPair {
  CryptoKeyPair(public_key: CryptoKey, private_key: CryptoKey)
}
