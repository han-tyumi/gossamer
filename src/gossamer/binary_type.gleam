/// The format binary messages arrive as on a `WebSocket`.
///
pub type BinaryType {
  ArrayBuffer
  Blob
  Other(String)
}
