import gossamer/array_buffer.{type ArrayBuffer}
import gossamer/crypto_key.{type CryptoKey}
import gossamer/hash_algorithm.{type HashAlgorithm}
import gossamer/json_web_key.{type JsonWebKey}
import gossamer/key_format.{type KeyFormat}
import gossamer/key_usage.{type KeyUsage}
import gossamer/promise.{type Promise}
import gossamer/subtle_crypto/derive_algorithm.{type DeriveAlgorithm}
import gossamer/subtle_crypto/derived_key_type.{type DerivedKeyType}
import gossamer/subtle_crypto/encrypt_algorithm.{type EncryptAlgorithm}
import gossamer/subtle_crypto/import_algorithm.{type ImportAlgorithm}
import gossamer/subtle_crypto/key_gen_algorithm.{type KeyGenAlgorithm}
import gossamer/subtle_crypto/key_pair_gen_algorithm.{type KeyPairGenAlgorithm}
import gossamer/subtle_crypto/sign_algorithm.{type SignAlgorithm}
import gossamer/subtle_crypto/wrap_algorithm.{type WrapAlgorithm}
import gossamer/uint8_array.{type Uint8Array}

pub type CryptoKeyPair {
  CryptoKeyPair(public_key: CryptoKey, private_key: CryptoKey)
}

/// Computes a cryptographic hash of `data`. Returns an error if the algorithm is
/// not supported or `data` cannot be processed.
///
@external(javascript, "./subtle_crypto.ffi.mjs", "digest")
pub fn digest(
  algorithm algorithm: HashAlgorithm,
  data data: Uint8Array,
) -> Promise(Result(ArrayBuffer, String))

/// Encrypts `data` with `key` using `algorithm`. Returns an error if the key's
/// usage doesn't include `"encrypt"`, the key's algorithm doesn't match,
/// or the data is invalid for the algorithm.
///
@external(javascript, "./subtle_crypto.ffi.mjs", "encrypt")
pub fn encrypt(
  algorithm algorithm: EncryptAlgorithm,
  key key: CryptoKey,
  data data: Uint8Array,
) -> Promise(Result(ArrayBuffer, String))

/// Decrypts `data` with `key` using `algorithm`. Returns an error if the key's
/// usage doesn't include `"decrypt"`, the key's algorithm doesn't match,
/// or `data` is not valid ciphertext.
///
@external(javascript, "./subtle_crypto.ffi.mjs", "decrypt")
pub fn decrypt(
  algorithm algorithm: EncryptAlgorithm,
  key key: CryptoKey,
  data data: Uint8Array,
) -> Promise(Result(ArrayBuffer, String))

/// Produces a digital signature of `data` with `key`. Returns an error if the
/// key's usage doesn't include `"sign"` or the key's algorithm doesn't
/// match.
///
@external(javascript, "./subtle_crypto.ffi.mjs", "sign")
pub fn sign(
  algorithm algorithm: SignAlgorithm,
  key key: CryptoKey,
  data data: Uint8Array,
) -> Promise(Result(ArrayBuffer, String))

/// Verifies `signature` against `data` using `key`. Returns an error if the key's
/// usage doesn't include `"verify"` or the key's algorithm doesn't match.
///
@external(javascript, "./subtle_crypto.ffi.mjs", "verify")
pub fn verify(
  algorithm algorithm: SignAlgorithm,
  key key: CryptoKey,
  signature signature: Uint8Array,
  data data: Uint8Array,
) -> Promise(Result(Bool, String))

/// Generates a new symmetric `CryptoKey`. Returns an error if the algorithm is
/// unsupported or `usages` is empty.
///
@external(javascript, "./subtle_crypto.ffi.mjs", "generate_key")
pub fn generate_key(
  algorithm algorithm: KeyGenAlgorithm,
  extractable extractable: Bool,
  usages usages: List(KeyUsage),
) -> Promise(Result(CryptoKey, String))

