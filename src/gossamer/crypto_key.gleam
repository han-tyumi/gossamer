/// A cryptographic key used with `subtle_crypto` operations (encryption,
/// signing, key derivation, etc.).
///
/// See [CryptoKey](https://developer.mozilla.org/en-US/docs/Web/API/CryptoKey) on MDN.
///
@external(javascript, "./crypto_key.type.ts", "CryptoKey$")
pub type CryptoKey

/// AES cipher modes supported by `subtle_crypto`.
///
/// Unrecognized or non-standard algorithms use `AesOther(String)`.
///
pub type AesAlgorithm {
  AesCbc
  AesCtr
  AesGcm
  AesKw
  AesOther(String)
}

/// RSA algorithms supported by `subtle_crypto`.
///
/// Unrecognized or non-standard algorithms use `RsaOther(String)`.
///
pub type RsaAlgorithm {
  RsaOaep
  RsaPss
  RsaSsaPkcs1V15
  RsaOther(String)
}

/// Elliptic curve algorithms supported by `subtle_crypto`.
///
/// Unrecognized or non-standard algorithms use `EcOther(String)`.
///
pub type EcAlgorithm {
  EcDh
  EcDsa
  EcOther(String)
}

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
pub type KeyType {
  Private
  Public
  Secret
}

/// An allowed use for a `CryptoKey`. A key can only be used with operations
/// matching one of its declared usages.
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

pub type KeyAlgorithm {
  Aes(name: AesAlgorithm, length: Int)
  Ec(name: EcAlgorithm, named_curve: NamedCurve)
  Hmac(hash: HashAlgorithm, length: Int)
  Rsa(
    name: RsaAlgorithm,
    modulus_length: Int,
    public_exponent: BitArray,
    hash: HashAlgorithm,
  )
}

@external(javascript, "./crypto_key.ffi.mjs", "algorithm")
pub fn algorithm(key: CryptoKey) -> KeyAlgorithm

@external(javascript, "./crypto_key.ffi.mjs", "is_extractable")
pub fn is_extractable(key: CryptoKey) -> Bool

@external(javascript, "./crypto_key.ffi.mjs", "type_")
pub fn type_(key: CryptoKey) -> KeyType

@external(javascript, "./crypto_key.ffi.mjs", "usages")
pub fn usages(key: CryptoKey) -> List(KeyUsage)
