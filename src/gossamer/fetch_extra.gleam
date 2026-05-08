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
//// - Send variants that take a `FetchOptions` for the configuration
////   `gleam/fetch.send` doesn't expose.
////
//// When you don't need extra configuration, prefer `gleam/fetch.send`
//// directly.

import gleam/fetch.{type FetchBody, type FetchError}
import gleam/fetch/form_data.{type FormData}
import gleam/http/request.{type Request}
import gleam/http/response.{type Response}
import gleam/javascript/promise.{type Promise}
import gossamer/fetch_options.{type FetchOptions}
import gossamer/response_type.{type ResponseType}

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
