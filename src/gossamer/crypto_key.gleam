import gossamer/aes_algorithm.{type AesAlgorithm}
import gossamer/buffer/uint8_array.{type Uint8Array}
import gossamer/ec_algorithm.{type EcAlgorithm}
import gossamer/rsa_algorithm.{type RsaAlgorithm}

/// A cryptographic key used with `subtle_crypto` operations (encryption,
/// signing, key derivation, etc.).
///
/// See [CryptoKey](https://developer.mozilla.org/en-US/docs/Web/API/CryptoKey) on MDN.
///
@external(javascript, "./crypto_key.type.ts", "CryptoKey$")
pub type CryptoKey

/// Cryptographic hash algorithms supported by `subtle_crypto`.
///
/// Unrecognized or non-standard algorithms use `HashOther(String)`.
///
pub type HashAlgorithm {
  Sha1
  Sha256
  Sha384
  Sha512
  HashOther(String)
}

/// Whether a `CryptoKey` is public, private, or secret (symmetric).
///
/// Unrecognized values use `KeyTypeOther(String)`.
///
pub type KeyType {
  Private
  Public
  Secret
  KeyTypeOther(String)
}

/// An allowed use for a `CryptoKey`. A key can only be used with operations
/// matching one of its declared usages.
///
/// Unrecognized values use `KeyUsageOther(String)`.
///
pub type KeyUsage {
  Decrypt
  DeriveBits
  DeriveKey
  Encrypt
  Sign
  UnwrapKey
  Verify
  WrapKey
  KeyUsageOther(String)
}

/// A named elliptic curve used by ECDH and ECDSA operations in
/// `subtle_crypto`.
///
/// Unrecognized or non-standard curves use `NamedCurveOther(String)`.
///
pub type NamedCurve {
  P256
  P384
  P521
  NamedCurveOther(String)
}

pub type Fields {
  Fields(
    algorithm: KeyAlgorithm,
    is_extractable: Bool,
    type_: KeyType,
    usages: List(KeyUsage),
  )
}

@external(javascript, "./crypto_key.ffi.mjs", "to_fields")
pub fn to_fields(key: CryptoKey) -> Fields

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
