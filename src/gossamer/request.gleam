import gleam/dynamic.{type Dynamic}
import gossamer/abort_signal.{type AbortSignal}
import gossamer/array_buffer.{type ArrayBuffer}
import gossamer/blob.{type Blob}
import gossamer/form_data.{type FormData}
import gossamer/headers.{type Headers}
import gossamer/http_method.{type HttpMethod}
import gossamer/promise.{type Promise}
import gossamer/readable_stream.{type ReadableStream}
import gossamer/referrer_policy.{type ReferrerPolicy}
import gossamer/request_cache.{type RequestCache}
import gossamer/request_credentials.{type RequestCredentials}
import gossamer/request_destination.{type RequestDestination}
import gossamer/request_mode.{type RequestMode}
import gossamer/request_redirect.{type RequestRedirect}
import gossamer/uint8_array.{type Uint8Array}
import gossamer/url.{type URL}
import gossamer/url_search_params.{type URLSearchParams}

/// An HTTP request.
///
/// See [Request](https://developer.mozilla.org/en-US/docs/Web/API/Request) on MDN.
///
@external(javascript, "./request.type.ts", "Request$")
pub type Request

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
  Redirect(RequestRedirect)
  Referrer(String)
  ReferrerPolicy(ReferrerPolicy)
  Signal(AbortSignal)
}

/// Creates a new `Request` from a URL given as a string. Returns an error
/// if `url` is not a valid URL.
///
@external(javascript, "./request.ffi.mjs", "from_url_string")
pub fn from_url_string(url: String) -> Result(Request, String)

/// Creates a new `Request` from a URL given as a string, with init
/// options. Returns an error if `url` is not a valid URL or `init`
/// contains an invalid method, header, or mode.
///
@external(javascript, "./request.ffi.mjs", "from_url_string_with_init")
pub fn from_url_string_with_init(
  url: String,
  with init: List(RequestInit),
) -> Result(Request, String)

/// Creates a new `Request` from `url`. Returns an error if `url` contains
/// credentials (the Fetch spec rejects `user:pass@` URLs).
///
@external(javascript, "./request.ffi.mjs", "from_url")
pub fn from_url(url: URL) -> Result(Request, String)

/// Creates a new `Request` from `url` with init options. Returns an error
/// if `url` contains credentials, or `init` contains an invalid method,
/// header, or mode.
///
@external(javascript, "./request.ffi.mjs", "from_url_with_init")
pub fn from_url_with_init(
  url: URL,
  with init: List(RequestInit),
) -> Result(Request, String)

@external(javascript, "./request.ffi.mjs", "method")
pub fn method(of request: Request) -> HttpMethod

@external(javascript, "./request.ffi.mjs", "url")
pub fn url(of request: Request) -> String

@external(javascript, "./request.ffi.mjs", "headers")
pub fn headers(of request: Request) -> Headers

/// Returns the cache mode associated with the request.
///
/// Note: Not available on Deno.
/// See https://github.com/denoland/deno/issues/27763
///
@external(javascript, "./request.ffi.mjs", "cache")
pub fn cache(of request: Request) -> RequestCache

/// Returns the credentials mode associated with the request.
///
/// Note: Not available on Deno.
/// See https://github.com/denoland/deno/issues/27763
///
@external(javascript, "./request.ffi.mjs", "credentials")
pub fn credentials(of request: Request) -> RequestCredentials

/// Returns the kind of resource requested by the request.
///
/// Note: Not available on Deno.
/// See https://github.com/denoland/deno/issues/27763
///
@external(javascript, "./request.ffi.mjs", "destination")
pub fn destination(of request: Request) -> RequestDestination

@external(javascript, "./request.ffi.mjs", "redirect")
pub fn redirect(of request: Request) -> RequestRedirect

@external(javascript, "./request.ffi.mjs", "signal")
pub fn signal(of request: Request) -> AbortSignal

/// Returns the referrer of the request.
///
/// Note: Not available on Deno.
/// See https://github.com/denoland/deno/issues/27763
///
@external(javascript, "./request.ffi.mjs", "referrer")
pub fn referrer(of request: Request) -> String

/// Returns the referrer policy associated with the request.
///
/// Note: Not available on Deno.
/// See https://github.com/denoland/deno/issues/27763
///
@external(javascript, "./request.ffi.mjs", "referrer_policy")
pub fn referrer_policy(of request: Request) -> ReferrerPolicy

/// Returns the mode associated with the request.
///
/// Note: Not available on Deno.
/// See https://github.com/denoland/deno/issues/27763
///
@external(javascript, "./request.ffi.mjs", "mode")
pub fn mode(of request: Request) -> RequestMode

/// Returns whether the request can outlive the global in which it was created.
///
/// Note: Not available on Deno.
/// See https://github.com/denoland/deno/issues/27763
///
@external(javascript, "./request.ffi.mjs", "is_keepalive")
pub fn is_keepalive(request: Request) -> Bool

/// Returns the subresource integrity metadata of the request.
///
/// Note: Not available on Deno.
/// See https://github.com/denoland/deno/issues/27763
///
@external(javascript, "./request.ffi.mjs", "integrity")
pub fn integrity(of request: Request) -> String

/// Creates a clone of the request. Returns an error if the body has
/// already been consumed or is locked to a reader.
///
@external(javascript, "./request.ffi.mjs", "clone")
pub fn clone(request: Request) -> Result(Request, String)

/// The request body as a `ReadableStream`. Returns an error if the request
/// has no body.
///
@external(javascript, "./request.ffi.mjs", "body")
pub fn body(of request: Request) -> Result(ReadableStream(Uint8Array), Nil)

@external(javascript, "./request.ffi.mjs", "is_body_used")
pub fn is_body_used(request: Request) -> Bool

/// Reads the request body as a `Blob`. Returns an error if the body has
/// already been consumed or cannot be read.
///
@external(javascript, "./request.ffi.mjs", "blob")
pub fn blob(of request: Request) -> Promise(Result(Blob, String))

/// Reads the request body as an `ArrayBuffer`. Returns an error if the
/// body has already been consumed or cannot be read.
///
@external(javascript, "./request.ffi.mjs", "array_buffer")
pub fn array_buffer(of request: Request) -> Promise(Result(ArrayBuffer, String))

/// Reads the request body as a `Uint8Array`. Returns an error if the body
/// has already been consumed or cannot be read.
///
@external(javascript, "./request.ffi.mjs", "bytes")
pub fn bytes(of request: Request) -> Promise(Result(Uint8Array, String))

/// Reads the request body and parses it as JSON. Returns an error if the
/// body has already been consumed or the content is not valid JSON.
///
@external(javascript, "./request.ffi.mjs", "json")
pub fn json(of request: Request) -> Promise(Result(Dynamic, String))

/// Reads the request body as `FormData`. Returns an error if the body has
/// already been consumed or the `Content-Type` is not `multipart/form-data`
/// or `application/x-www-form-urlencoded`.
///
@external(javascript, "./request.ffi.mjs", "form_data")
pub fn form_data(of request: Request) -> Promise(Result(FormData, String))

/// Reads the request body as text. Returns an error if the body has
/// already been consumed or cannot be read.
///
@external(javascript, "./request.ffi.mjs", "text")
pub fn text(of request: Request) -> Promise(Result(String, String))
