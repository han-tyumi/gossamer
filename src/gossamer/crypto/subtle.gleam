import gleam/javascript/promise.{type Promise}
import gossamer/crypto.{
  type AesAlgorithm, type CryptoError, type EcAlgorithm, type HashAlgorithm,
  type KeyUsage, type NamedCurve, type RsaAlgorithm,
}
import gossamer/crypto/jwk.{type JsonWebKey}
import gossamer/crypto/key.{type CryptoKey}

pub type CryptoKeyPair {
  CryptoKeyPair(public_key: CryptoKey, private_key: CryptoKey)
}

/// The serialization format of a key imported or exported via
/// `subtle`.
///
pub type KeyFormat {
  Pkcs8
  Raw
  Spki
}

/// Algorithm parameters for `derive_bits` and `derive_key`.
///
/// Non-standard or unnamed algorithms use `DeriveOther(String)`.
///
pub type DeriveAlgorithm {
  Hkdf(hash: HashAlgorithm, info: BitArray, salt: BitArray)
  Pbkdf2(hash: HashAlgorithm, iterations: Int, salt: BitArray)
  EcDh(public: CryptoKey)
  DeriveOther(String)
}

/// The target key type for `derive_key`.
///
/// Non-standard or unnamed algorithms use `DerivedKeyOther(String)`.
///
pub type DerivedKeyType {
  AesDerived(name: AesAlgorithm, length: Int)
  HmacDerived(hash: HashAlgorithm)
  DerivedKeyOther(String)
}

/// Algorithm parameters for `encrypt` and `decrypt`.
///
/// Non-standard or unnamed algorithms use `EncryptOther(String)`.
///
pub type EncryptAlgorithm {
  EncryptAesCbc(iv: BitArray)
  AesGcm(iv: BitArray)
  AesGcmWith(iv: BitArray, additional_data: BitArray, tag_length: Int)
  EncryptAesCtr(counter: BitArray, length: Int)
  EncryptRsaOaep
  EncryptRsaOaepWith(label: BitArray)
  EncryptOther(String)
}

/// Algorithm parameters for `import_key` and `import_key_jwk`.
///
/// Non-standard or unnamed algorithms use `ImportOther(String)`.
///
pub type ImportAlgorithm {
  HmacImport(hash: HashAlgorithm)
  RsaHashedImport(name: RsaAlgorithm, hash: HashAlgorithm)
  EcImport(name: EcAlgorithm, named_curve: NamedCurve)
  ImportOther(String)
}

/// Algorithm parameters for `generate_key` (symmetric keys).
///
/// Non-standard or unnamed algorithms use `KeyGenOther(String)`.
///
pub type KeyGenAlgorithm {
  Aes(name: AesAlgorithm, length: Int)
  HmacGen(hash: HashAlgorithm)
  KeyGenOther(String)
}

/// Algorithm parameters for `generate_key_pair` (asymmetric keys).
///
/// Non-standard or unnamed algorithms use `KeyPairGenOther(String)`.
///
pub type KeyPairGenAlgorithm {
  Rsa(
    name: RsaAlgorithm,
    modulus_length: Int,
    public_exponent: BitArray,
    hash: HashAlgorithm,
  )
  Ec(name: EcAlgorithm, named_curve: NamedCurve)
  Ed25519
  X25519
  KeyPairGenOther(String)
}

/// Algorithm parameters for `sign` and `verify`.
///
/// Non-standard or unnamed algorithms use `SignOther(String)`.
///
pub type SignAlgorithm {
  Hmac
  RsaSsaPkcs1V15
  RsaPss(salt_length: Int)
  EcDsa(hash: HashAlgorithm)
  SignOther(String)
}

