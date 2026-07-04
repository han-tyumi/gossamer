//// A `CryptoKey` returned by a [`gossamer/crypto/subtle`](./subtle.html)
//// operation. Access its component data via [`info`](#info).

import gossamer/crypto.{type KeyAlgorithm, type KeyKind, type KeyUsage}

/// A cryptographic key used with `subtle` operations (encryption,
/// signing, key derivation, etc.).
///
/// See [CryptoKey](https://developer.mozilla.org/en-US/docs/Web/API/CryptoKey) on MDN.
///
@external(javascript, "./key.type.ts", "CryptoKey$")
pub type CryptoKey

/// A snapshot of a [`CryptoKey`](#CryptoKey)'s parameters, returned
/// by [`info`](#info). All fields are immutable after key
/// generation.
///
pub type Info {
  Info(
    /// The algorithm and parameters the key is bound to.
    algorithm: KeyAlgorithm,
    /// Whether the key is `Secret` (symmetric), `Public`, or
    /// `Private`. Equivalent to JavaScript's `CryptoKey.type`.
    kind: KeyKind,
    /// The operations the key is permitted for (encrypt, decrypt,
    /// sign, verify, etc.). `subtle` operations check this list
    /// before running.
    usages: List(KeyUsage),
    /// `True` if the key can be exported via `subtle.export_key` or
    /// `subtle.export_key_jwk`.
    extractable: Bool,
  )
}

/// A snapshot of the key's algorithm, kind, usages, and
/// extractability.
///
@external(javascript, "./key.ffi.mjs", "info")
pub fn info(key: CryptoKey) -> Info
