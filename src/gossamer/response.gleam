import gossamer/array_buffer.{type ArrayBuffer}
import gossamer/headers.{type Headers}
import gossamer/promise.{type Promise}
import gossamer/readable_stream.{type ReadableStream}
import gossamer/response_init.{type ResponseInit}
import gossamer/uint8_array.{type Uint8Array}
import gleam/dynamic.{type Dynamic}

/// This Fetch API interface represents the response to a request.
///
@external(javascript, "./response.type.ts", "Response$")
pub type Response

@external(javascript, "./response.ffi.mjs", "new_")
pub fn new(body: String) -> Result(Response, String)

@external(javascript, "./response.ffi.mjs", "new_with_init")
pub fn new_with_init(
  body: String,
  init: List(ResponseInit),
) -> Result(Response, String)

@external(javascript, "./response.ffi.mjs", "json")
pub fn json(data: Dynamic, init: List(ResponseInit)) -> Response

@external(javascript, "./response.ffi.mjs", "error")
pub fn error() -> Response

@external(javascript, "./response.ffi.mjs", "redirect")
pub fn redirect(url: String) -> Response

@external(javascript, "./response.ffi.mjs", "redirect_with_status")
pub fn redirect_with_status(url: String, status: Int) -> Response

@external(javascript, "./response.ffi.mjs", "headers_")
pub fn headers(response: Response) -> Headers

@external(javascript, "./response.ffi.mjs", "is_ok")
pub fn is_ok(response: Response) -> Bool

@external(javascript, "./response.ffi.mjs", "is_redirected")
pub fn is_redirected(response: Response) -> Bool

@external(javascript, "./response.ffi.mjs", "status")
pub fn status(response: Response) -> Int

@external(javascript, "./response.ffi.mjs", "status_text")
pub fn status_text(response: Response) -> String

@external(javascript, "./response.ffi.mjs", "type_")
pub fn type_(response: Response) -> String

@external(javascript, "./response.ffi.mjs", "url")
pub fn url(response: Response) -> String

@external(javascript, "./response.ffi.mjs", "clone")
pub fn clone(response: Response) -> Response

/// A simple getter used to expose a `ReadableStream` of the body contents.
///
@external(javascript, "./response.ffi.mjs", "body")
pub fn body(response: Response) -> Result(ReadableStream(Uint8Array), Nil)

/// Stores a `Boolean` that declares whether the body has been used in a
/// response yet.
///
@external(javascript, "./response.ffi.mjs", "is_body_used")
pub fn is_body_used(response: Response) -> Bool

/// Takes a `Response` stream and reads it to completion. It returns a promise
/// that resolves with an `ArrayBuffer`.
///
@external(javascript, "./response.ffi.mjs", "array_buffer")
pub fn array_buffer(response: Response) -> Promise(Result(ArrayBuffer, String))

/// Takes a `Response` stream and reads it to completion. It returns a promise
/// that resolves with a `Uint8Array`.
///
@external(javascript, "./response.ffi.mjs", "bytes")
pub fn bytes(response: Response) -> Promise(Result(Uint8Array, String))

/// Takes a `Response` stream and reads it to completion. It returns a promise
/// that resolves with the result of parsing the body text as JSON.
///
@external(javascript, "./response.ffi.mjs", "json_body")
pub fn json_body(response: Response) -> Promise(Result(Dynamic, String))

/// Takes a `Response` stream and reads it to completion. It returns a promise
/// that resolves with a `USVString` (text).
///
@external(javascript, "./response.ffi.mjs", "text")
pub fn text(response: Response) -> Promise(Result(String, String))
