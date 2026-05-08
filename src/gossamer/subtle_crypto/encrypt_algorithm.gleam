/// Algorithm parameters for `subtle_crypto.encrypt` and `decrypt`.
///
/// Non-standard or unnamed algorithms use `Other(String)`.
///
pub type EncryptAlgorithm {
  AesCbc(iv: BitArray)
  AesGcm(iv: BitArray)
  AesGcmWith(iv: BitArray, additional_data: BitArray, tag_length: Int)
  AesCtr(counter: BitArray, length: Int)
  RsaOaep
  RsaOaepWith(label: BitArray)
  Other(String)
}
