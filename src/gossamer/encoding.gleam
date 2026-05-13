//// Parent module for the text-encoding family — `TextDecoder`,
//// `TextDecoderStream`, and `TextEncoderStream`. Hosts the shared
//// `Encoding` enum and the `DecoderError` returned from
//// decoder-side operations.

/// A text encoding, used by `TextEncoder` and `TextDecoder`.
///
/// Encodings other than UTF-8 use `Other(String)`.
///
pub type Encoding {
  /// UTF-8.
  Utf8

  /// Any encoding name the binding doesn't recognize, passed through
  /// verbatim to the runtime.
  Other(String)
}

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
