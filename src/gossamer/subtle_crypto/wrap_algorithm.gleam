import gossamer/uint8_array.{type Uint8Array}

pub type WrapAlgorithm {
  AesCbc(iv: Uint8Array)
  AesCtr(counter: Uint8Array, length: Int)
  RsaOaep
  RsaOaepWith(label: Uint8Array)
  Other(String)
}
