/// Whether a `Request` includes credentials (cookies, HTTP auth) for
/// cross-origin requests.
///
pub type RequestCredentials {
  Include
  Omit
  SameOrigin
  Other(String)
}
