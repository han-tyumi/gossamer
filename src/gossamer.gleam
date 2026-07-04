//// Top-level cross-runtime APIs: timers, base64, microtask
//// scheduling, and navigator info. Domain-specific APIs live in
//// submodules (see `gossamer/url`, `gossamer/stream/readable_stream`,
//// `gossamer/fetch_extra`, etc.).

import gleam/time/duration.{type Duration}

/// Decodes a base64-encoded string. Returns an error if the string is
/// not valid base64. Equivalent to JavaScript's `atob`.
///
@external(javascript, "./gossamer.ffi.mjs", "decode_base64")
pub fn decode_base64(encoded: String) -> Result(String, Nil)

/// Encodes a binary string as base64. Returns an error if `data`
/// contains code points beyond `0xFF` (use
/// `gleam/bit_array.base64_encode` for arbitrary bytes). Equivalent to
/// JavaScript's `btoa`.
///
@external(javascript, "./gossamer.ffi.mjs", "encode_base64")
pub fn encode_base64(data: String) -> Result(String, Nil)

/// Cancels a repeating timer previously scheduled with `set_interval`.
///
@external(javascript, "./gossamer.ffi.mjs", "clear_interval")
pub fn clear_interval(id: Int) -> Nil

/// Cancels a one-shot timer previously scheduled with `set_timeout`.
///
@external(javascript, "./gossamer.ffi.mjs", "clear_timeout")
pub fn clear_timeout(id: Int) -> Nil

/// Schedules `callback` to run as a microtask — after the current
/// execution stack empties but before returning control to the event
/// loop.
///
@external(javascript, "./gossamer.ffi.mjs", "queue_microtask")
pub fn queue_microtask(callback: fn() -> a) -> Nil

/// Schedules `callback` to run repeatedly every `delay`. Returns an id
/// that can be passed to `clear_interval` to cancel. Negative durations
/// are treated as zero.
///
@external(javascript, "./gossamer.ffi.mjs", "set_interval")
pub fn set_interval(delay: Duration, callback: fn() -> a) -> Int

/// Sets a timer which executes `callback` once after `delay` elapses.
/// Returns an id that can be passed to `clear_timeout` to cancel.
/// Negative durations are treated as zero.
///
@external(javascript, "./gossamer.ffi.mjs", "set_timeout")
pub fn set_timeout(delay: Duration, callback: fn() -> a) -> Int

/// Returns the runtime's user agent string (e.g., browser identity,
/// Deno/Node version). Equivalent to JavaScript's `navigator.userAgent`.
///
@external(javascript, "./gossamer.ffi.mjs", "user_agent")
pub fn user_agent() -> String

/// Returns the number of logical processors available to the runtime.
/// Useful for sizing worker pools. Some browsers cap this value for
/// fingerprinting protection. Equivalent to JavaScript's
/// `navigator.hardwareConcurrency`.
///
@external(javascript, "./gossamer.ffi.mjs", "hardware_concurrency")
pub fn hardware_concurrency() -> Int
