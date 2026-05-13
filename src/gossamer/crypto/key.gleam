//// A `CryptoKey` is a handle to a cryptographic key managed by the
//// runtime. Use [`gossamer/crypto/subtle`](./subtle.html) to
//// generate, import, derive, or unwrap one.

import gossamer/crypto.{type KeyAlgorithm, type KeyKind, type KeyUsage}

/// A cryptographic key used with `subtle` operations (encryption,
/// signing, key derivation, etc.).
///
/// See [CryptoKey](https://developer.mozilla.org/en-US/docs/Web/API/CryptoKey) on MDN.
///
@external(javascript, "./key.type.ts", "CryptoKey$")
pub type CryptoKey

/// The algorithm and parameters the key is bound to.
///
@external(javascript, "./key.ffi.mjs", "algorithm")
pub fn algorithm(key: CryptoKey) -> KeyAlgorithm

/// `True` if `key` can be exported via `subtle.export_key` or
/// `subtle.export_key_jwk`.
///
@external(javascript, "./key.ffi.mjs", "is_extractable")
pub fn is_extractable(key: CryptoKey) -> Bool

/// Whether `key` is `Secret` (symmetric), `Public`, or `Private`.
///
@external(javascript, "./key.ffi.mjs", "kind")
pub fn kind(key: CryptoKey) -> KeyKind

/// The operations the key is permitted for (encrypt, decrypt, sign,
/// verify, etc.). `subtle` operations check this list before
/// running.
///
@external(javascript, "./key.ffi.mjs", "usages")
pub fn usages(key: CryptoKey) -> List(KeyUsage)
