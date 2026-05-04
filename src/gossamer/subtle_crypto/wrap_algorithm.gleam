import gossamer/uint8_array.{type Uint8Array}

/// Algorithm parameters for `subtle_crypto.wrap_key` and `unwrap_key`.
///
/// Non-standard or unnamed algorithms use `Other(String)`.
///
pub type WrapAlgorithm {
  AesCbc(iv: Uint8Array)
  AesCtr(counter: Uint8Array, length: Int)
  RsaOaep
  RsaOaepWith(label: Uint8Array)
  Other(String)
}
