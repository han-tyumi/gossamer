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
////   |> fetch_extra.set_cache(fetch_extra.NoCache)
////   |> fetch_extra.set_keepalive(True)
////
//// fetch_extra.send(request, with: opts)
//// ```

import gleam/fetch.{type FetchBody, type FetchError}
import gleam/fetch/form_data.{type FormData}
import gleam/http/request.{type Request}
import gleam/http/response.{type Response}
import gleam/javascript/promise.{type Promise}
import gleam/option.{type Option, None, Some}
import gossamer/abort_signal.{type AbortSignal}
import gossamer/js_error.{type JsError}
import gossamer/response_type.{type ResponseType}
import gossamer/stream/readable_stream.{type ReadableStream}

/// A builder for fetch options. Construct with `options` and chain
/// setters; pass to `send` (or its variants) via the `with` label.
///
/// Every field is unset by default; unset fields use the runtime's
/// default. Setting a field forces that value.
///
pub type FetchOptions {
  FetchOptions(
    cache: Option(Cache),
    credentials: Option(Credentials),
    integrity: Option(String),
    keepalive: Option(Bool),
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
  Default
  ForceCache
  NoCache
  NoStore
  OnlyIfCached
  Reload
}

/// Whether a `Request` includes credentials (cookies, HTTP auth) for
/// cross-origin requests.
///
pub type Credentials {
  Include
  Omit
  CredentialsSameOrigin
}

/// The CORS mode for a `Request`, controlling how cross-origin requests
/// are handled.
///
pub type Mode {
  Cors
  Navigate
  NoCors
  ModeSameOrigin
}

/// The priority hint for a `Request`, indicating relative importance
/// compared to other requests.
///
pub type Priority {
  High
  Low
  Auto
}

/// How a `Request` handles redirect responses.
///
pub type Redirect {
  Error
  Follow
  Manual
}

/// The referrer policy for a `Request`, controlling what URL is sent in
/// the `Referer` header.
///
pub type ReferrerPolicy {
  NoReferrer
  NoReferrerWhenDowngrade
  Origin
  OriginWhenCrossOrigin
  ReferrerSameOrigin
  StrictOrigin
  StrictOriginWhenCrossOrigin
  UnsafeUrl
}

/// A `FetchOptions` with no fields set. Pass directly to `send` to use
/// runtime defaults for every field, or chain setters to override
/// individual fields.
///
pub fn options() -> FetchOptions {
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

/// The final URL after redirects. Returns `""` when the underlying
/// runtime doesn't expose a URL (e.g., synthetic responses).
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
/// an error if the network request fails (`NetworkError`); a non-`2xx`
/// status is still a successful send.
///
@external(javascript, "./fetch_extra.ffi.mjs", "send")
pub fn send(
  request: Request(String),
  with options: FetchOptions,
) -> Promise(Result(Response(FetchBody), FetchError))

/// Sends a `Request(BitArray)` with the given options. Returns
/// an error if the network request fails (`NetworkError`); a non-`2xx`
/// status is still a successful send.
///
@external(javascript, "./fetch_extra.ffi.mjs", "send_bits")
pub fn send_bits(
  request: Request(BitArray),
  with options: FetchOptions,
) -> Promise(Result(Response(FetchBody), FetchError))

/// Sends a `Request(FormData)` with the given options. The
/// body is encoded as `multipart/form-data`. Returns an error if the
/// network request fails (`NetworkError`); a non-`2xx` status is still a
/// successful send.
///
@external(javascript, "./fetch_extra.ffi.mjs", "send_form_data")
pub fn send_form_data(
  request: Request(FormData),
  with options: FetchOptions,
) -> Promise(Result(Response(FetchBody), FetchError))

/// Sends a `Request(ReadableStream(BitArray))` with the given options.
/// The body is streamed as the request is sent (the Fetch spec requires
/// `duplex: "half"`, which gossamer sets automatically). Returns an
/// error if the network request fails (`NetworkError`); a non-`2xx`
/// status is still a successful send.
///
@external(javascript, "./fetch_extra.ffi.mjs", "send_stream")
pub fn send_stream(
  request: Request(ReadableStream(BitArray)),
  with options: FetchOptions,
) -> Promise(Result(Response(FetchBody), FetchError))

/// Clones a `Response`. The cloned response has its own independent body
/// stream, so the original and clone can each be consumed once. Returns
/// an error if the body has already been read or is locked to a reader.
///
/// **Note**: on Bun, this returns `Ok` when the body has already been
/// read; the Fetch spec (and Deno and Node) say it should throw. The
/// cloned body reads as empty rather than carrying the original
/// content.
///
@external(javascript, "./fetch_extra.ffi.mjs", "response_clone")
pub fn response_clone(
  response: Response(FetchBody),
) -> Result(Response(FetchBody), JsError)

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
