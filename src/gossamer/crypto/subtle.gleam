//// The `SubtleCrypto` interface from the Web Cryptography API — the
//// low-level cryptographic primitives. Operations include hashing
//// ([`digest`](#digest)), symmetric and asymmetric encryption
//// ([`encrypt`](#encrypt), [`decrypt`](#decrypt)), signing and
//// verification ([`sign`](#sign), [`verify`](#verify)), key generation
//// ([`generate_key`](#generate_key),
//// [`generate_key_pair`](#generate_key_pair)), key derivation
//// ([`derive_bits`](#derive_bits), [`derive_key`](#derive_key)), and
//// key serialization ([`import_key`](#import_key),
//// [`export_key`](#export_key), [`wrap_key`](#wrap_key),
//// [`unwrap_key`](#unwrap_key)).
////
//// Every operation returns `Promise(Result(_, CryptoError))`. Key-usage
//// and extractability constraints are checked before dispatch and
//// surface as typed `CryptoError` variants.
////
//// See [SubtleCrypto](https://developer.mozilla.org/en-US/docs/Web/API/SubtleCrypto) on MDN.

import gleam/javascript/promise.{type Promise}
import gleam/option.{type Option}
import gossamer/crypto.{
  type AesAlgorithm, type CryptoError, type EcAlgorithm, type HashAlgorithm,
  type KeyUsage, type NamedCurve, type RsaAlgorithm,
}
import gossamer/crypto/jwk.{type JsonWebKey}
import gossamer/crypto/key.{type CryptoKey}

/// A public/private key pair produced by [`generate_key_pair`](#generate_key_pair).
///
pub type CryptoKeyPair {
  CryptoKeyPair(public_key: CryptoKey, private_key: CryptoKey)
}

/// The serialization format of a key imported or exported via
/// `subtle`.
///
pub type KeyFormat {
  /// PKCS #8 — encoded private-key format.
  Pkcs8

  /// Raw byte material — used for symmetric keys.
  Raw

  /// SubjectPublicKeyInfo — encoded public-key format.
  Spki
}

/// Algorithm parameters for `derive_bits` and `derive_key`.
///
pub type DeriveAlgorithm {
  /// HMAC-based Key Derivation Function with the given `hash`,
  /// context-binding `info`, and `salt`.
  DeriveHkdf(hash: HashAlgorithm, info: BitArray, salt: BitArray)

  /// Password-Based Key Derivation Function 2 with the given `hash`,
  /// `iterations`, and `salt`.
  DerivePbkdf2(hash: HashAlgorithm, iterations: Int, salt: BitArray)

  /// Elliptic Curve Diffie-Hellman key agreement with the given peer
  /// `public` key.
  DeriveEcDh(public: CryptoKey)

  /// X25519 key agreement with the given peer `public` key.
  DeriveX25519(public: CryptoKey)
}

/// Symmetric-key parameters shared by [`generate_key`](#generate_key)
/// and [`derive_key`](#derive_key) to describe the key to produce.
///
pub type SymmetricKeyParams {
  /// An AES key of `length` bits.
  Aes(name: AesAlgorithm, length: Int)

  /// An HMAC key bound to `hash`.
  Hmac(hash: HashAlgorithm)
}

/// Algorithm parameters for `encrypt` and `decrypt`.
///
pub type EncryptAlgorithm {
  /// AES-CBC with the given initialization vector.
  EncryptAesCbc(iv: BitArray)

  /// AES-GCM with the given initialization vector, additional
  /// authenticated data, and authentication `tag_length` in bits.
  /// Pass `<<>>` for `additional_data` for no additional authenticated
  /// data; pass `None` for `tag_length` for the spec default (128 bits).
  EncryptAesGcm(
    iv: BitArray,
    additional_data: BitArray,
    tag_length: Option(Int),
  )

  /// AES-CTR with the given `counter` block and counter `length` in
  /// bits.
  EncryptAesCtr(counter: BitArray, length: Int)

  /// RSA-OAEP with the given `label`. Pass `<<>>` for the spec
  /// default (no label).
  EncryptRsaOaep(label: BitArray)
}

/// Algorithm parameters for `import_key` and `import_key_jwk`.
///
pub type ImportAlgorithm {
  /// Import a raw AES key for the given AES mode.
  ImportAes(name: AesAlgorithm)

  /// Import an HMAC key with the given `hash`.
  ImportHmac(hash: HashAlgorithm)

  /// Import an RSA key with the given algorithm and `hash`.
  ImportRsaHashed(name: RsaAlgorithm, hash: HashAlgorithm)

  /// Import an elliptic-curve key with the given algorithm and
  /// `named_curve`.
  ImportEc(name: EcAlgorithm, named_curve: NamedCurve)

  /// Import an Ed25519 signing key.
  ImportEd25519

  /// Import an X25519 key-agreement key.
  ImportX25519

  /// Import an HKDF base key for key derivation.
  ImportHkdf

  /// Import a PBKDF2 base key for password-based derivation.
  ImportPbkdf2
}

