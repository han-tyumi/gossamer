/// The priority hint for a `Request`, indicating relative importance
/// compared to other requests.
///
/// Unrecognized values use `Other(String)`.
///
pub type RequestPriority {
  High
  Low
  Auto
  Other(String)
}
