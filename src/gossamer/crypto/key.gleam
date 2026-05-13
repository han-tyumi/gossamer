import gossamer/crypto.{type KeyAlgorithm, type KeyKind, type KeyUsage}

/// A cryptographic key used with `subtle` operations (encryption,
/// signing, key derivation, etc.).
///
/// See [CryptoKey](https://developer.mozilla.org/en-US/docs/Web/API/CryptoKey) on MDN.
///
@external(javascript, "./key.type.ts", "CryptoKey$")
pub type CryptoKey

@external(javascript, "./key.ffi.mjs", "algorithm")
pub fn algorithm(key: CryptoKey) -> KeyAlgorithm

@external(javascript, "./key.ffi.mjs", "is_extractable")
pub fn is_extractable(key: CryptoKey) -> Bool

@external(javascript, "./key.ffi.mjs", "kind")
pub fn kind(key: CryptoKey) -> KeyKind

@external(javascript, "./key.ffi.mjs", "usages")
pub fn usages(key: CryptoKey) -> List(KeyUsage)