/// Algorithm parameters for `wrap_key` and `unwrap_key`.
///
/// Non-standard or unnamed algorithms use `WrapOther(String)`.
///
pub type WrapAlgorithm {
  WrapAesCbc(iv: BitArray)
  WrapAesCtr(counter: BitArray, length: Int)
  WrapRsaOaep
  WrapRsaOaepWith(label: BitArray)
  WrapOther(String)
}

/// Computes a cryptographic hash of `data`. Returns
/// `Error(OperationFailed(_))` if the algorithm is unsupported by the
/// runtime.
///
@external(javascript, "./subtle.ffi.mjs", "digest")
pub fn digest(
  algorithm algorithm: HashAlgorithm,
  data data: BitArray,
) -> Promise(Result(BitArray, CryptoError))

/// Encrypts `data` with `key` using `algorithm`. Returns
/// `Error(KeyUsageMismatch(Encrypt))` if `key.usages` doesn't include
/// `Encrypt`, or `Error(OperationFailed(_))` if the algorithm doesn't
/// match the key or the data is invalid for the algorithm.
///
@external(javascript, "./subtle.ffi.mjs", "encrypt")
pub fn encrypt(
  algorithm algorithm: EncryptAlgorithm,
  key key: CryptoKey,
  data data: BitArray,
) -> Promise(Result(BitArray, CryptoError))

/// Decrypts `data` with `key` using `algorithm`. Returns
/// `Error(KeyUsageMismatch(Decrypt))` if `key.usages` doesn't include
/// `Decrypt`, or `Error(OperationFailed(_))` if the algorithm doesn't
/// match the key or `data` isn't valid ciphertext.
///
@external(javascript, "./subtle.ffi.mjs", "decrypt")
pub fn decrypt(
  algorithm algorithm: EncryptAlgorithm,
  key key: CryptoKey,
  data data: BitArray,
) -> Promise(Result(BitArray, CryptoError))

/// Produces a digital signature of `data` with `key`. Returns
/// `Error(KeyUsageMismatch(Sign))` if `key.usages` doesn't include
/// `Sign`, or `Error(OperationFailed(_))` if the algorithm doesn't
/// match the key.
///
@external(javascript, "./subtle.ffi.mjs", "sign")
pub fn sign(
  algorithm algorithm: SignAlgorithm,
  key key: CryptoKey,
  data data: BitArray,
) -> Promise(Result(BitArray, CryptoError))

/// Verifies `signature` against `data` using `key`. Returns
/// `Error(KeyUsageMismatch(Verify))` if `key.usages` doesn't include
/// `Verify`, or `Error(OperationFailed(_))` if the algorithm doesn't
/// match the key. `Ok(False)` means the signature is well-formed but
/// invalid for the data.
///
@external(javascript, "./subtle.ffi.mjs", "verify")
pub fn verify(
  algorithm algorithm: SignAlgorithm,
  key key: CryptoKey,
  signature signature: BitArray,
  data data: BitArray,
) -> Promise(Result(Bool, CryptoError))

/// Generates a new symmetric `CryptoKey`. Returns
/// `Error(OperationFailed(_))` if the algorithm is unsupported or
/// `usages` is empty.
///
@external(javascript, "./subtle.ffi.mjs", "generate_key")
pub fn generate_key(
  algorithm algorithm: KeyGenAlgorithm,
  extractable extractable: Bool,
  usages usages: List(KeyUsage),
) -> Promise(Result(CryptoKey, CryptoError))

/// Generates a new public/private key pair. Returns
/// `Error(OperationFailed(_))` if the algorithm is unsupported or
/// `usages` is empty.
///
@external(javascript, "./subtle.ffi.mjs", "generate_key_pair")
pub fn generate_key_pair(
  algorithm algorithm: KeyPairGenAlgorithm,
  extractable extractable: Bool,
  usages usages: List(KeyUsage),
) -> Promise(Result(CryptoKeyPair, CryptoError))

