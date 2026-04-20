/// The CORS mode for a `Request`, controlling how cross-origin requests
/// are handled.
///
/// Unrecognized values use `Other(String)`.
///
pub type RequestMode {
  Cors
  Navigate
  NoCors
  SameOrigin
  Other(String)
}
