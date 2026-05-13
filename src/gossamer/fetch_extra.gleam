//// Extensions to `gleam/fetch`.
////
//// `gleam/fetch` covers the common case (build a `Request`, send, read
//// the body). `fetch_extra` adds:
////
//// - Response accessors that `gleam/http/response.Response` doesn't
////   carry: final URL after redirects, redirected flag, body-used flag,
////   response type.
//// - `is_response_ok`, a status-only check that works on any
////   `Response(body)` including after a body consumer has swapped the
////   body type.
//// - A `FetchOptions` builder for configuration that
////   `gleam/http/request.Request` doesn't carry (cache mode, credentials
////   policy, CORS mode, priority, redirect handling, integrity check,
////   keepalive, abort signal, referrer, referrer policy), with `send`
////   variants that consume it.
////
//// When you don't need extra configuration, prefer `gleam/fetch.send`
//// directly.
////
//// ## Examples
////
//// ```gleam
//// import gossamer/fetch_extra
////
//// let opts =
////   fetch_extra.options()
////   |> fetch_extra.set_cache(fetch_extra.CacheNoCache)
////   |> fetch_extra.set_keepalive(True)
////
//// fetch_extra.send(request, with: opts)
//// ```

import gleam/dynamic.{type Dynamic}
import gleam/fetch.{type FetchBody}
import gleam/fetch/form_data.{type FormData}
import gleam/http/request.{type Request}
import gleam/http/response.{type Response}
import gleam/javascript/promise.{type Promise}
import gleam/option.{type Option, None, Some}
import gossamer/abort_signal.{type AbortSignal}
import gossamer/stream/readable_stream.{type ReadableStream}

/// Errors raised by `fetch_extra`. Supersedes
/// [`gleam/fetch.FetchError`](https://hexdocs.pm/gleam_fetch/gleam/fetch.html#FetchError)
/// by mirroring its `NetworkError` / `UnableToReadBody` /
/// `InvalidJsonBody` variants and adding `Aborted` for bindings that
/// accept an `AbortSignal`.
///
pub type FetchError {
  /// A network error occurred (lost connection, server timeout, DNS
  /// failure, etc.). The `message` payload carries the underlying
  /// runtime detail.
  NetworkError(message: String)

  /// The body has already been consumed and can't be re-read. Body
  /// streams are single-pass per spec.
  UnableToReadBody

  /// The body was expected to be valid JSON but parsing failed.
  InvalidJsonBody

  /// The operation was aborted via an `AbortSignal`. The `reason`
  /// payload carries whatever value was passed to `abort(reason)` — or
  /// an `AbortError` `DOMException` if `abort()` was called with no
  /// argument.
  Aborted(reason: Dynamic)
}

/// The classification of a `Response`. Reflects how the response was
/// obtained and what content the consumer can access (a `ResponseBasic`
/// response exposes its body; a `ResponseOpaque` response does not).
///
pub type ResponseType {
  /// A same-origin response. The body and most headers are exposed.
  ResponseBasic

  /// A cross-origin response with CORS headers. The body and
  /// CORS-safelisted headers are exposed.
  ResponseCors

  /// A response from a synthetic source (e.g., `Response.new` /
  /// `from_string`).
  ResponseDefault

  /// A network error response. The body is opaque and consumers
  /// can't read it.
  ResponseError

  /// A no-cors cross-origin response. The body and most headers are
  /// hidden.
  ResponseOpaque

  /// An opaque redirect response with `redirect: ResponseError`-like
  /// behavior. The body is hidden.
  ResponseOpaqueRedirect
}

/// A builder for fetch options. Construct with `options` and chain
/// setters; pass to `send` (or its variants) via the `with` label.
///
/// Fields with spec-default empty values (`integrity: ""`,
/// `keepalive: False`) carry those values directly. Enum and reference
/// fields are `Option`; unset means the runtime applies its default.
///
pub type FetchOptions {
  FetchOptions(
    cache: Option(Cache),
    credentials: Option(Credentials),
    integrity: String,
    keepalive: Bool,
    mode: Option(Mode),
    priority: Option(Priority),
    redirect: Option(Redirect),
    referrer: Option(String),
    referrer_policy: Option(ReferrerPolicy),
    signal: Option(AbortSignal),
  )
}

