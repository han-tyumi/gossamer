import gleam/dynamic.{type Dynamic}
import gleam/option.{type Option}
import gossamer/abort_signal.{type AbortSignal}
import gossamer/array_buffer.{type ArrayBuffer}
import gossamer/blob.{type Blob}
import gossamer/form_data.{type FormData}
import gossamer/headers.{type Headers}
import gossamer/http_method.{type HttpMethod}
import gossamer/js_error.{type JsError}
import gossamer/promise.{type Promise}
import gossamer/readable_stream.{type ReadableStream}
import gossamer/referrer_policy.{type ReferrerPolicy}
import gossamer/request_cache.{type RequestCache}
import gossamer/request_credentials.{type RequestCredentials}
import gossamer/request_destination.{type RequestDestination}
import gossamer/request_mode.{type RequestMode}
import gossamer/request_priority.{type RequestPriority}
import gossamer/request_redirect.{type RequestRedirect}
import gossamer/uint8_array.{type Uint8Array}
import gossamer/url.{type URL}
import gossamer/url_search_params.{type URLSearchParams}

/// An HTTP request.
///
/// Several properties read back differently than what was set in init on
/// non-compliant runtimes. Tracked upstream as
/// https://github.com/denoland/deno/issues/27763 (Deno) and
/// https://github.com/oven-sh/bun/issues/30124 (Bun, plus
/// https://github.com/oven-sh/bun/issues/17052 for `credentials`). See
/// per-property doc comments for specifics.
///
/// See [Request](https://developer.mozilla.org/en-US/docs/Web/API/Request) on MDN.
///
@external(javascript, "./request.type.ts", "Request$")
pub type Request

pub type Fields {
  Fields(
    method: HttpMethod,
    url: String,
    headers: Headers,
    /// The cache mode. Always `request_cache.Default` on Deno
    /// (denoland/deno#27763).
    cache: RequestCache,
    /// The credentials mode. Always `request_credentials.SameOrigin` on
    /// Deno (denoland/deno#27763); always `request_credentials.Include`
    /// on Bun against the spec's `same-origin` default
    /// (oven-sh/bun#17052).
    credentials: RequestCredentials,
    /// The kind of resource requested. Always `request_destination.Empty`
    /// for user-created requests.
    destination: RequestDestination,
    /// The mode. Always `request_mode.Cors` on Deno
    /// (denoland/deno#27763).
    mode: RequestMode,
    /// The priority hint. Always `request_priority.Auto` — no runtime
    /// currently exposes the getter.
    priority: RequestPriority,
    redirect: RequestRedirect,
    /// The referrer policy. Always
    /// `referrer_policy.StrictOriginWhenCrossOrigin` on Deno
    /// (denoland/deno#27763) and Bun (oven-sh/bun#30124).
    referrer_policy: ReferrerPolicy,
    signal: AbortSignal,
    /// The referrer. Always `"about:client"` on Deno
    /// (denoland/deno#27763); always `""` on Bun (oven-sh/bun#30124).
    referrer: String,
    /// The subresource integrity metadata. Always `""` on Deno
    /// (denoland/deno#27763) and Bun (oven-sh/bun#30124).
    integrity: String,
    /// Whether the request can outlive the global in which it was
    /// created. Always `False` on Deno (denoland/deno#27763) and Bun
    /// (oven-sh/bun#30124).
    is_keepalive: Bool,
    /// The body stream, or `None` if the request has no body. Single-use:
    /// consuming it (via `blob`, `text`, `json`, etc., or via the stream
    /// itself) drains all references to it. `Some(stream)` means a stream
    /// object exists; whether it is still readable is governed by
    /// `is_body_used` and the stream's own state.
    body: Option(ReadableStream(Uint8Array)),
  )
}

@external(javascript, "./request.ffi.mjs", "to_fields")
pub fn to_fields(request: Request) -> Fields

