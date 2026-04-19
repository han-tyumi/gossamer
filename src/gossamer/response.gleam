import gleam/dynamic.{type Dynamic}
import gossamer/array_buffer.{type ArrayBuffer}
import gossamer/blob.{type Blob}
import gossamer/form_data.{type FormData}
import gossamer/headers.{type Headers}
import gossamer/http_status.{type HttpStatus}
import gossamer/promise.{type Promise}
import gossamer/readable_stream.{type ReadableStream}
import gossamer/response_type.{type ResponseType}
import gossamer/uint8_array.{type Uint8Array}

/// The response to an HTTP request.
///
/// See [Response](https://developer.mozilla.org/en-US/docs/Web/API/Response) on MDN.
///
@external(javascript, "./response.type.ts", "Response$")
pub type Response

pub type ResponseInit {
  Headers(Headers)
  Status(HttpStatus)
  StatusText(String)
}

@external(javascript, "./response.ffi.mjs", "new_")
pub fn new(body: String) -> Response

/// Creates a new `Response` with the given body and init options. Returns an
/// error if `init` contains an invalid status code (outside 200-599) or an
/// invalid status text.
///
@external(javascript, "./response.ffi.mjs", "new_with_init")
pub fn new_with_init(
  body: String,
  with init: List(ResponseInit),
) -> Result(Response, String)

/// Creates a new `Response` with `data` serialized as JSON and `Content-Type`
/// set to `application/json`. Returns an error if `data` cannot be serialized
/// or `init` contains an invalid status code.
///
@external(javascript, "./response.ffi.mjs", "from_json")
pub fn from_json(
  data: a,
  with init: List(ResponseInit),
) -> Result(Response, String)

/// Creates a network error response — the kind returned by `fetch` when a
/// request cannot complete.
///
@external(javascript, "./response.ffi.mjs", "error")
pub fn error() -> Response

/// Creates a redirect response to `url` with status 302 Found. Returns an
/// error if `url` is not a valid URL.
///
@external(javascript, "./response.ffi.mjs", "redirect")
pub fn redirect(url: String) -> Result(Response, String)

/// Creates a redirect response to `url` with the given status. Returns an
/// error if `url` is not a valid URL or `status` is not a redirect status
/// (3xx).
///
/// ## Examples
///
/// ```gleam
/// response.redirect_with_status(
///   "https://example.com/new",
///   status: http_status.MovedPermanently,
/// )
/// ```
///
@external(javascript, "./response.ffi.mjs", "redirect_with_status")
pub fn redirect_with_status(
  url: String,
  status status: HttpStatus,
) -> Result(Response, String)

@external(javascript, "./response.ffi.mjs", "headers_")
pub fn headers(of response: Response) -> Headers

/// Checks whether the status is in the 200-299 range.
///
@external(javascript, "./response.ffi.mjs", "is_ok")
pub fn is_ok(response: Response) -> Bool

/// Checks whether the response is the result of following a redirect.
///
@external(javascript, "./response.ffi.mjs", "is_redirected")
pub fn is_redirected(response: Response) -> Bool

/// The HTTP status of the response. Well-known codes return a matching
/// `HttpStatus` variant; other codes return `http_status.Other(code)`.
///
@external(javascript, "./response.ffi.mjs", "status")
pub fn status(of response: Response) -> HttpStatus

@external(javascript, "./response.ffi.mjs", "status_text")
pub fn status_text(of response: Response) -> String

@external(javascript, "./response.ffi.mjs", "type_")
pub fn type_(of response: Response) -> ResponseType

/// The final URL of the response, after any redirects.
///
@external(javascript, "./response.ffi.mjs", "url")
pub fn url(of response: Response) -> String

/// Creates a clone of the response. Returns an error if the body has already
/// been consumed or is locked to a reader.
///
@external(javascript, "./response.ffi.mjs", "clone")
pub fn clone(response: Response) -> Result(Response, String)

/// The response body as a `ReadableStream`. Returns an error if the response
/// has no body.
///
@external(javascript, "./response.ffi.mjs", "body")
pub fn body(of response: Response) -> Result(ReadableStream(Uint8Array), Nil)

@external(javascript, "./response.ffi.mjs", "is_body_used")
pub fn is_body_used(response: Response) -> Bool

/// Reads the response body as a `Blob`. Returns an error if the body has
/// already been consumed or cannot be read.
///
@external(javascript, "./response.ffi.mjs", "blob")
pub fn blob(of response: Response) -> Promise(Result(Blob, String))

/// Reads the response body as an `ArrayBuffer`. Returns an error if the body
/// has already been consumed or cannot be read.
///
@external(javascript, "./response.ffi.mjs", "array_buffer")
pub fn array_buffer(
  of response: Response,
) -> Promise(Result(ArrayBuffer, String))

/// Reads the response body as a `Uint8Array`. Returns an error if the body
/// has already been consumed or cannot be read.
///
@external(javascript, "./response.ffi.mjs", "bytes")
pub fn bytes(of response: Response) -> Promise(Result(Uint8Array, String))

/// Reads the response body and parses it as JSON. Returns an error if the
/// body has already been consumed or the content is not valid JSON.
///
@external(javascript, "./response.ffi.mjs", "json")
pub fn json(of response: Response) -> Promise(Result(Dynamic, String))

/// Reads the response body as `FormData`. Returns an error if the body has
/// already been consumed or the `Content-Type` is not `multipart/form-data`
/// or `application/x-www-form-urlencoded`.
///
@external(javascript, "./response.ffi.mjs", "form_data")
pub fn form_data(of response: Response) -> Promise(Result(FormData, String))

/// Reads the response body as text. Returns an error if the body has already
/// been consumed or cannot be read.
///
@external(javascript, "./response.ffi.mjs", "text")
pub fn text(of response: Response) -> Promise(Result(String, String))