/// Algorithm parameters for `generate_key_pair` (asymmetric keys).
///
pub type KeyPairGenAlgorithm {
  /// Generate an RSA key pair with `modulus_length` bits, the given
  /// `public_exponent` bytes, and `hash`.
  KeyPairGenRsa(
    name: RsaAlgorithm,
    modulus_length: Int,
    public_exponent: BitArray,
    hash: HashAlgorithm,
  )

  /// Generate an elliptic-curve key pair on `named_curve`.
  KeyPairGenEc(name: EcAlgorithm, named_curve: NamedCurve)

  /// Generate an Ed25519 signing key pair.
  KeyPairGenEd25519

  /// Generate an X25519 key-agreement key pair.
  KeyPairGenX25519
}

/// Algorithm parameters for `sign` and `verify`.
///
pub type SignAlgorithm {
  /// Sign or verify with an HMAC key.
  SignHmac

  /// Sign or verify with RSA-SSA-PKCS1-v1_5.
  SignRsaSsaPkcs1V15

  /// Sign or verify with RSA-PSS using `salt_length` bytes of salt.
  SignRsaPss(salt_length: Int)

  /// Sign or verify with ECDSA using the given `hash`.
  SignEcDsa(hash: HashAlgorithm)

  /// Sign or verify with Ed25519.
  SignEd25519
}

/// Algorithm parameters for `wrap_key` and `unwrap_key`.
///
pub type WrapAlgorithm {
  /// Wrap or unwrap with AES-CBC and the given initialization vector.
  WrapAesCbc(iv: BitArray)

  /// Wrap or unwrap with AES-CTR using the given `counter` block and
  /// counter `length` in bits.
  WrapAesCtr(counter: BitArray, length: Int)

  /// Wrap or unwrap with AES-GCM, the given initialization vector,
  /// additional authenticated data, and authentication `tag_length`
  /// in bits. Pass `<<>>` for `additional_data` for no additional
  /// authenticated data; pass `None` for `tag_length` for the spec
  /// default (128 bits).
  WrapAesGcm(iv: BitArray, additional_data: BitArray, tag_length: Option(Int))

  /// Wrap or unwrap with AES Key Wrap (RFC 3394). The wrapping key
  /// must be an AES-KW `CryptoKey`.
  WrapAesKw

  /// Wrap or unwrap with RSA-OAEP and the given `label`. Pass `<<>>`
  /// for the spec default (no label).
  WrapRsaOaep(label: BitArray)
}

/// Computes a cryptographic hash of `data`.
///
@external(javascript, "./subtle.ffi.mjs", "digest")
pub fn digest(
  algorithm algorithm: HashAlgorithm,
  data data: BitArray,
) -> Promise(BitArray)

/// Encrypts `data` with `key` using `algorithm`. Returns
/// `Error(KeyUsageMismatch(Encrypt))` if `key.usages` doesn't include
/// `Encrypt`, `Error(AlgorithmNotSupported)` if the runtime doesn't
/// support the algorithm, `Error(InvalidAccess)` if the algorithm
/// doesn't match the key, or `Error(OperationFailed)` if the data is
/// invalid for the algorithm.
///
@external(javascript, "./subtle.ffi.mjs", "encrypt")
pub fn encrypt(
  algorithm algorithm: EncryptAlgorithm,
  key key: CryptoKey,
  data data: BitArray,
) -> Promise(Result(BitArray, CryptoError))

/// Decrypts `data` with `key` using `algorithm`. Returns
/// `Error(KeyUsageMismatch(Decrypt))` if `key.usages` doesn't include
/// `Decrypt`, `Error(AlgorithmNotSupported)` if the runtime doesn't
/// support the algorithm, `Error(InvalidAccess)` if the algorithm
/// doesn't match the key, or `Error(OperationFailed)` if `data` isn't
/// valid ciphertext for the algorithm.
///
@external(javascript, "./subtle.ffi.mjs", "decrypt")
pub fn decrypt(
  algorithm algorithm: EncryptAlgorithm,
  key key: CryptoKey,
  data data: BitArray,
) -> Promise(Result(BitArray, CryptoError))