/// The cache mode for a `Request`, controlling how it interacts with the
/// HTTP cache.
///
pub type Cache {
  /// Default behavior — the cache is consulted and revalidated per
  /// normal HTTP caching semantics.
  CacheDefault

  /// Use a cached response unconditionally if one exists, ignoring
  /// freshness. Fetch from the network only on a cache miss.
  CacheForceCache

  /// Validate cached responses with the server before using them.
  CacheNoCache

  /// Bypass the cache entirely — neither read from nor write to it.
  CacheNoStore

  /// Return a cached response or fail with a network error. Never hit
  /// the network.
  CacheOnlyIfCached

  /// Always fetch from the network, but update the cache with the
  /// response.
  CacheReload
}

/// Whether a `Request` includes credentials (cookies, HTTP auth) for
/// cross-origin requests.
///
pub type Credentials {
  /// Always include credentials, even on cross-origin requests.
  CredentialsInclude

  /// Never send credentials, even on same-origin requests.
  CredentialsOmit

  /// Send credentials only on same-origin requests.
  CredentialsSameOrigin
}

/// The CORS mode for a `Request`, controlling how cross-origin requests
/// are handled.
///
pub type Mode {
  /// Allow cross-origin requests subject to CORS preflight checks.
  ModeCors

  /// Reserved for navigation requests (top-level document loads).
  ModeNavigate

  /// Allow cross-origin requests with no CORS preflight; the response
  /// body is opaque.
  ModeNoCors

  /// Allow only same-origin requests; cross-origin requests fail.
  ModeSameOrigin
}

/// The priority hint for a `Request`, indicating relative importance
/// compared to other requests.
///
pub type Priority {
  /// Higher priority than other requests of the same destination.
  PriorityHigh

  /// Lower priority than other requests of the same destination.
  PriorityLow

  /// Let the runtime pick a priority based on the request type and
  /// context.
  PriorityAuto
}

/// How a `Request` handles redirect responses.
///
pub type Redirect {
  /// Reject the response with a network error if the server responds
  /// with a redirect.
  RedirectError

  /// Automatically follow redirects (the default).
  RedirectFollow

  /// Return the redirect response opaquely without following it; the
  /// caller decides what to do.
  RedirectManual
}

/// The referrer policy for a `Request`, controlling what URL is sent in
/// the `Referer` header.
///
pub type ReferrerPolicy {
  /// Send no `Referer` header.
  ReferrerNoReferrer

  /// Send the full URL, but omit it on a secure-to-insecure downgrade.
  ReferrerNoReferrerWhenDowngrade

  /// Send only the origin (scheme + host + port).
  ReferrerOrigin

  /// Send the full URL on same-origin; only the origin on cross-origin.
  ReferrerOriginWhenCrossOrigin

  /// Send the full URL on same-origin; nothing on cross-origin.
  ReferrerSameOrigin

  /// Send only the origin, and omit on a secure-to-insecure downgrade.
  ReferrerStrictOrigin

  /// Send the full URL on same-origin; the origin on cross-origin;
  /// nothing on a secure-to-insecure downgrade.
  ReferrerStrictOriginWhenCrossOrigin

  /// Always send the full URL. Discouraged because it can leak
  /// sensitive paths.
  ReferrerUnsafeUrl
}