pub type RequestInit {
  Method(HttpMethod)
  Headers(Headers)
  Body(String)
  BodyBytes(Uint8Array)
  BodyBlob(Blob)
  BodyBuffer(ArrayBuffer)
  BodyFormData(FormData)
  BodyParams(URLSearchParams)
  BodyStream(ReadableStream(Uint8Array))
  Cache(RequestCache)
  Credentials(RequestCredentials)
  Integrity(String)
  Keepalive(Bool)
  Mode(RequestMode)
  Priority(RequestPriority)
  Redirect(RequestRedirect)
  Referrer(String)
  ReferrerPolicy(ReferrerPolicy)
  Signal(AbortSignal)
}

/// Creates a new `Request` from a URL given as a string. Returns an error
/// if `url` is not a valid URL or contains credentials (the Fetch spec
/// rejects `user:pass@` URLs).
///
@external(javascript, "./request.ffi.mjs", "from_url_string")
pub fn from_url_string(url: String) -> Result(Request, JsError)

/// Creates a new `Request` from a URL given as a string, with init
/// options. Returns an error if `url` is not a valid URL or contains
/// credentials, or `init` contains an invalid method, header, or mode.
///
@external(javascript, "./request.ffi.mjs", "from_url_string_with")
pub fn from_url_string_with(
  url: String,
  with init: List(RequestInit),
) -> Result(Request, JsError)

/// Creates a new `Request` from `url`. Returns an error if `url` contains
/// credentials (the Fetch spec rejects `user:pass@` URLs).
///
@external(javascript, "./request.ffi.mjs", "from_url")
pub fn from_url(url: URL) -> Result(Request, JsError)

/// Creates a new `Request` from `url` with init options. Returns an error
/// if `url` contains credentials, or `init` contains an invalid method,
/// header, or mode.
///
@external(javascript, "./request.ffi.mjs", "from_url_with")
pub fn from_url_with(
  url: URL,
  with init: List(RequestInit),
) -> Result(Request, JsError)

/// Creates a new `Request` by copying `existing`. The body is shared with
/// `existing` — after copying, `existing`'s body can no longer be
/// consumed. Returns an error if `existing`'s body is already disturbed
/// or locked.
///
@external(javascript, "./request.ffi.mjs", "from_request")
pub fn from_request(existing: Request) -> Result(Request, JsError)

/// Creates a new `Request` by copying `existing` and applying init
/// options. Returns an error if `existing`'s body is disturbed or locked,
/// or `init` contains an invalid method, header, or mode.
///
@external(javascript, "./request.ffi.mjs", "from_request_with")
pub fn from_request_with(
  existing: Request,
  with init: List(RequestInit),
) -> Result(Request, JsError)

@external(javascript, "./request.ffi.mjs", "method")
pub fn method(of request: Request) -> HttpMethod

@external(javascript, "./request.ffi.mjs", "url")
pub fn url(of request: Request) -> String

@external(javascript, "./request.ffi.mjs", "headers")
pub fn headers(of request: Request) -> Headers

/// The cache mode. Always `request_cache.Default` on Deno
/// (denoland/deno#27763).
///
@external(javascript, "./request.ffi.mjs", "cache")
pub fn cache(of request: Request) -> RequestCache

/// The credentials mode. Always `request_credentials.SameOrigin` on Deno
/// (denoland/deno#27763); always `request_credentials.Include` on Bun
/// against the spec's `same-origin` default (oven-sh/bun#17052).
///
@external(javascript, "./request.ffi.mjs", "credentials")
pub fn credentials(of request: Request) -> RequestCredentials

/// The kind of resource requested. Always `request_destination.Empty` for
/// user-created requests.
///
@external(javascript, "./request.ffi.mjs", "destination")
pub fn destination(of request: Request) -> RequestDestination

@external(javascript, "./request.ffi.mjs", "redirect")
pub fn redirect(of request: Request) -> RequestRedirect

@external(javascript, "./request.ffi.mjs", "signal")
pub fn signal(of request: Request) -> AbortSignal