/// Produces a digital signature of `data` with `key`. Returns
/// `Error(KeyUsageMismatch(Sign))` if `key.usages` doesn't include
/// `Sign`, `Error(AlgorithmNotSupported)` if the runtime doesn't
/// support the algorithm, or `Error(InvalidAccess)` if the algorithm
/// doesn't match the key.
///
@external(javascript, "./subtle.ffi.mjs", "sign")
pub fn sign(
  algorithm algorithm: SignAlgorithm,
  key key: CryptoKey,
  data data: BitArray,
) -> Promise(Result(BitArray, CryptoError))

/// Verifies `signature` against `data` using `key`. Returns
/// `Error(KeyUsageMismatch(Verify))` if `key.usages` doesn't include
/// `Verify`, `Error(AlgorithmNotSupported)` if the runtime doesn't
/// support the algorithm, or `Error(InvalidAccess)` if the algorithm
/// doesn't match the key. `Ok(False)` means the signature is well-formed
/// but invalid for the data.
///
@external(javascript, "./subtle.ffi.mjs", "verify")
pub fn verify(
  algorithm algorithm: SignAlgorithm,
  key key: CryptoKey,
  signature signature: BitArray,
  data data: BitArray,
) -> Promise(Result(Bool, CryptoError))

/// Generates a new symmetric `CryptoKey`. Returns
/// `Error(AlgorithmNotSupported)` if the runtime doesn't support the
/// algorithm, or `Error(InvalidSyntax)` if `usages` is empty.
///
@external(javascript, "./subtle.ffi.mjs", "generate_key")
pub fn generate_key(
  algorithm algorithm: SymmetricKeyParams,
  extractable extractable: Bool,
  usages usages: List(KeyUsage),
) -> Promise(Result(CryptoKey, CryptoError))

/// Generates a new public/private key pair. Returns
/// `Error(AlgorithmNotSupported)` if the runtime doesn't support the
/// algorithm, or `Error(InvalidSyntax)` if `usages` is empty for an
/// algorithm that requires it. Equivalent to JavaScript's
/// `SubtleCrypto.generateKey` with an asymmetric-key algorithm.
///
@external(javascript, "./subtle.ffi.mjs", "generate_key_pair")
pub fn generate_key_pair(
  algorithm algorithm: KeyPairGenAlgorithm,
  extractable extractable: Bool,
  usages usages: List(KeyUsage),
) -> Promise(Result(CryptoKeyPair, CryptoError))

/// Imports a raw key from `data`. Returns
/// `Error(AlgorithmNotSupported)` if the runtime doesn't support the
/// algorithm, `Error(DataMalformed)` if `data` doesn't match
/// `format`, or `Error(InvalidSyntax)` if `usages` is empty for an
/// algorithm that requires it.
///
@external(javascript, "./subtle.ffi.mjs", "import_key")
pub fn import_key(
  format format: KeyFormat,
  key_data data: BitArray,
  algorithm algorithm: ImportAlgorithm,
  extractable extractable: Bool,
  usages usages: List(KeyUsage),
) -> Promise(Result(CryptoKey, CryptoError))

/// Imports a key from a JSON Web Key. Returns
/// `Error(AlgorithmNotSupported)` if the runtime doesn't support the
/// algorithm, `Error(DataMalformed)` if `data` is malformed, or
/// `Error(InvalidSyntax)` if `usages` is empty for an algorithm that
/// requires it. Equivalent to JavaScript's `SubtleCrypto.importKey`
/// with format `"jwk"`.
///
@external(javascript, "./subtle.ffi.mjs", "import_key_jwk")
pub fn import_key_jwk(
  key_data data: JsonWebKey,
  algorithm algorithm: ImportAlgorithm,
  extractable extractable: Bool,
  usages usages: List(KeyUsage),
) -> Promise(Result(CryptoKey, CryptoError))

/// Exports `key` in the given `format`. Returns
/// `Error(KeyNotExtractable)` if `key.extractable` is `False`, or
/// `Error(AlgorithmNotSupported)` if `format` isn't supported for the
/// key's algorithm.
///
@external(javascript, "./subtle.ffi.mjs", "export_key")
pub fn export_key(
  format format: KeyFormat,
  key key: CryptoKey,
) -> Promise(Result(BitArray, CryptoError))

/// Exports `key` as a JSON Web Key. Returns `Error(KeyNotExtractable)`
/// if `key.extractable` is `False`, or `Error(AlgorithmNotSupported)` if
/// the key's algorithm can't be exported in JWK format. Equivalent to
/// JavaScript's `SubtleCrypto.exportKey` with format `"jwk"`.
///
@external(javascript, "./subtle.ffi.mjs", "export_key_jwk")
pub fn export_key_jwk(
  key: CryptoKey,
) -> Promise(Result(JsonWebKey, CryptoError))