/// A `FetchOptions` with no fields set. Pass directly to `send` to use
/// runtime defaults for every field, or chain setters to override
/// individual fields.
///
pub fn options() -> FetchOptions {
  FetchOptions(
    cache: None,
    credentials: None,
    integrity: "",
    keepalive: False,
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
pub fn set_cache(opts: FetchOptions, value: Cache) -> FetchOptions {
  FetchOptions(..opts, cache: Some(value))
}

/// Sets the credentials policy, controlling whether cookies and HTTP auth
/// are sent with cross-origin requests.
///
pub fn set_credentials(opts: FetchOptions, value: Credentials) -> FetchOptions {
  FetchOptions(..opts, credentials: Some(value))
}

/// Sets a [subresource integrity](https://www.w3.org/TR/SRI/) hash that
/// the response must match; the fetch fails if the body doesn't hash to
/// the given value.
///
pub fn set_integrity(opts: FetchOptions, value: String) -> FetchOptions {
  FetchOptions(..opts, integrity: value)
}

/// Sets the keepalive flag, allowing the request to outlive its
/// originating context (subject to per-origin size limits).
///
pub fn set_keepalive(opts: FetchOptions, value: Bool) -> FetchOptions {
  FetchOptions(..opts, keepalive: value)
}

/// Sets the CORS mode, controlling how cross-origin requests are handled.
///
pub fn set_mode(opts: FetchOptions, value: Mode) -> FetchOptions {
  FetchOptions(..opts, mode: Some(value))
}

/// Sets the priority hint, indicating relative importance compared to
/// other requests.
///
pub fn set_priority(opts: FetchOptions, value: Priority) -> FetchOptions {
  FetchOptions(..opts, priority: Some(value))
}

/// Sets how the request handles redirects.
///
pub fn set_redirect(opts: FetchOptions, value: Redirect) -> FetchOptions {
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

/// `True` when the status code is in the 200-299 range. Derived from
/// status alone, so it works on any `Response(body)` — including after
/// a body consumer has swapped the body type.
///
pub fn is_response_ok(response: Response(body)) -> Bool {
  response.status >= 200 && response.status < 300
}

/// The final URL after redirects. `""` for synthetic responses with no
/// URL.
///
@external(javascript, "./fetch_extra.ffi.mjs", "response_url")
pub fn response_url(response: Response(FetchBody)) -> String

/// `True` when the response is the result of one or more redirects.
///
@external(javascript, "./fetch_extra.ffi.mjs", "is_response_redirected")
pub fn is_response_redirected(response: Response(FetchBody)) -> Bool

/// `True` when the body has already been read.
///
@external(javascript, "./fetch_extra.ffi.mjs", "is_response_body_used")
pub fn is_response_body_used(response: Response(FetchBody)) -> Bool

/// The [response type](https://developer.mozilla.org/en-US/docs/Web/API/Response/type).
///
@external(javascript, "./fetch_extra.ffi.mjs", "response_type")
pub fn response_type(response: Response(FetchBody)) -> ResponseType

/// Sends a `Request(String)` with the given options. Returns
/// `Error(NetworkError(_))` if the network request fails, or
/// `Error(Aborted(_))` if the options carry an `AbortSignal` that
/// fires before the response arrives. A non-`2xx` status is still a
/// successful send.
///
@external(javascript, "./fetch_extra.ffi.mjs", "send")
pub fn send(
  request: Request(String),
  with options: FetchOptions,
) -> Promise(Result(Response(FetchBody), FetchError))

/// Sends a `Request(BitArray)` with the given options. Returns
/// `Error(NetworkError(_))` if the network request fails, or
/// `Error(Aborted(_))` if the options carry an `AbortSignal` that
/// fires before the response arrives. A non-`2xx` status is still a
/// successful send.
///
@external(javascript, "./fetch_extra.ffi.mjs", "send_bits")
pub fn send_bits(
  request: Request(BitArray),
  with options: FetchOptions,
) -> Promise(Result(Response(FetchBody), FetchError))

/// Sends a `Request(FormData)` with the given options. The body is
/// encoded as `multipart/form-data`. Returns `Error(NetworkError(_))`
/// if the network request fails, or `Error(Aborted(_))` if the options
/// carry an `AbortSignal` that fires before the response arrives. A
/// non-`2xx` status is still a successful send.
///
@external(javascript, "./fetch_extra.ffi.mjs", "send_form_data")
pub fn send_form_data(
  request: Request(FormData),
  with options: FetchOptions,
) -> Promise(Result(Response(FetchBody), FetchError))

/// Sends a `Request(ReadableStream(BitArray))` with the given options.
/// The body is streamed as the request is sent (the Fetch spec requires
/// `duplex: "half"`, which gossamer sets automatically). Returns
/// `Error(UnableToReadBody)` if the body stream is already locked to a
/// reader, `Error(NetworkError(_))` if the network request fails, or
/// `Error(Aborted(_))` if the options carry an `AbortSignal` that fires
/// before the response arrives. A non-`2xx` status is still a successful
/// send.
///
@external(javascript, "./fetch_extra.ffi.mjs", "send_stream")
pub fn send_stream(
  request: Request(ReadableStream(BitArray)),
  with options: FetchOptions,
) -> Promise(Result(Response(FetchBody), FetchError))

/// Clones a `Response`. The cloned response has its own independent body
/// stream, so the original and clone can each be consumed once. Returns
/// `Error(UnableToReadBody)` if the body has already been read or is
/// locked to a reader.
///
@external(javascript, "./fetch_extra.ffi.mjs", "response_clone")
pub fn response_clone(
  response: Response(FetchBody),
) -> Result(Response(FetchBody), FetchError)

/// Builds a `Response(String)` carrying a JSON body. Sets status `200`
/// and the `content-type: application/json` header. The caller is
/// responsible for serializing their data to JSON (see `gleam/json`).
///
/// ## Examples
///
/// ```gleam
/// fetch_extra.response_json("{\"ok\":true}")
/// ```
///
pub fn response_json(json_string: String) -> Response(String) {
  response.new(200)
  |> response.set_body(json_string)
  |> response.set_header("content-type", "application/json")
}
