//// Cross-runtime bindings for the Web Cryptography API. The top-level
//// `Crypto` interface (`random_bytes`, `random_uuid`) lives here, along
//// with types shared across `gossamer/crypto/key`,
//// `gossamer/crypto/subtle`, and `gossamer/crypto/jwk`.

/// An allowed use for a `CryptoKey`. A key can only be used with
/// operations matching one of its declared usages.
///
pub type KeyUsage {
  /// The key may be used to decrypt ciphertext.
  Decrypt

  /// The key may be used to derive raw byte material.
  DeriveBits

  /// The key may be used to derive another `CryptoKey`.
  DeriveKey

  /// The key may be used to encrypt plaintext.
  Encrypt

  /// The key may be used to produce a signature.
  Sign

  /// The key may be used to decrypt a wrapped key.
  UnwrapKey

  /// The key may be used to verify a signature.
  Verify

  /// The key may be used to encrypt another key for transport.
  WrapKey
}

/// Errors raised by `subtle` operations.
///
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
  /// AES with Cipher Block Chaining — symmetric encryption.
  AesCbc

  /// AES with Counter mode — symmetric encryption.
  AesCtr

  /// AES with Galois/Counter Mode — authenticated symmetric encryption.
  AesGcm

  /// AES Key Wrap — symmetric encryption of another key.
  AesKw

  /// Any algorithm name the binding doesn't recognize, passed through
  /// verbatim to the runtime.
  AesOther(String)
}

/// RSA algorithms supported by `subtle`.
///
/// Unrecognized or non-standard algorithms use `RsaOther(String)`.
///
pub type RsaAlgorithm {
  /// RSA with Optimal Asymmetric Encryption Padding — asymmetric
  /// encryption.
  RsaOaep

  /// RSA with Probabilistic Signature Scheme — asymmetric signing.
  RsaPss

  /// RSA with PKCS #1 v1.5 padding — legacy asymmetric signing.
  RsaSsaPkcs1V15

  /// Any algorithm name the binding doesn't recognize, passed through
  /// verbatim to the runtime.
  RsaOther(String)
}

/// Elliptic curve algorithms supported by `subtle`.
///
/// Unrecognized or non-standard algorithms use `EcOther(String)`.
///
pub type EcAlgorithm {
  /// Elliptic Curve Diffie-Hellman — key agreement.
  EcDh

  /// Elliptic Curve Digital Signature Algorithm — signing.
  EcDsa

  /// Any algorithm name the binding doesn't recognize, passed through
  /// verbatim to the runtime.
  EcOther(String)
}

/// Cryptographic hash algorithms supported by `subtle`.
///
/// Unrecognized or non-standard algorithms use `HashOther(String)`.
///
pub type HashAlgorithm {
  /// SHA-1 — included for legacy compatibility; avoid for new
  /// signatures.
  Sha1

  /// SHA-2 with 256-bit output.
  Sha256

  /// SHA-2 with 384-bit output.
  Sha384

  /// SHA-2 with 512-bit output.
  Sha512

  /// Any hash name the binding doesn't recognize, passed through
  /// verbatim to the runtime.
  HashOther(String)
}

/// A named elliptic curve used by ECDH and ECDSA operations in
/// `subtle`.
///
/// Unrecognized or non-standard curves use `NamedCurveOther(String)`.
///
pub type NamedCurve {
  /// NIST P-256 (secp256r1).
  P256

  /// NIST P-384 (secp384r1).
  P384

  /// NIST P-521 (secp521r1).
  P521

  /// Any curve name the binding doesn't recognize, passed through
  /// verbatim to the runtime.
  NamedCurveOther(String)
}

/// Whether a `CryptoKey` is public, private, or secret (symmetric).
///
pub type KeyKind {
  /// The private half of an asymmetric key pair.
  Private

  /// The public half of an asymmetric key pair.
  Public

  /// A symmetric key (e.g., AES, HMAC).
  Secret
}

/// The algorithm and parameters bound to a `CryptoKey`, read via
/// `key.algorithm`.
///
pub type KeyAlgorithm {
  /// An AES key. `length` is the key size in bits (128, 192, or 256).
  Aes(name: AesAlgorithm, length: Int)

  /// An elliptic-curve key bound to `named_curve`.
  Ec(name: EcAlgorithm, named_curve: NamedCurve)

  /// An Ed25519 signing key.
  Ed25519

  /// An HKDF base key for key derivation.
  Hkdf

  /// An HMAC key bound to `hash` with `length` bits of key material.
  Hmac(hash: HashAlgorithm, length: Int)

  /// A PBKDF2 base key for password-based derivation.
  Pbkdf2

  /// An RSA key with `modulus_length` bits and the given `hash`.
  /// `public_exponent` is the raw bytes of the exponent (commonly
  /// `<<1, 0, 1>>` for 65537).
  Rsa(
    name: RsaAlgorithm,
    modulus_length: Int,
    public_exponent: BitArray,
    hash: HashAlgorithm,
  )

  /// An X25519 key-agreement key.
  X25519
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
