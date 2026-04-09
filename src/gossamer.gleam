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
  with init: List(RequestInit),
) -> Promise(Result(Response, String))

@external(javascript, "./gossamer.ffi.mjs", "fetch_request")
pub fn fetch_request(request: Request) -> Promise(Result(Response, String))

@external(javascript, "./gossamer.ffi.mjs", "structured_clone")
pub fn structured_clone(value: a) -> Result(a, String)

@external(javascript, "./gossamer.ffi.mjs", "atob")
pub fn atob(encoded: String) -> Result(String, String)

@external(javascript, "./gossamer.ffi.mjs", "btoa")
pub fn btoa(data: String) -> Result(String, String)

@external(javascript, "./gossamer.ffi.mjs", "clear_interval")
pub fn clear_interval(id: Int) -> Nil

@external(javascript, "./gossamer.ffi.mjs", "clear_timeout")
pub fn clear_timeout(id: Int) -> Nil

/// A microtask is a short function which is executed after the function or
/// module which created it exits and only if the JavaScript execution stack is
/// empty, but before returning control to the event loop being used to drive the
/// script's execution environment.
///
@external(javascript, "./gossamer.ffi.mjs", "queue_microtask")
pub fn queue_microtask(run func: fn() -> a) -> Nil

@external(javascript, "./gossamer.ffi.mjs", "set_interval")
pub fn set_interval(every delay: Int, run callback: fn() -> a) -> Int

/// Sets a timer which executes a function once after the delay
/// (in milliseconds) elapses. Returns an id which may be used to cancel the
/// timeout.
///
@external(javascript, "./gossamer.ffi.mjs", "set_timeout")
pub fn set_timeout(after delay: Int, run callback: fn() -> a) -> Int

@external(javascript, "./gossamer.ffi.mjs", "user_agent")
pub fn user_agent() -> String