/// Derives bits of shared secret from a base key. Returns
/// `Error(KeyUsageMismatch(DeriveBits))` if `base_key.usages` doesn't
/// include `DeriveBits`, `Error(InvalidAccess)` if `algorithm` doesn't
/// match `base_key`, or `Error(AlgorithmNotSupported)` if the runtime
/// doesn't support the algorithm.
///
@external(javascript, "./subtle.ffi.mjs", "derive_bits")
pub fn derive_bits(
  algorithm algorithm: DeriveAlgorithm,
  base_key key: CryptoKey,
  length length: Int,
) -> Promise(Result(BitArray, CryptoError))

/// Derives a new `CryptoKey` from a base key. Returns
/// `Error(KeyUsageMismatch(DeriveKey))` if `base_key.usages` doesn't
/// include `DeriveKey`, `Error(InvalidAccess)` if `algorithm` doesn't
/// match `base_key`, `Error(AlgorithmNotSupported)` if the runtime
/// doesn't support the algorithm, or `Error(InvalidSyntax)` if `usages`
/// is empty for a derived-key type that requires it.
///
@external(javascript, "./subtle.ffi.mjs", "derive_key")
pub fn derive_key(
  algorithm algorithm: DeriveAlgorithm,
  base_key key: CryptoKey,
  derived_key_type derived_key_type: SymmetricKeyParams,
  extractable extractable: Bool,
  usages usages: List(KeyUsage),
) -> Promise(Result(CryptoKey, CryptoError))

/// Exports `key` in raw form and encrypts it with `wrapping_key`.
/// Returns `Error(KeyNotExtractable)` if `key.extractable` is `False`,
/// `Error(KeyUsageMismatch(WrapKey))` if `wrapping_key.usages` doesn't
/// include `WrapKey`, `Error(InvalidAccess)` if `algorithm` doesn't
/// match `wrapping_key`, or `Error(AlgorithmNotSupported)` if the
/// runtime doesn't support the wrapping algorithm.
///
@external(javascript, "./subtle.ffi.mjs", "wrap_key")
pub fn wrap_key(
  format format: KeyFormat,
  key key: CryptoKey,
  wrapping_key wrapping_key: CryptoKey,
  algorithm algorithm: WrapAlgorithm,
) -> Promise(Result(BitArray, CryptoError))

/// Like [`wrap_key`](#wrap_key), but exports `key` as a JSON Web Key
/// before wrapping. Equivalent to JavaScript's `SubtleCrypto.wrapKey`
/// with format `"jwk"`.
///
@external(javascript, "./subtle.ffi.mjs", "wrap_key_jwk")
pub fn wrap_key_jwk(
  key key: CryptoKey,
  wrapping_key wrapping_key: CryptoKey,
  algorithm algorithm: WrapAlgorithm,
) -> Promise(Result(BitArray, CryptoError))

/// Decrypts `wrapped_key` with `unwrapping_key` and imports the result.
/// Returns `Error(KeyUsageMismatch(UnwrapKey))` if `unwrapping_key.usages`
/// doesn't include `UnwrapKey`, `Error(AlgorithmNotSupported)` if the
/// runtime doesn't support the unwrap or import algorithm,
/// `Error(OperationFailed)` if the unwrapping fails,
/// `Error(DataMalformed)` if the decrypted bytes aren't a valid key, or
/// `Error(InvalidSyntax)` if `usages` is empty for an unwrapped-key
/// algorithm that requires it.
///
@external(javascript, "./subtle.ffi.mjs", "unwrap_key")
pub fn unwrap_key(
  format format: KeyFormat,
  wrapped_key wrapped_key: BitArray,
  unwrapping_key unwrapping_key: CryptoKey,
  unwrap_algorithm unwrap_algorithm: WrapAlgorithm,
  unwrapped_key_algorithm unwrapped_key_algorithm: ImportAlgorithm,
  extractable extractable: Bool,
  usages usages: List(KeyUsage),
) -> Promise(Result(CryptoKey, CryptoError))

/// Like [`unwrap_key`](#unwrap_key), but imports the decrypted key as
/// a JSON Web Key. Equivalent to JavaScript's `SubtleCrypto.unwrapKey`
/// with format `"jwk"`.
///
@external(javascript, "./subtle.ffi.mjs", "unwrap_key_jwk")
pub fn unwrap_key_jwk(
  wrapped_key wrapped_key: BitArray,
  unwrapping_key unwrapping_key: CryptoKey,
  unwrap_algorithm unwrap_algorithm: WrapAlgorithm,
  unwrapped_key_algorithm unwrapped_key_algorithm: ImportAlgorithm,
  extractable extractable: Bool,
  usages usages: List(KeyUsage),
) -> Promise(Result(CryptoKey, CryptoError))
