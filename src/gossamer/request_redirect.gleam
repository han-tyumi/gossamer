/// How a `Request` handles redirect responses.
///
pub type RequestRedirect {
  Error
  Follow
  Manual
  Other(String)
}
