import gossamer/crypto_key.{type CryptoKey}
import gossamer/hash_algorithm.{type HashAlgorithm}
import gossamer/typed_array.{type TypedArray}

/// Algorithm parameters for `subtle_crypto.derive_bits` and `derive_key`.
///
/// Non-standard or unnamed algorithms use `Other(String)`.
///
pub type DeriveAlgorithm {
  Hkdf(hash: HashAlgorithm, info: TypedArray, salt: TypedArray)
  Pbkdf2(hash: HashAlgorithm, iterations: Int, salt: TypedArray)
  Ecdh(public: CryptoKey)
  Other(String)
}
