import gossamer/key_algorithm.{type KeyAlgorithm}
import gossamer/key_type.{type KeyType}
import gossamer/key_usage.{type KeyUsage}

@external(javascript, "./crypto_key.type.ts", "CryptoKey$")
pub type CryptoKey

@external(javascript, "./crypto_key.ffi.mjs", "algorithm")
pub fn algorithm(key: CryptoKey) -> KeyAlgorithm

@external(javascript, "./crypto_key.ffi.mjs", "is_extractable")
pub fn is_extractable(key: CryptoKey) -> Bool

@external(javascript, "./crypto_key.ffi.mjs", "type_")
pub fn type_(key: CryptoKey) -> KeyType

@external(javascript, "./crypto_key.ffi.mjs", "usages")
pub fn usages(key: CryptoKey) -> List(KeyUsage)
