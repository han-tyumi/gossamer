import gossamer/aes_algorithm.{type AesAlgorithm}
import gossamer/ec_algorithm.{type EcAlgorithm}
import gossamer/hash_algorithm.{type HashAlgorithm}
import gossamer/key_type.{type KeyType}
import gossamer/key_usage.{type KeyUsage}
import gossamer/named_curve.{type NamedCurve}
import gossamer/rsa_algorithm.{type RsaAlgorithm}
import gossamer/uint8_array.{type Uint8Array}

/// Opaque handle to the underlying JS `CryptoKey`.
///
@external(javascript, "./crypto_key_ref.type.ts", "CryptoKeyRef$")
@internal
pub type CryptoKeyRef

/// A cryptographic key used with `subtle_crypto` operations (encryption,
/// signing, key derivation, etc.).
///
/// See [CryptoKey](https://developer.mozilla.org/en-US/docs/Web/API/CryptoKey) on MDN.
///
pub type CryptoKey {
  CryptoKey(
    algorithm: KeyAlgorithm,
    is_extractable: Bool,
    type_: KeyType,
    usages: List(KeyUsage),
    /// Internal handle to the underlying JS `CryptoKey`.
    ref: CryptoKeyRef,
  )
}

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
