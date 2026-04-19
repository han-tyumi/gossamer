import gossamer/crypto_key.{type CryptoKey}
import gossamer/hash_algorithm.{type HashAlgorithm}
import gossamer/uint8_array.{type Uint8Array}

/// Algorithm parameters for `subtle_crypto.derive_bits` and `derive_key`.
///
pub type DeriveAlgorithm {
  Hkdf(hash: HashAlgorithm, info: Uint8Array, salt: Uint8Array)
  Pbkdf2(hash: HashAlgorithm, iterations: Int, salt: Uint8Array)
  Ecdh(public: CryptoKey)
  Other(String)
}
