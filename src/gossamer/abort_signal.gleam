import gleam/dynamic.{type Dynamic}
import gossamer/js_error.{type JsError}

/// A signal that communicates when an operation should be aborted.
/// Used with `fetch`, streams, and other cancellable operations.
///
/// See [AbortSignal](https://developer.mozilla.org/en-US/docs/Web/API/AbortSignal) on MDN.
///
@external(javascript, "./abort_signal.type.ts", "AbortSignal$")
pub type AbortSignal

@external(javascript, "./abort_signal.ffi.mjs", "abort")
pub fn abort(reason: r) -> AbortSignal

@external(javascript, "./abort_signal.ffi.mjs", "any")
pub fn any(signals: List(AbortSignal)) -> AbortSignal

/// Creates an `AbortSignal` that aborts automatically after `milliseconds`.
/// Returns an error if `milliseconds` is negative or greater than
/// `4294967295` (the maximum value of an unsigned 32-bit integer).
///
@external(javascript, "./abort_signal.ffi.mjs", "timeout")
pub fn timeout(milliseconds: Int) -> Result(AbortSignal, JsError)

@external(javascript, "./abort_signal.ffi.mjs", "is_aborted")
pub fn is_aborted(signal: AbortSignal) -> Bool

/// The reason the signal was aborted with, or `Error(Nil)` if the signal
/// is not aborted.
///
@external(javascript, "./abort_signal.ffi.mjs", "reason")
pub fn reason(for signal: AbortSignal) -> Result(Dynamic, Nil)

/// Returns `Error` with the abort reason if the signal is aborted, or
/// `Ok(Nil)` otherwise.
///
@external(javascript, "./abort_signal.ffi.mjs", "throw_if_aborted")
pub fn throw_if_aborted(signal: AbortSignal) -> Result(Nil, JsError)

@external(javascript, "./abort_signal.ffi.mjs", "on_abort")
pub fn on_abort(signal: AbortSignal, run handler: fn() -> a) -> Nil