/// The referrer. Always `"about:client"` on Deno (denoland/deno#27763);
/// always `""` on Bun (oven-sh/bun#30124).
///
@external(javascript, "./request.ffi.mjs", "referrer")
pub fn referrer(of request: Request) -> String

/// The referrer policy. Always
/// `referrer_policy.StrictOriginWhenCrossOrigin` on Deno
/// (denoland/deno#27763) and Bun (oven-sh/bun#30124).
///
@external(javascript, "./request.ffi.mjs", "referrer_policy")
pub fn referrer_policy(of request: Request) -> ReferrerPolicy

/// The mode. Always `request_mode.Cors` on Deno (denoland/deno#27763).
///
@external(javascript, "./request.ffi.mjs", "mode")
pub fn mode(of request: Request) -> RequestMode

/// The priority hint. Always `request_priority.Auto` — no runtime
/// currently exposes the getter.
///
@external(javascript, "./request.ffi.mjs", "priority")
pub fn priority(of request: Request) -> RequestPriority

/// Whether the request can outlive the global in which it was created.
/// Always `False` on Deno (denoland/deno#27763) and Bun
/// (oven-sh/bun#30124).
///
@external(javascript, "./request.ffi.mjs", "is_keepalive")
pub fn is_keepalive(request: Request) -> Bool

/// The subresource integrity metadata. Always `""` on Deno
/// (denoland/deno#27763) and Bun (oven-sh/bun#30124).
///
@external(javascript, "./request.ffi.mjs", "integrity")
pub fn integrity(of request: Request) -> String

/// Creates a clone of the request. Returns an error if the body has
/// already been consumed or is locked to a reader.
///
@external(javascript, "./request.ffi.mjs", "clone")
pub fn clone(request: Request) -> Result(Request, JsError)

/// The body stream, or an error if the request has no body. Single-use:
/// consuming it (via `blob`, `text`, `json`, etc., or via the stream itself)
/// drains all references to it. `Ok(stream)` means a stream object exists;
/// whether it is still readable is governed by `is_body_used` and the
/// stream's own state.
///
@external(javascript, "./request.ffi.mjs", "body")
pub fn body(of request: Request) -> Result(ReadableStream(Uint8Array), Nil)

@external(javascript, "./request.ffi.mjs", "is_body_used")
pub fn is_body_used(request: Request) -> Bool

/// Reads the request body as a `Blob`. Returns an error if the body has
/// already been consumed or cannot be read.
///
@external(javascript, "./request.ffi.mjs", "blob")
pub fn blob(of request: Request) -> Promise(Result(Blob, JsError))

/// Reads the request body as an `ArrayBuffer`. Returns an error if the
/// body has already been consumed or cannot be read.
///
@external(javascript, "./request.ffi.mjs", "array_buffer")
pub fn array_buffer(
  of request: Request,
) -> Promise(Result(ArrayBuffer, JsError))

/// Reads the request body as a `Uint8Array`. Returns an error if the body
/// has already been consumed or cannot be read.
///
@external(javascript, "./request.ffi.mjs", "bytes")
pub fn bytes(of request: Request) -> Promise(Result(Uint8Array, JsError))

/// Reads the request body and parses it as JSON. Returns an error if the
/// body has already been consumed or the content is not valid JSON.
///
@external(javascript, "./request.ffi.mjs", "json")
pub fn json(of request: Request) -> Promise(Result(Dynamic, JsError))

/// Reads the request body as `FormData`. Returns an error if the body has
/// already been consumed or the `Content-Type` is not `multipart/form-data`
/// or `application/x-www-form-urlencoded`.
///
@external(javascript, "./request.ffi.mjs", "form_data")
pub fn form_data(of request: Request) -> Promise(Result(FormData, JsError))

/// Reads the request body as text. Returns an error if the body has
/// already been consumed or cannot be read.
///
@external(javascript, "./request.ffi.mjs", "text")
pub fn text(of request: Request) -> Promise(Result(String, JsError))
