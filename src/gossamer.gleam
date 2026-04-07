import gossamer/promise.{type Promise}
import gossamer/request.{type Request}
import gossamer/request_init.{type RequestInit}
import gossamer/response.{type Response}

@external(javascript, "./gossamer.type.ts", "Date$")
pub type Date

@external(javascript, "./gossamer.ffi.mjs", "fetch_")
pub fn fetch(url: String) -> Promise(Result(Response, String))

@external(javascript, "./gossamer.ffi.mjs", "fetch_with_init")
pub fn fetch_with_init(
  url: String,
  init: List(RequestInit),
) -> Promise(Result(Response, String))

@external(javascript, "./gossamer.ffi.mjs", "fetch_request")
pub fn fetch_request(request: Request) -> Promise(Result(Response, String))

@external(javascript, "./gossamer.ffi.mjs", "alert")
pub fn alert(message: String) -> Nil

@external(javascript, "./gossamer.ffi.mjs", "clear_interval")
pub fn clear_interval(id: Int) -> Nil

@external(javascript, "./gossamer.ffi.mjs", "clear_timeout")
pub fn clear_timeout(id: Int) -> Nil

@external(javascript, "./gossamer.ffi.mjs", "close")
pub fn close() -> Nil

@external(javascript, "./gossamer.ffi.mjs", "confirm")
pub fn confirm(message: String) -> Bool

@external(javascript, "./gossamer.ffi.mjs", "prompt")
pub fn prompt(message: String, default: String) -> Result(String, Nil)

/// A microtask is a short function which is executed after the function or
/// module which created it exits and only if the JavaScript execution stack is
/// empty, but before returning control to the event loop being used to drive the
/// script's execution environment.
///
@external(javascript, "./gossamer.ffi.mjs", "queue_microtask")
pub fn queue_microtask(func: fn() -> Nil) -> Nil

@external(javascript, "./gossamer.ffi.mjs", "report_error")
pub fn report_error(error: e) -> Nil

@external(javascript, "./gossamer.ffi.mjs", "set_interval")
pub fn set_interval(delay: Int, callback: fn() -> Nil) -> Int

/// Sets a timer which executes a function once after the delay
/// (in milliseconds) elapses. Returns an id which may be used to cancel the
/// timeout.
///
@external(javascript, "./gossamer.ffi.mjs", "set_timeout")
pub fn set_timeout(delay: Int, callback: fn() -> Nil) -> Int
