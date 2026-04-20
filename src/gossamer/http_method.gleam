/// An HTTP method.
///
/// Unrecognized methods use `Other(String)`.
///
pub type HttpMethod {
  Connect
  Delete
  Get
  Head
  Options
  Patch
  Post
  Put
  Trace
  Other(String)
}
