/// The referrer policy for a `Request`, controlling what URL is sent in
/// the `Referer` header.
///
/// Unrecognized values use `Other(String)`.
///
pub type ReferrerPolicy {
  NoReferrer
  NoReferrerWhenDowngrade
  Origin
  OriginWhenCrossOrigin
  SameOrigin
  StrictOrigin
  StrictOriginWhenCrossOrigin
  UnsafeUrl
  Other(String)
}
