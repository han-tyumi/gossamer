import gossamer/aes_algorithm.{type AesAlgorithm}
import gossamer/hash_algorithm.{type HashAlgorithm}

pub type DerivedKeyType {
  AesDerived(name: AesAlgorithm, length: Int)
  HmacDerived(hash: HashAlgorithm)
  Other(String)
}
