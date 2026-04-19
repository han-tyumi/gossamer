/// The CORS mode for a `Request`, controlling how cross-origin requests
/// are handled.
///
pub type RequestMode {
  Cors
  Navigate
  NoCors
  SameOrigin
  Other(String)
}
