import gossamer/aes_algorithm.{type AesAlgorithm}
import gossamer/ec_algorithm.{type EcAlgorithm}
import gossamer/hash_algorithm.{type HashAlgorithm}
import gossamer/key_type.{type KeyType}
import gossamer/key_usage.{type KeyUsage}
import gossamer/named_curve.{type NamedCurve}
import gossamer/rsa_algorithm.{type RsaAlgorithm}
import gossamer/uint8_array.{type Uint8Array}

/// A cryptographic key used with `subtle_crypto` operations (encryption,
/// signing, key derivation, etc.).
///
/// See [CryptoKey](https://developer.mozilla.org/en-US/docs/Web/API/CryptoKey) on MDN.
///
@external(javascript, "./crypto_key.type.ts", "CryptoKey$")
pub type CryptoKey

pub type KeyAlgorithm {
  Aes(name: AesAlgorithm, length: Int)
  Ec(name: EcAlgorithm, named_curve: NamedCurve)
  Hmac(hash: HashAlgorithm, length: Int)
  Rsa(
    name: RsaAlgorithm,
    modulus_length: Int,
    public_exponent: Uint8Array,
    hash: HashAlgorithm,
  )
}

@external(javascript, "./crypto_key.ffi.mjs", "algorithm")
pub fn algorithm(of key: CryptoKey) -> KeyAlgorithm

@external(javascript, "./crypto_key.ffi.mjs", "is_extractable")
pub fn is_extractable(key: CryptoKey) -> Bool

@external(javascript, "./crypto_key.ffi.mjs", "type_")
pub fn type_(of key: CryptoKey) -> KeyType

@external(javascript, "./crypto_key.ffi.mjs", "usages")
pub fn usages(of key: CryptoKey) -> List(KeyUsage)
