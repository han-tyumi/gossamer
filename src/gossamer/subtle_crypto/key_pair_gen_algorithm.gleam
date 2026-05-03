import gossamer/ec_algorithm.{type EcAlgorithm}
import gossamer/hash_algorithm.{type HashAlgorithm}
import gossamer/named_curve.{type NamedCurve}
import gossamer/rsa_algorithm.{type RsaAlgorithm}
import gossamer/typed_array.{type TypedArray}

/// Algorithm parameters for `subtle_crypto.generate_key_pair`
/// (asymmetric keys).
///
/// Non-standard or unnamed algorithms use `Other(String)`.
///
pub type KeyPairGenAlgorithm {
  Rsa(
    name: RsaAlgorithm,
    modulus_length: Int,
    public_exponent: TypedArray,
    hash: HashAlgorithm,
  )
  Ec(name: EcAlgorithm, named_curve: NamedCurve)
  Ed25519
  X25519
  Other(String)
}
