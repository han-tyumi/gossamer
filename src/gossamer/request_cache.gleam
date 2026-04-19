/// The cache mode for a `Request`, controlling how it interacts with the
/// browser's HTTP cache.
///
pub type RequestCache {
  Default
  ForceCache
  NoCache
  NoStore
  OnlyIfCached
  Reload
  Other(String)
}
