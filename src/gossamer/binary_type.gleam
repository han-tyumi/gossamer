/// The format binary messages arrive as on a `WebSocket`.
///
/// Unrecognized values use `Other(String)`.
///
pub type BinaryType {
  ArrayBuffer
  Blob
  Other(String)
}
