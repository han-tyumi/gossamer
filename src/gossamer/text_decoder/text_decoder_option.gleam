pub type TextDecoderOption {
  /// Indicates that [`decode`](./text_decoder.html#decode) must throw a
  /// TypeError when decoding invalid data. It defaults to false, which means
  /// that the decoder will substitute malformed data with a replacement
  /// character.
  ///
  Fatal

  /// Indicates whether the [byte order mark](https://www.w3.org/International/questions/qa-byte-order-mark)
  /// will be included in the output or skipped over. It defaults to false,
  /// which means that the byte order mark will be skipped over when decoding
  /// and will not be included in the decoded text.
  ///
  IgnoreBom
}
