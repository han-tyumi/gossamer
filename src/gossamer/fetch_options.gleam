//// Builder for [Fetch](https://fetch.spec.whatwg.org/) options that
//// `gleam/http/request.Request` doesn't carry: cache mode, credentials
//// policy, CORS mode, priority, redirect handling, integrity check,
//// keepalive, abort signal, referrer, and referrer policy.
////
//// Every field is unset by default; unset fields use the runtime's
//// default. Setting a field forces that value.
////
//// ## Examples
////
//// ```gleam
//// import gossamer/fetch_extra
//// import gossamer/fetch_options
//// import gossamer/request_cache
////
//// let options =
////   fetch_options.new()
////   |> fetch_options.set_cache(request_cache.NoCache)
////   |> fetch_options.set_keepalive(True)
////
//// fetch_extra.send(request, with: options)
//// ```

import gleam/option.{type Option, None, Some}
import gossamer/abort_signal.{type AbortSignal}
import gossamer/referrer_policy.{type ReferrerPolicy}
import gossamer/request_cache.{type RequestCache}
import gossamer/request_credentials.{type RequestCredentials}
import gossamer/request_mode.{type RequestMode}
import gossamer/request_priority.{type RequestPriority}
import gossamer/request_redirect.{type RequestRedirect}

/// A builder for fetch options. Construct with `new` and chain setters;
/// pass to `fetch_extra.send` (or its variants) via the `with` label.
///
pub type FetchOptions {
  FetchOptions(
    cache: Option(RequestCache),
    credentials: Option(RequestCredentials),
    integrity: Option(String),
    keepalive: Option(Bool),
    mode: Option(RequestMode),
    priority: Option(RequestPriority),
    redirect: Option(RequestRedirect),
    referrer: Option(String),
    referrer_policy: Option(ReferrerPolicy),
    signal: Option(AbortSignal),
  )
}

/// A `FetchOptions` with no fields set. Pass directly to `fetch_extra.send`
/// to use runtime defaults for every field, or chain setters to override
/// individual fields.
///
pub fn new() -> FetchOptions {
  FetchOptions(
    cache: None,
    credentials: None,
    integrity: None,
    keepalive: None,
    mode: None,
    priority: None,
    redirect: None,
    referrer: None,
    referrer_policy: None,
    signal: None,
  )
}

/// Sets the cache mode, controlling how the request interacts with the
/// HTTP cache.
///
pub fn set_cache(opts: FetchOptions, value: RequestCache) -> FetchOptions {
  FetchOptions(..opts, cache: Some(value))
}

/// Sets the credentials policy, controlling whether cookies and HTTP auth
/// are sent with cross-origin requests.
///
pub fn set_credentials(
  opts: FetchOptions,
  value: RequestCredentials,
) -> FetchOptions {
  FetchOptions(..opts, credentials: Some(value))
}

/// Sets a [subresource integrity](https://www.w3.org/TR/SRI/) hash that
/// the response must match; the fetch fails if the body doesn't hash to
/// the given value.
///
pub fn set_integrity(opts: FetchOptions, value: String) -> FetchOptions {
  FetchOptions(..opts, integrity: Some(value))
}

/// Sets the keepalive flag, allowing the request to outlive its
/// originating context (subject to per-origin size limits).
///
pub fn set_keepalive(opts: FetchOptions, value: Bool) -> FetchOptions {
  FetchOptions(..opts, keepalive: Some(value))
}

/// Sets the CORS mode, controlling how cross-origin requests are handled.
///
pub fn set_mode(opts: FetchOptions, value: RequestMode) -> FetchOptions {
  FetchOptions(..opts, mode: Some(value))
}

/// Sets the priority hint, indicating relative importance compared to
/// other requests.
///
pub fn set_priority(opts: FetchOptions, value: RequestPriority) -> FetchOptions {
  FetchOptions(..opts, priority: Some(value))
}

/// Sets how the request handles redirects.
///
pub fn set_redirect(opts: FetchOptions, value: RequestRedirect) -> FetchOptions {
  FetchOptions(..opts, redirect: Some(value))
}

/// Sets the referrer URL. Use `"about:client"` for the default behavior
/// or `""` to omit the `Referer` header entirely.
///
pub fn set_referrer(opts: FetchOptions, value: String) -> FetchOptions {
  FetchOptions(..opts, referrer: Some(value))
}

/// Sets the referrer policy, controlling what URL is sent in the
/// `Referer` header.
///
pub fn set_referrer_policy(
  opts: FetchOptions,
  value: ReferrerPolicy,
) -> FetchOptions {
  FetchOptions(..opts, referrer_policy: Some(value))
}

/// Sets the abort signal, allowing the request to be cancelled
/// imperatively or after a timeout.
///
pub fn set_signal(opts: FetchOptions, value: AbortSignal) -> FetchOptions {
  FetchOptions(..opts, signal: Some(value))
}
