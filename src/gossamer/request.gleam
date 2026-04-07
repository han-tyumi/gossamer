import gleam/dynamic.{type Dynamic}
import gossamer/abort_signal.{type AbortSignal}
import gossamer/array_buffer.{type ArrayBuffer}
import gossamer/headers.{type Headers}
import gossamer/promise.{type Promise}
import gossamer/readable_stream.{type ReadableStream}
import gossamer/request_init.{type RequestInit}
import gossamer/uint8_array.{type Uint8Array}

@external(javascript, "./request.type.ts", "Request$")
pub type Request

@external(javascript, "./request.ffi.mjs", "new_")
pub fn new(input: String) -> Result(Request, String)

@external(javascript, "./request.ffi.mjs", "new_with_init")
pub fn new_with_init(
  input: String,
  init: List(RequestInit),
) -> Result(Request, String)

/// Returns request's HTTP method, which is "GET" by default.
///
@external(javascript, "./request.ffi.mjs", "method")
pub fn method(request: Request) -> String

/// Returns the URL of request as a string.
///
@external(javascript, "./request.ffi.mjs", "url")
pub fn url(request: Request) -> String

/// Returns a Headers object consisting of the headers associated with
/// request.
///
@external(javascript, "./request.ffi.mjs", "headers")
pub fn headers(request: Request) -> Headers

/// Returns the cache mode associated with request, which is a string
/// indicating how the request will interact with the browser's cache when
/// fetching.
///
@external(javascript, "./request.ffi.mjs", "cache")
pub fn cache(request: Request) -> String

/// Returns the credentials mode associated with request, which is a string
/// indicating whether credentials will be sent with the request always, never,
/// or only when sent to a same-origin URL.
///
@external(javascript, "./request.ffi.mjs", "credentials")
pub fn credentials(request: Request) -> String

/// Returns the kind of resource requested by request, e.g., "document" or
/// "script".
///
@external(javascript, "./request.ffi.mjs", "destination")
pub fn destination(request: Request) -> String

/// Returns the redirect mode associated with request, which is a string
/// indicating how redirects for the request will be handled during fetching.
///
@external(javascript, "./request.ffi.mjs", "redirect")
pub fn redirect(request: Request) -> String

/// Returns the signal associated with request, which is an AbortSignal
/// object indicating whether or not request has been aborted, and its abort
/// event handler.
///
@external(javascript, "./request.ffi.mjs", "signal")
pub fn signal(request: Request) -> AbortSignal

/// Returns the referrer of request.
///
@external(javascript, "./request.ffi.mjs", "referrer")
pub fn referrer(request: Request) -> String

/// Returns the referrer policy associated with request. This is used during
/// fetching to compute the value of the request's referrer.
///
@external(javascript, "./request.ffi.mjs", "referrer_policy")
pub fn referrer_policy(request: Request) -> String

/// Returns the mode associated with request, which is a string indicating
/// whether the request will use CORS, or will be restricted to same-origin
/// URLs.
///
@external(javascript, "./request.ffi.mjs", "mode")
pub fn mode(request: Request) -> String

/// Returns a boolean indicating whether or not request can outlive the global
/// in which it was created.
///
@external(javascript, "./request.ffi.mjs", "is_keepalive")
pub fn is_keepalive(request: Request) -> Bool

/// Returns request's subresource integrity metadata.
///
@external(javascript, "./request.ffi.mjs", "integrity")
pub fn integrity(request: Request) -> String

@external(javascript, "./request.ffi.mjs", "clone")
pub fn clone(request: Request) -> Request

@external(javascript, "./request.ffi.mjs", "body")
pub fn body(request: Request) -> Result(ReadableStream(Uint8Array), Nil)

@external(javascript, "./request.ffi.mjs", "is_body_used")
pub fn is_body_used(request: Request) -> Bool

@external(javascript, "./request.ffi.mjs", "array_buffer")
pub fn array_buffer(request: Request) -> Promise(Result(ArrayBuffer, String))

@external(javascript, "./request.ffi.mjs", "bytes")
pub fn bytes(request: Request) -> Promise(Result(Uint8Array, String))

@external(javascript, "./request.ffi.mjs", "json")
pub fn json(request: Request) -> Promise(Result(Dynamic, String))

@external(javascript, "./request.ffi.mjs", "text")
pub fn text(request: Request) -> Promise(Result(String, String))
