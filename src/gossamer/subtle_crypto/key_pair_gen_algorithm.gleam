import gossamer/ec_algorithm.{type EcAlgorithm}
import gossamer/hash_algorithm.{type HashAlgorithm}
import gossamer/named_curve.{type NamedCurve}
import gossamer/rsa_algorithm.{type RsaAlgorithm}
import gossamer/uint8_array.{type Uint8Array}

pub type KeyPairGenAlgorithm {
  Rsa(
    name: RsaAlgorithm,
    modulus_length: Int,
    public_exponent: Uint8Array,
    hash: HashAlgorithm,
  )
  Ec(name: EcAlgorithm, named_curve: NamedCurve)
  Ed25519
  X25519
  Other(String)
}
