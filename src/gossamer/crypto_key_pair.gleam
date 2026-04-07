import gossamer/crypto_key.{type CryptoKey}

pub type CryptoKeyPair {
  CryptoKeyPair(public_key: CryptoKey, private_key: CryptoKey)
}
