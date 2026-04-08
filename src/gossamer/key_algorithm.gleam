import gossamer/uint8_array.{type Uint8Array}

pub type KeyAlgorithm {
  Aes(name: String, length: Int)
  Ec(name: String, named_curve: String)
  Hmac(name: String, hash: String, length: Int)
  Rsa(
    name: String,
    modulus_length: Int,
    public_exponent: Uint8Array,
    hash: String,
  )
}
