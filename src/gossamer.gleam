//// Top-level cross-runtime APIs: timers, base64, structured cloning,
//// and more. Domain-specific APIs live in submodules (see
//// `gossamer/url`, `gossamer/stream/readable_stream`, `gossamer/fetch_extra`,
//// etc.).

import gossamer/js_error.{type JsError}

/// Creates a deep clone of `value` using the structured clone algorithm.
/// Returns an error if `value` contains a function, symbol, or other
/// non-cloneable value.
///
@external(javascript, "./gossamer.ffi.mjs", "structured_clone")
pub fn structured_clone(value: a) -> Result(a, JsError)

/// Decodes a base64-encoded string. Returns an error if the string is
/// not valid base64.
///
@external(javascript, "./gossamer.ffi.mjs", "atob")
pub fn atob(encoded: String) -> Result(String, JsError)

/// Encodes a binary string as base64. Returns an error if `data` contains
/// code points beyond `0xFF` (use `uint8_array.to_base64` for arbitrary
/// bytes).
///
@external(javascript, "./gossamer.ffi.mjs", "btoa")
pub fn btoa(data: String) -> Result(String, JsError)

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
