import gossamer/typed_array.{type TypedArray}

/// Algorithm parameters for `subtle_crypto.encrypt` and `decrypt`.
///
/// Non-standard or unnamed algorithms use `Other(String)`.
///
pub type EncryptAlgorithm {
  AesCbc(iv: TypedArray)
  AesGcm(iv: TypedArray)
  AesGcmWith(iv: TypedArray, additional_data: TypedArray, tag_length: Int)
  AesCtr(counter: TypedArray, length: Int)
  RsaOaep
  RsaOaepWith(label: TypedArray)
  Other(String)
}
