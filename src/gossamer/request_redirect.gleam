/// How a `Request` handles redirect responses.
///
/// Unrecognized values use `Other(String)`.
///
pub type RequestRedirect {
  Error
  Follow
  Manual
  Other(String)
}