/// Generates a new public/private key pair. Returns an error if the algorithm is
/// unsupported or `usages` is empty.
///
@external(javascript, "./subtle_crypto.ffi.mjs", "generate_key_pair")
pub fn generate_key_pair(
  algorithm algorithm: KeyPairGenAlgorithm,
  extractable extractable: Bool,
  usages usages: List(KeyUsage),
) -> Promise(Result(CryptoKeyPair, String))

/// Imports a raw key from `data`. Returns an error if `data` doesn't match `format`
/// or the algorithm is unsupported.
///
@external(javascript, "./subtle_crypto.ffi.mjs", "import_key")
pub fn import_key(
  format format: KeyFormat,
  key_data data: Uint8Array,
  algorithm algorithm: ImportAlgorithm,
  extractable extractable: Bool,
  usages usages: List(KeyUsage),
) -> Promise(Result(CryptoKey, String))

/// Imports a key from a JSON Web Key. Returns an error if `data` is malformed or
/// the algorithm is unsupported.
///
@external(javascript, "./subtle_crypto.ffi.mjs", "import_key_jwk")
pub fn import_key_jwk(
  key_data data: JsonWebKey,
  algorithm algorithm: ImportAlgorithm,
  extractable extractable: Bool,
  usages usages: List(KeyUsage),
) -> Promise(Result(CryptoKey, String))

/// Exports `key` in the given `format`. Returns an error if the key is not
/// extractable.
///
@external(javascript, "./subtle_crypto.ffi.mjs", "export_key")
pub fn export_key(
  format format: KeyFormat,
  key key: CryptoKey,
) -> Promise(Result(ArrayBuffer, String))

/// Exports `key` as a JSON Web Key. Returns an error if the key is not extractable.
///
@external(javascript, "./subtle_crypto.ffi.mjs", "export_key_jwk")
pub fn export_key_jwk(key: CryptoKey) -> Promise(Result(JsonWebKey, String))

/// Derives bits of shared secret from a base key. Returns an error if the key's
/// usage doesn't include `"deriveBits"` or the algorithm is unsupported.
///
@external(javascript, "./subtle_crypto.ffi.mjs", "derive_bits")
pub fn derive_bits(
  algorithm algorithm: DeriveAlgorithm,
  base_key key: CryptoKey,
  length length: Int,
) -> Promise(Result(ArrayBuffer, String))

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
) -> Promise(Result(CryptoKey, String))

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
) -> Promise(Result(ArrayBuffer, String))

/// Like `wrap_key`, but exports `key` as a JSON Web Key before wrapping.
///
@external(javascript, "./subtle_crypto.ffi.mjs", "wrap_key_jwk")
pub fn wrap_key_jwk(
  key key: CryptoKey,
  wrapping_key wrapping_key: CryptoKey,
  algorithm algorithm: WrapAlgorithm,
) -> Promise(Result(ArrayBuffer, String))

/// Decrypts `wrapped_key` with `unwrapping_key` and imports the result.
/// Returns an error if the unwrapping fails or the imported key is invalid for the
/// specified algorithm.
///
@external(javascript, "./subtle_crypto.ffi.mjs", "unwrap_key")
pub fn unwrap_key(
  format format: KeyFormat,
  wrapped_key wrapped_key: Uint8Array,
  unwrapping_key unwrapping_key: CryptoKey,
  unwrap_algorithm unwrap_algorithm: WrapAlgorithm,
  unwrapped_key_algorithm unwrapped_key_algorithm: ImportAlgorithm,
  extractable extractable: Bool,
  usages usages: List(KeyUsage),
) -> Promise(Result(CryptoKey, String))

/// Like `unwrap_key`, but imports the decrypted key as a JSON Web Key.
///
@external(javascript, "./subtle_crypto.ffi.mjs", "unwrap_key_jwk")
pub fn unwrap_key_jwk(
  wrapped_key wrapped_key: Uint8Array,
  unwrapping_key unwrapping_key: CryptoKey,
  unwrap_algorithm unwrap_algorithm: WrapAlgorithm,
  unwrapped_key_algorithm unwrapped_key_algorithm: ImportAlgorithm,
  extractable extractable: Bool,
  usages usages: List(KeyUsage),
) -> Promise(Result(CryptoKey, String))
