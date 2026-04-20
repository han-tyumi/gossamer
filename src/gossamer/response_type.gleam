/// The type of a `Response` based on how it was obtained — same-origin,
/// cross-origin, error, etc.
///
/// Unrecognized values use `Other(String)`.
///
pub type ResponseType {
  Basic
  Cors
  Default
  Error
  Opaque
  OpaqueRedirect
  Other(String)
}
