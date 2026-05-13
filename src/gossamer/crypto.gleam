//// Cross-runtime bindings for the Web Cryptography API. The top-level
//// `Crypto` interface (`random_bytes`, `random_uuid`) lives here, along
//// with types shared across `gossamer/crypto/key`,
//// `gossamer/crypto/subtle`, and `gossamer/crypto/jwk`.

/// An allowed use for a `CryptoKey`. A key can only be used with
/// operations matching one of its declared usages.
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

/// Errors raised by `subtle` operations.
pub type CryptoError {
  /// The key's `usages` don't include the capability required for this
  /// operation (e.g., calling `encrypt` with a key whose usages don't
  /// include `Encrypt`). The `usage` payload names the missing
  /// capability.
  KeyUsageMismatch(usage: KeyUsage)

  /// The key's `extractable` flag is `False`, but the operation
  /// (`export_key`, `export_key_jwk`, `wrap_key`, `wrap_key_jwk`)
  /// requires it.
  KeyNotExtractable

  /// The runtime does not support the requested algorithm or
  /// algorithm/operation combination. Corresponds to the
  /// `NotSupportedError` DOMException.
  AlgorithmNotSupported

  /// The key is not appropriate for the requested operation (e.g.,
  /// using an asymmetric key in a symmetric operation). Corresponds to
  /// the `InvalidAccessError` DOMException.
  InvalidAccess

  /// The cryptographic operation failed for an operation-specific
  /// reason — authenticated decryption failed, signature verification
  /// produced an invalid result, etc. Corresponds to the
  /// `OperationError` DOMException.
  OperationFailed

  /// The input data is malformed for the operation (e.g., an imported
  /// key has the wrong structure). Corresponds to the `DataError`
  /// DOMException.
  DataMalformed

  /// The input exceeds runtime-imposed size limits. Corresponds to the
  /// `QuotaExceededError` DOMException.
  QuotaExceeded
}

/// AES cipher modes supported by `subtle`.
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

/// RSA algorithms supported by `subtle`.
///
/// Unrecognized or non-standard algorithms use `RsaOther(String)`.
///
pub type RsaAlgorithm {
  RsaOaep
  RsaPss
  RsaSsaPkcs1V15
  RsaOther(String)
}

/// Elliptic curve algorithms supported by `subtle`.
///
/// Unrecognized or non-standard algorithms use `EcOther(String)`.
///
pub type EcAlgorithm {
  EcDh
  EcDsa
  EcOther(String)
}

/// Cryptographic hash algorithms supported by `subtle`.
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

/// A named elliptic curve used by ECDH and ECDSA operations in
/// `subtle`.
///
/// Unrecognized or non-standard curves use `NamedCurveOther(String)`.
///
pub type NamedCurve {
  P256
  P384
  P521
  NamedCurveOther(String)
}

/// Whether a `CryptoKey` is public, private, or secret (symmetric).
///
pub type KeyType {
  Private
  Public
  Secret
}

/// The algorithm and parameters bound to a `CryptoKey`, read via
/// `key.algorithm`.
///
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

/// Generates `length` cryptographically strong random bytes. A
/// non-positive `length` returns an empty `BitArray`.
///
@external(javascript, "./crypto.ffi.mjs", "random_bytes")
pub fn random_bytes(length: Int) -> BitArray

/// Generates a random UUID (version 4).
///
@external(javascript, "./crypto.ffi.mjs", "random_uuid")
pub fn random_uuid() -> String
