import gossamer/crypto_key.{type CryptoKey}
import gossamer/hash_algorithm.{type HashAlgorithm}

/// Algorithm parameters for `subtle_crypto.derive_bits` and `derive_key`.
///
/// Non-standard or unnamed algorithms use `Other(String)`.
///
pub type DeriveAlgorithm {
  Hkdf(hash: HashAlgorithm, info: BitArray, salt: BitArray)
  Pbkdf2(hash: HashAlgorithm, iterations: Int, salt: BitArray)
  Ecdh(public: CryptoKey)
  Other(String)
}
