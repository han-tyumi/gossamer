import gleam/dynamic.{type Dynamic}
import gossamer/abort_signal.{type AbortSignal}
import gossamer/array_buffer.{type ArrayBuffer}
import gossamer/blob.{type Blob}
import gossamer/form_data.{type FormData}
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

@external(javascript, "./request.ffi.mjs", "method")
pub fn method(request: Request) -> String

@external(javascript, "./request.ffi.mjs", "url")
pub fn url(request: Request) -> String

@external(javascript, "./request.ffi.mjs", "headers")
pub fn headers(request: Request) -> Headers

@external(javascript, "./request.ffi.mjs", "cache")
pub fn cache(request: Request) -> String

@external(javascript, "./request.ffi.mjs", "credentials")
pub fn credentials(request: Request) -> String

@external(javascript, "./request.ffi.mjs", "destination")
pub fn destination(request: Request) -> String

@external(javascript, "./request.ffi.mjs", "redirect")
pub fn redirect(request: Request) -> String

@external(javascript, "./request.ffi.mjs", "signal")
pub fn signal(request: Request) -> AbortSignal

@external(javascript, "./request.ffi.mjs", "referrer")
pub fn referrer(request: Request) -> String

@external(javascript, "./request.ffi.mjs", "referrer_policy")
pub fn referrer_policy(request: Request) -> String

@external(javascript, "./request.ffi.mjs", "mode")
pub fn mode(request: Request) -> String

@external(javascript, "./request.ffi.mjs", "is_keepalive")
pub fn is_keepalive(request: Request) -> Bool

@external(javascript, "./request.ffi.mjs", "integrity")
pub fn integrity(request: Request) -> String

@external(javascript, "./request.ffi.mjs", "clone")
pub fn clone(request: Request) -> Request

@external(javascript, "./request.ffi.mjs", "body")
pub fn body(request: Request) -> Result(ReadableStream(Uint8Array), Nil)

@external(javascript, "./request.ffi.mjs", "is_body_used")
pub fn is_body_used(request: Request) -> Bool

@external(javascript, "./request.ffi.mjs", "blob")
pub fn blob(request: Request) -> Promise(Result(Blob, String))

@external(javascript, "./request.ffi.mjs", "array_buffer")
pub fn array_buffer(request: Request) -> Promise(Result(ArrayBuffer, String))

@external(javascript, "./request.ffi.mjs", "bytes")
pub fn bytes(request: Request) -> Promise(Result(Uint8Array, String))

@external(javascript, "./request.ffi.mjs", "json")
pub fn json(request: Request) -> Promise(Result(Dynamic, String))

@external(javascript, "./request.ffi.mjs", "form_data")
pub fn form_data(request: Request) -> Promise(Result(FormData, String))

@external(javascript, "./request.ffi.mjs", "text")
pub fn text(request: Request) -> Promise(Result(String, String))
