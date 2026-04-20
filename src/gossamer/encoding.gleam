/// A text encoding, used by `TextEncoder` and `TextDecoder`.
///
/// Encodings other than UTF-8 use `Other(String)`.
///
pub type Encoding {
  Utf8
  Other(String)
}
