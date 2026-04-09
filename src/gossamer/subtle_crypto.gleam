import gleam/dynamic.{type Dynamic}
import gossamer/array_buffer.{type ArrayBuffer}
import gossamer/crypto_key.{type CryptoKey}
import gossamer/crypto_key_pair.{type CryptoKeyPair}
import gossamer/key_format.{type KeyFormat}
import gossamer/key_usage.{type KeyUsage}
import gossamer/promise.{type Promise}
import gossamer/subtle_crypto/derive_algorithm.{type DeriveAlgorithm}
import gossamer/subtle_crypto/derived_key_type.{type DerivedKeyType}
import gossamer/subtle_crypto/digest_algorithm.{type DigestAlgorithm}
import gossamer/subtle_crypto/encrypt_algorithm.{type EncryptAlgorithm}
import gossamer/subtle_crypto/import_algorithm.{type ImportAlgorithm}
import gossamer/subtle_crypto/key_gen_algorithm.{type KeyGenAlgorithm}
import gossamer/subtle_crypto/key_pair_gen_algorithm.{type KeyPairGenAlgorithm}
import gossamer/subtle_crypto/sign_algorithm.{type SignAlgorithm}
import gossamer/subtle_crypto/wrap_algorithm.{type WrapAlgorithm}
import gossamer/uint8_array.{type Uint8Array}

@external(javascript, "./subtle_crypto.ffi.mjs", "digest")
pub fn digest(
  algorithm algorithm: DigestAlgorithm,
  data data: Uint8Array,
) -> Promise(Result(ArrayBuffer, String))

@external(javascript, "./subtle_crypto.ffi.mjs", "encrypt")
pub fn encrypt(
  algorithm algorithm: EncryptAlgorithm,
  key key: CryptoKey,
  data data: Uint8Array,
) -> Promise(Result(ArrayBuffer, String))

@external(javascript, "./subtle_crypto.ffi.mjs", "decrypt")
pub fn decrypt(
  algorithm algorithm: EncryptAlgorithm,
  key key: CryptoKey,
  data data: Uint8Array,
) -> Promise(Result(ArrayBuffer, String))

@external(javascript, "./subtle_crypto.ffi.mjs", "sign")
pub fn sign(
  algorithm algorithm: SignAlgorithm,
  key key: CryptoKey,
  data data: Uint8Array,
) -> Promise(Result(ArrayBuffer, String))

@external(javascript, "./subtle_crypto.ffi.mjs", "verify")
pub fn verify(
  algorithm algorithm: SignAlgorithm,
  key key: CryptoKey,
  signature signature: Uint8Array,
  data data: Uint8Array,
) -> Promise(Result(Bool, String))

@external(javascript, "./subtle_crypto.ffi.mjs", "generate_key")
pub fn generate_key(
  algorithm algorithm: KeyGenAlgorithm,
  extractable extractable: Bool,
  usages usages: List(KeyUsage),
) -> Promise(Result(CryptoKey, String))

@external(javascript, "./subtle_crypto.ffi.mjs", "generate_key_pair")
pub fn generate_key_pair(
  algorithm algorithm: KeyPairGenAlgorithm,
  extractable extractable: Bool,
  usages usages: List(KeyUsage),
) -> Promise(Result(CryptoKeyPair, String))

@external(javascript, "./subtle_crypto.ffi.mjs", "import_key")
pub fn import_key(
  format format: KeyFormat,
  key_data data: Uint8Array,
  algorithm algorithm: ImportAlgorithm,
  extractable extractable: Bool,
  usages usages: List(KeyUsage),
) -> Promise(Result(CryptoKey, String))

@external(javascript, "./subtle_crypto.ffi.mjs", "import_key_jwk")
pub fn import_key_jwk(
  key_data data: Dynamic,
  algorithm algorithm: ImportAlgorithm,
  extractable extractable: Bool,
  usages usages: List(KeyUsage),
) -> Promise(Result(CryptoKey, String))

@external(javascript, "./subtle_crypto.ffi.mjs", "export_key")
pub fn export_key(
  format format: KeyFormat,
  key key: CryptoKey,
) -> Promise(Result(ArrayBuffer, String))

@external(javascript, "./subtle_crypto.ffi.mjs", "export_key_jwk")
pub fn export_key_jwk(key: CryptoKey) -> Promise(Result(Dynamic, String))

@external(javascript, "./subtle_crypto.ffi.mjs", "derive_bits")
pub fn derive_bits(
  algorithm algorithm: DeriveAlgorithm,
  base_key key: CryptoKey,
  length length: Int,
) -> Promise(Result(ArrayBuffer, String))

@external(javascript, "./subtle_crypto.ffi.mjs", "derive_key")
pub fn derive_key(
  algorithm algorithm: DeriveAlgorithm,
  base_key key: CryptoKey,
  derived_key_type type_: DerivedKeyType,
  extractable extractable: Bool,
  usages usages: List(KeyUsage),
) -> Promise(Result(CryptoKey, String))

@external(javascript, "./subtle_crypto.ffi.mjs", "wrap_key")
pub fn wrap_key(
  format format: KeyFormat,
  key key: CryptoKey,
  wrapping_key wrapping_key: CryptoKey,
  algorithm algorithm: WrapAlgorithm,
) -> Promise(Result(ArrayBuffer, String))

@external(javascript, "./subtle_crypto.ffi.mjs", "wrap_key_jwk")
pub fn wrap_key_jwk(
  key key: CryptoKey,
  wrapping_key wrapping_key: CryptoKey,
  algorithm algorithm: WrapAlgorithm,
) -> Promise(Result(ArrayBuffer, String))

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

@external(javascript, "./subtle_crypto.ffi.mjs", "unwrap_key_jwk")
pub fn unwrap_key_jwk(
  wrapped_key wrapped_key: Uint8Array,
  unwrapping_key unwrapping_key: CryptoKey,
  unwrap_algorithm unwrap_algorithm: WrapAlgorithm,
  unwrapped_key_algorithm unwrapped_key_algorithm: ImportAlgorithm,
  extractable extractable: Bool,
  usages usages: List(KeyUsage),
) -> Promise(Result(CryptoKey, String))
