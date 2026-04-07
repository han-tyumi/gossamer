import gossamer/uint8_array.{type Uint8Array}

pub type KeyPairGenAlgorithm {
  Rsa(
    name: String,
    modulus_length: Int,
    public_exponent: Uint8Array,
    hash: String,
  )
  Ec(name: String, named_curve: String)
}
