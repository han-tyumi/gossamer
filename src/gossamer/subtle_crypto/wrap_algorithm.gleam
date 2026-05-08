/// Algorithm parameters for `subtle_crypto.wrap_key` and `unwrap_key`.
///
/// Non-standard or unnamed algorithms use `Other(String)`.
///
pub type WrapAlgorithm {
  AesCbc(iv: BitArray)
  AesCtr(counter: BitArray, length: Int)
  RsaOaep
  RsaOaepWith(label: BitArray)
  Other(String)
}
