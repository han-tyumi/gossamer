import gleam/javascript/promise.{type Promise}
import gossamer/aes_algorithm.{type AesAlgorithm}
import gossamer/crypto_key.{
  type CryptoKey, type HashAlgorithm, type KeyUsage, type NamedCurve,
}
import gossamer/ec_algorithm.{type EcAlgorithm}
import gossamer/js_error.{type JsError}
import gossamer/json_web_key.{type JsonWebKey}
import gossamer/rsa_algorithm.{type RsaAlgorithm}

pub type CryptoKeyPair {
  CryptoKeyPair(public_key: CryptoKey, private_key: CryptoKey)
}

/// The serialization format of a key imported or exported via
/// `subtle_crypto`.
///
/// Unrecognized values use `KeyFormatOther(String)`.
///
pub type KeyFormat {
  Pkcs8
  Raw
  Spki
  KeyFormatOther(String)
}

/// Algorithm parameters for `derive_bits` and `derive_key`.
///
/// Non-standard or unnamed algorithms use `DeriveOther(String)`.
///
pub type DeriveAlgorithm {
  Hkdf(hash: HashAlgorithm, info: BitArray, salt: BitArray)
  Pbkdf2(hash: HashAlgorithm, iterations: Int, salt: BitArray)
  Ecdh(public: CryptoKey)
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
  RsassaPkcs1V15
  RsaPss(salt_length: Int)
  Ecdsa(hash: HashAlgorithm)
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

/// Computes a cryptographic hash of `data`. Returns an error if the algorithm is
/// not supported or `data` cannot be processed.
///
@external(javascript, "./subtle_crypto.ffi.mjs", "digest")
pub fn digest(
  algorithm algorithm: HashAlgorithm,
  data data: BitArray,
) -> Promise(Result(BitArray, JsError))

/// Encrypts `data` with `key` using `algorithm`. Returns an error if the key's
/// usage doesn't include `"encrypt"`, the key's algorithm doesn't match,
/// or the data is invalid for the algorithm.
///
@external(javascript, "./subtle_crypto.ffi.mjs", "encrypt")
pub fn encrypt(
  algorithm algorithm: EncryptAlgorithm,
  key key: CryptoKey,
  data data: BitArray,
) -> Promise(Result(BitArray, JsError))

/// Decrypts `data` with `key` using `algorithm`. Returns an error if the key's
/// usage doesn't include `"decrypt"`, the key's algorithm doesn't match,
/// or `data` is not valid ciphertext.
///
@external(javascript, "./subtle_crypto.ffi.mjs", "decrypt")
pub fn decrypt(
  algorithm algorithm: EncryptAlgorithm,
  key key: CryptoKey,
  data data: BitArray,
) -> Promise(Result(BitArray, JsError))

/// Produces a digital signature of `data` with `key`. Returns an error if the
/// key's usage doesn't include `"sign"` or the key's algorithm doesn't
/// match.
///
@external(javascript, "./subtle_crypto.ffi.mjs", "sign")
pub fn sign(
  algorithm algorithm: SignAlgorithm,
  key key: CryptoKey,
  data data: BitArray,
) -> Promise(Result(BitArray, JsError))

/// Verifies `signature` against `data` using `key`. Returns an error if the key's
/// usage doesn't include `"verify"` or the key's algorithm doesn't match.
///
@external(javascript, "./subtle_crypto.ffi.mjs", "verify")
pub fn verify(
  algorithm algorithm: SignAlgorithm,
  key key: CryptoKey,
  signature signature: BitArray,
  data data: BitArray,
) -> Promise(Result(Bool, JsError))

/// Generates a new symmetric `CryptoKey`. Returns an error if the algorithm is
/// unsupported or `usages` is empty.
///
@external(javascript, "./subtle_crypto.ffi.mjs", "generate_key")
pub fn generate_key(
  algorithm algorithm: KeyGenAlgorithm,
  extractable extractable: Bool,
  usages usages: List(KeyUsage),
) -> Promise(Result(CryptoKey, JsError))

/// Generates a new public/private key pair. Returns an error if the algorithm is
/// unsupported or `usages` is empty.
///
@external(javascript, "./subtle_crypto.ffi.mjs", "generate_key_pair")
pub fn generate_key_pair(
  algorithm algorithm: KeyPairGenAlgorithm,
  extractable extractable: Bool,
  usages usages: List(KeyUsage),
) -> Promise(Result(CryptoKeyPair, JsError))

/// Imports a raw key from `data`. Returns an error if `data` doesn't match `format`
/// or the algorithm is unsupported.
///
@external(javascript, "./subtle_crypto.ffi.mjs", "import_key")
pub fn import_key(
  format format: KeyFormat,
  key_data data: BitArray,
  algorithm algorithm: ImportAlgorithm,
  extractable extractable: Bool,
  usages usages: List(KeyUsage),
) -> Promise(Result(CryptoKey, JsError))

/// Imports a key from a JSON Web Key. Returns an error if `data` is malformed or
/// the algorithm is unsupported.
///
@external(javascript, "./subtle_crypto.ffi.mjs", "import_key_jwk")
pub fn import_key_jwk(
  key_data data: JsonWebKey,
  algorithm algorithm: ImportAlgorithm,
  extractable extractable: Bool,
  usages usages: List(KeyUsage),
) -> Promise(Result(CryptoKey, JsError))

/// Exports `key` in the given `format`. Returns an error if the key is not
/// extractable.
///
@external(javascript, "./subtle_crypto.ffi.mjs", "export_key")
pub fn export_key(
  format format: KeyFormat,
  key key: CryptoKey,
) -> Promise(Result(BitArray, JsError))

/// Exports `key` as a JSON Web Key. Returns an error if the key is not extractable.
///
@external(javascript, "./subtle_crypto.ffi.mjs", "export_key_jwk")
pub fn export_key_jwk(key: CryptoKey) -> Promise(Result(JsonWebKey, JsError))

/// Derives bits of shared secret from a base key. Returns an error if the key's
/// usage doesn't include `"deriveBits"` or the algorithm is unsupported.
///
@external(javascript, "./subtle_crypto.ffi.mjs", "derive_bits")
pub fn derive_bits(
  algorithm algorithm: DeriveAlgorithm,
  base_key key: CryptoKey,
  length length: Int,
) -> Promise(Result(BitArray, JsError))

/// Derives a new `CryptoKey` from a base key. Returns an error if the key's usage
/// doesn't include `"deriveKey"` or the algorithm is unsupported.
///
@external(javascript, "./subtle_crypto.ffi.mjs", "derive_key")
pub fn derive_key(
  algorithm algorithm: DeriveAlgorithm,
  base_key key: CryptoKey,
  derived_key_type type_: DerivedKeyType,
  extractable extractable: Bool,
  usages usages: List(KeyUsage),
) -> Promise(Result(CryptoKey, JsError))

/// Exports `key` in raw form and encrypts it with `wrapping_key`. Returns
/// an error if either key's usage doesn't allow the operation or the
/// wrapping key's algorithm is unsupported.
///
@external(javascript, "./subtle_crypto.ffi.mjs", "wrap_key")
pub fn wrap_key(
  format format: KeyFormat,
  key key: CryptoKey,
  wrapping_key wrapping_key: CryptoKey,
  algorithm algorithm: WrapAlgorithm,
) -> Promise(Result(BitArray, JsError))

/// Like `wrap_key`, but exports `key` as a JSON Web Key before wrapping.
///
@external(javascript, "./subtle_crypto.ffi.mjs", "wrap_key_jwk")
pub fn wrap_key_jwk(
  key key: CryptoKey,
  wrapping_key wrapping_key: CryptoKey,
  algorithm algorithm: WrapAlgorithm,
) -> Promise(Result(BitArray, JsError))

/// Decrypts `wrapped_key` with `unwrapping_key` and imports the result.
/// Returns an error if the unwrapping fails or the imported key is invalid for the
/// specified algorithm.
///
@external(javascript, "./subtle_crypto.ffi.mjs", "unwrap_key")
pub fn unwrap_key(
  format format: KeyFormat,
  wrapped_key wrapped_key: BitArray,
  unwrapping_key unwrapping_key: CryptoKey,
  unwrap_algorithm unwrap_algorithm: WrapAlgorithm,
  unwrapped_key_algorithm unwrapped_key_algorithm: ImportAlgorithm,
  extractable extractable: Bool,
  usages usages: List(KeyUsage),
) -> Promise(Result(CryptoKey, JsError))

/// Like `unwrap_key`, but imports the decrypted key as a JSON Web Key.
///
@external(javascript, "./subtle_crypto.ffi.mjs", "unwrap_key_jwk")
pub fn unwrap_key_jwk(
  wrapped_key wrapped_key: BitArray,
  unwrapping_key unwrapping_key: CryptoKey,
  unwrap_algorithm unwrap_algorithm: WrapAlgorithm,
  unwrapped_key_algorithm unwrapped_key_algorithm: ImportAlgorithm,
  extractable extractable: Bool,
  usages usages: List(KeyUsage),
) -> Promise(Result(CryptoKey, JsError))
