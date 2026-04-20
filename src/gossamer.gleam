//// Top-level cross-runtime Web Platform APIs: `fetch`, timers, base64,
//// structured cloning, and more. Domain-specific APIs live in submodules
//// (see `gossamer/url`, `gossamer/headers`, `gossamer/readable_stream`,
//// etc.).

import gossamer/promise.{type Promise}
import gossamer/request.{type Request, type RequestInit}
import gossamer/response.{type Response}
import gossamer/url.{type URL}

/// Fetches a resource from `url`. Returns an error on network error,
/// CORS failure, or if the URL is invalid.
///
@external(javascript, "./gossamer.ffi.mjs", "fetch_")
pub fn fetch(url: String) -> Promise(Result(Response, String))

/// Fetches a resource from `url` with the given request init options.
/// Returns an error on network error, CORS failure, or if the URL or
/// `init` is invalid.
///
@external(javascript, "./gossamer.ffi.mjs", "fetch_with")
pub fn fetch_with(
  url: String,
  with init: List(RequestInit),
) -> Promise(Result(Response, String))

/// Fetches a resource from `url`. Returns an error on network error or
/// CORS failure.
///
@external(javascript, "./gossamer.ffi.mjs", "fetch_url")
pub fn fetch_url(url: URL) -> Promise(Result(Response, String))

/// Fetches a resource from `url` with the given request init options.
/// Returns an error on network error, CORS failure, or if `init` is
/// invalid.
///
@external(javascript, "./gossamer.ffi.mjs", "fetch_url_with")
pub fn fetch_url_with(
  url: URL,
  with init: List(RequestInit),
) -> Promise(Result(Response, String))

/// Fetches a resource using a pre-built `Request`. Returns an error on
/// network error or CORS failure.
///
@external(javascript, "./gossamer.ffi.mjs", "fetch_request")
pub fn fetch_request(request: Request) -> Promise(Result(Response, String))

/// Fetches a resource using a pre-built `Request`, with `init` options
/// that override fields on `request`. Returns an error on network error,
/// CORS failure, or if `init` is invalid.
///
@external(javascript, "./gossamer.ffi.mjs", "fetch_request_with")
pub fn fetch_request_with(
  request: Request,
  with init: List(RequestInit),
) -> Promise(Result(Response, String))

/// Creates a deep clone of `value` using the structured clone algorithm.
/// Returns an error if `value` contains a function, symbol, or other
/// non-cloneable value.
///
@external(javascript, "./gossamer.ffi.mjs", "structured_clone")
pub fn structured_clone(value: a) -> Result(a, String)

/// Decodes a base64-encoded string. Returns an error if the string is
/// not valid base64.
///
@external(javascript, "./gossamer.ffi.mjs", "atob")
pub fn atob(encoded: String) -> Result(String, String)

/// Encodes a binary string as base64. Returns an error if `data` contains
/// code points beyond 0xFF (use `uint8_array.to_base64` for arbitrary
/// bytes).
///
@external(javascript, "./gossamer.ffi.mjs", "btoa")
pub fn btoa(data: String) -> Result(String, String)

/// Cancels a repeating timer previously scheduled with `set_interval`.
///
@external(javascript, "./gossamer.ffi.mjs", "clear_interval")
pub fn clear_interval(id: Int) -> Nil

/// Cancels a one-shot timer previously scheduled with `set_timeout`.
///
@external(javascript, "./gossamer.ffi.mjs", "clear_timeout")
pub fn clear_timeout(id: Int) -> Nil

/// A microtask is a short function which is executed after the function or
/// module which created it exits and only if the JavaScript execution stack is
/// empty, but before returning control to the event loop.
///
@external(javascript, "./gossamer.ffi.mjs", "queue_microtask")
pub fn queue_microtask(run func: fn() -> a) -> Nil

/// Schedules `callback` to run repeatedly every `delay` milliseconds.
/// Returns an id that can be passed to `clear_interval` to cancel.
///
@external(javascript, "./gossamer.ffi.mjs", "set_interval")
pub fn set_interval(every delay: Int, run callback: fn() -> a) -> Int

/// Sets a timer which executes a function once after the delay
/// (in milliseconds) elapses. Returns an id which may be used to cancel the
/// timeout.
///
@external(javascript, "./gossamer.ffi.mjs", "set_timeout")
pub fn set_timeout(after delay: Int, run callback: fn() -> a) -> Int

/// Returns the runtime's user agent string (e.g., browser identity,
/// Deno/Node version).
///
@external(javascript, "./gossamer.ffi.mjs", "user_agent")
pub fn user_agent() -> String
