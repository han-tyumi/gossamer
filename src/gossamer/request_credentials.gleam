/// Whether a `Request` includes credentials (cookies, HTTP auth) for
/// cross-origin requests.
///
/// Unrecognized values use `Other(String)`.
///
pub type RequestCredentials {
  Include
  Omit
  SameOrigin
  Other(String)
}
