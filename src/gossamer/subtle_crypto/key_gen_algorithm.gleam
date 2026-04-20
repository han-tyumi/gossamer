import gossamer/aes_algorithm.{type AesAlgorithm}
import gossamer/hash_algorithm.{type HashAlgorithm}

/// Algorithm parameters for `subtle_crypto.generate_key` (symmetric keys).
///
/// Non-standard or unnamed algorithms use `Other(String)`.
///
pub type KeyGenAlgorithm {
  Aes(name: AesAlgorithm, length: Int)
  HmacGen(hash: HashAlgorithm)
  Other(String)
}
