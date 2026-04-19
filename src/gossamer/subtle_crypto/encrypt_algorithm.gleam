import gossamer/uint8_array.{type Uint8Array}

/// Algorithm parameters for `subtle_crypto.encrypt` and `decrypt`.
///
pub type EncryptAlgorithm {
  AesCbc(iv: Uint8Array)
  AesGcm(iv: Uint8Array)
  AesGcmWith(iv: Uint8Array, additional_data: Uint8Array, tag_length: Int)
  AesCtr(counter: Uint8Array, length: Int)
  RsaOaep
  RsaOaepWith(label: Uint8Array)
  Other(String)
}
