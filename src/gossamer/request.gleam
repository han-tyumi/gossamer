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
  with init: List(RequestInit),
) -> Result(Request, String)

@external(javascript, "./request.ffi.mjs", "method")
pub fn method(of request: Request) -> String

@external(javascript, "./request.ffi.mjs", "url")
pub fn url(of request: Request) -> String

@external(javascript, "./request.ffi.mjs", "headers")
pub fn headers(of request: Request) -> Headers

/// Returns the cache mode associated with the request.
///
/// Note: Not available on Deno (returns `undefined`).
/// See https://github.com/denoland/deno/issues/27763
///
@external(javascript, "./request.ffi.mjs", "cache")
pub fn cache(of request: Request) -> String

/// Returns the credentials mode associated with the request.
///
/// Note: Not available on Deno (returns `undefined`).
/// See https://github.com/denoland/deno/issues/27763
///
@external(javascript, "./request.ffi.mjs", "credentials")
pub fn credentials(of request: Request) -> String

/// Returns the kind of resource requested by the request.
///
/// Note: Not available on Deno (returns `undefined`).
/// See https://github.com/denoland/deno/issues/27763
///
@external(javascript, "./request.ffi.mjs", "destination")
pub fn destination(of request: Request) -> String

@external(javascript, "./request.ffi.mjs", "redirect")
pub fn redirect(of request: Request) -> String

@external(javascript, "./request.ffi.mjs", "signal")
pub fn signal(of request: Request) -> AbortSignal

/// Returns the referrer of the request.
///
/// Note: Not available on Deno (returns `undefined`).
/// See https://github.com/denoland/deno/issues/27763
///
@external(javascript, "./request.ffi.mjs", "referrer")
pub fn referrer(of request: Request) -> String

/// Returns the referrer policy associated with the request.
///
/// Note: Not available on Deno (returns `undefined`).
/// See https://github.com/denoland/deno/issues/27763
///
@external(javascript, "./request.ffi.mjs", "referrer_policy")
pub fn referrer_policy(of request: Request) -> String

/// Returns the mode associated with the request.
///
/// Note: Not available on Deno (returns `undefined`).
/// See https://github.com/denoland/deno/issues/27763
///
@external(javascript, "./request.ffi.mjs", "mode")
pub fn mode(of request: Request) -> String

/// Returns whether the request can outlive the global in which it was created.
///
/// Note: Not available on Deno (returns `undefined`).
/// See https://github.com/denoland/deno/issues/27763
///
@external(javascript, "./request.ffi.mjs", "is_keepalive")
pub fn is_keepalive(request: Request) -> Bool

/// Returns the subresource integrity metadata of the request.
///
/// Note: Not available on Deno (returns `undefined`).
/// See https://github.com/denoland/deno/issues/27763
///
@external(javascript, "./request.ffi.mjs", "integrity")
pub fn integrity(of request: Request) -> String

@external(javascript, "./request.ffi.mjs", "clone")
pub fn clone(request: Request) -> Request

@external(javascript, "./request.ffi.mjs", "body")
pub fn body(of request: Request) -> Result(ReadableStream(Uint8Array), Nil)

@external(javascript, "./request.ffi.mjs", "is_body_used")
pub fn is_body_used(request: Request) -> Bool

@external(javascript, "./request.ffi.mjs", "blob")
pub fn blob(of request: Request) -> Promise(Result(Blob, String))

@external(javascript, "./request.ffi.mjs", "array_buffer")
pub fn array_buffer(of request: Request) -> Promise(Result(ArrayBuffer, String))

@external(javascript, "./request.ffi.mjs", "bytes")
pub fn bytes(of request: Request) -> Promise(Result(Uint8Array, String))

@external(javascript, "./request.ffi.mjs", "json")
pub fn json(of request: Request) -> Promise(Result(Dynamic, String))

@external(javascript, "./request.ffi.mjs", "form_data")
pub fn form_data(of request: Request) -> Promise(Result(FormData, String))

@external(javascript, "./request.ffi.mjs", "text")
pub fn text(of request: Request) -> Promise(Result(String, String))