/// Imports a raw key from `data`. Returns `Error(OperationFailed(_))` if
/// `data` doesn't match `format` or the algorithm is unsupported.
///
@external(javascript, "./subtle.ffi.mjs", "import_key")
pub fn import_key(
  format format: KeyFormat,
  key_data data: BitArray,
  algorithm algorithm: ImportAlgorithm,
  extractable extractable: Bool,
  usages usages: List(KeyUsage),
) -> Promise(Result(CryptoKey, CryptoError))

/// Imports a key from a JSON Web Key. Returns `Error(OperationFailed(_))`
/// if `data` is malformed or the algorithm is unsupported.
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
/// `Error(OperationFailed(_))` if `format` isn't supported for the
/// key's algorithm.
///
@external(javascript, "./subtle.ffi.mjs", "export_key")
pub fn export_key(
  format format: KeyFormat,
  key key: CryptoKey,
) -> Promise(Result(BitArray, CryptoError))

/// Exports `key` as a JSON Web Key. Returns `Error(KeyNotExtractable)`
/// if `key.extractable` is `False`.
///
@external(javascript, "./subtle.ffi.mjs", "export_key_jwk")
pub fn export_key_jwk(
  key: CryptoKey,
) -> Promise(Result(JsonWebKey, CryptoError))

/// Derives bits of shared secret from a base key. Returns
/// `Error(KeyUsageMismatch(DeriveBits))` if `base_key.usages` doesn't
/// include `DeriveBits`, or `Error(OperationFailed(_))` if the
/// algorithm is unsupported.
///
@external(javascript, "./subtle.ffi.mjs", "derive_bits")
pub fn derive_bits(
  algorithm algorithm: DeriveAlgorithm,
  base_key key: CryptoKey,
  length length: Int,
) -> Promise(Result(BitArray, CryptoError))

/// Derives a new `CryptoKey` from a base key. Returns
/// `Error(KeyUsageMismatch(DeriveKey))` if `base_key.usages` doesn't
/// include `DeriveKey`, or `Error(OperationFailed(_))` if the
/// algorithm is unsupported.
///
@external(javascript, "./subtle.ffi.mjs", "derive_key")
pub fn derive_key(
  algorithm algorithm: DeriveAlgorithm,
  base_key key: CryptoKey,
  derived_key_type type_: DerivedKeyType,
  extractable extractable: Bool,
  usages usages: List(KeyUsage),
) -> Promise(Result(CryptoKey, CryptoError))

/// Exports `key` in raw form and encrypts it with `wrapping_key`.
/// Returns `Error(KeyNotExtractable)` if `key.extractable` is `False`,
/// `Error(KeyUsageMismatch(WrapKey))` if `wrapping_key.usages` doesn't
/// include `WrapKey`, or `Error(OperationFailed(_))` if the wrapping
/// algorithm is unsupported.
///
@external(javascript, "./subtle.ffi.mjs", "wrap_key")
pub fn wrap_key(
  format format: KeyFormat,
  key key: CryptoKey,
  wrapping_key wrapping_key: CryptoKey,
  algorithm algorithm: WrapAlgorithm,
) -> Promise(Result(BitArray, CryptoError))

/// Like `wrap_key`, but exports `key` as a JSON Web Key before wrapping.
///
@external(javascript, "./subtle.ffi.mjs", "wrap_key_jwk")
pub fn wrap_key_jwk(
  key key: CryptoKey,
  wrapping_key wrapping_key: CryptoKey,
  algorithm algorithm: WrapAlgorithm,
) -> Promise(Result(BitArray, CryptoError))

/// Decrypts `wrapped_key` with `unwrapping_key` and imports the result.
/// Returns `Error(KeyUsageMismatch(UnwrapKey))` if `unwrapping_key.usages`
/// doesn't include `UnwrapKey`, or `Error(OperationFailed(_))` if the
/// unwrapping fails or the imported key is invalid for the specified
/// algorithm.
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

/// Like `unwrap_key`, but imports the decrypted key as a JSON Web Key.
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
