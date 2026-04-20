import gossamer/aes_algorithm.{type AesAlgorithm}
import gossamer/hash_algorithm.{type HashAlgorithm}

/// The target key type for `subtle_crypto.derive_key`.
///
/// Non-standard or unnamed algorithms use `Other(String)`.
///
pub type DerivedKeyType {
  AesDerived(name: AesAlgorithm, length: Int)
  HmacDerived(hash: HashAlgorithm)
  Other(String)
}
