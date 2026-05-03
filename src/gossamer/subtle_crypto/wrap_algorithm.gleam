import gossamer/typed_array.{type TypedArray}

/// Algorithm parameters for `subtle_crypto.wrap_key` and `unwrap_key`.
///
/// Non-standard or unnamed algorithms use `Other(String)`.
///
pub type WrapAlgorithm {
  AesCbc(iv: TypedArray)
  AesCtr(counter: TypedArray, length: Int)
  RsaOaep
  RsaOaepWith(label: TypedArray)
  Other(String)
}
