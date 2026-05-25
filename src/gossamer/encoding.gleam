//// Parent module for the text-encoding family — `TextDecoder`,
//// `TextDecoderStream`, and `TextEncoderStream`. Hosts the shared
//// [`DecoderError`](#DecoderError) returned from decoder-side
//// operations.

/// Errors raised by `TextDecoder` and `TextDecoderStream` operations.
pub type DecoderError {
  /// The encoding label is not a recognized encoding name. The `label`
  /// payload carries the offending input.
  UnsupportedEncoding(label: String)

  /// The decoder is in fatal mode and encountered bytes that don't form
  /// a valid sequence for the configured encoding. Produced by
  /// `decode_chunk`, `flush`, and `decode`.
  MalformedInput
}
