//// The read side of the abort-signal pair. Accept a signal in
//// cancelable operations like `fetch_extra.send`, then observe its
//// state via [`is_aborted`](#is_aborted) / [`reason`](#reason) or
//// react to cancellation via [`set_on_abort`](#set_on_abort).
//// `AbortSignal` values are produced by an `abort_controller` or by
//// the constructors below.

import gleam/dynamic.{type Dynamic}
import gleam/time/duration.{type Duration}

/// A signal that communicates when an operation should be aborted.
/// Used with `fetch`, streams, and other cancellable operations.
///
/// See [AbortSignal](https://developer.mozilla.org/en-US/docs/Web/API/AbortSignal) on MDN.
///
@external(javascript, "./abort_signal.type.ts", "AbortSignal$")
pub type AbortSignal

/// Returns an `AbortSignal` that is already aborted with the given
/// `reason`. Useful for short-circuiting operations that accept a
/// signal without wiring up a full controller. Equivalent to
/// JavaScript's static `AbortSignal.abort`.
///
@external(javascript, "./abort_signal.ffi.mjs", "abort")
pub fn abort(reason: r) -> AbortSignal

/// Returns an `AbortSignal` that becomes aborted as soon as any of
/// `signals` does, with the same `reason` as the triggering signal.
/// Equivalent to JavaScript's static `AbortSignal.any`.
///
@external(javascript, "./abort_signal.ffi.mjs", "any")
pub fn any(signals: List(AbortSignal)) -> AbortSignal

/// Creates an `AbortSignal` that aborts automatically after `duration`.
/// Negative durations are treated as zero. Node enforces an unsigned
/// 32-bit upper bound on the resolved millisecond value; Deno and Bun
/// accept values up to `9_007_199_254_740_991`. Equivalent to
/// JavaScript's static `AbortSignal.timeout`.
///
@external(javascript, "./abort_signal.ffi.mjs", "timeout")
pub fn timeout(duration: Duration) -> AbortSignal

/// `True` once the signal has been aborted. Equivalent to JavaScript's
/// `signal.aborted`.
///
@external(javascript, "./abort_signal.ffi.mjs", "is_aborted")
pub fn is_aborted(signal: AbortSignal) -> Bool

/// The reason the signal was aborted with. Returns `Error(Nil)` if
/// the signal has not been aborted. A default-aborted signal carries
/// an `AbortError` `DOMException`; a controller aborted with an
/// explicit reason holds that value. JavaScript-side
/// `controller.abort(null)` surfaces as `Ok` of a dynamic `null`.
///
@external(javascript, "./abort_signal.ffi.mjs", "reason")
pub fn reason(signal: AbortSignal) -> Result(Dynamic, Nil)

/// Registers `handler` to run when the signal aborts. If the signal is
/// already aborted, `handler` is not called. Equivalent to JavaScript's
/// `signal.onabort`.
///
@external(javascript, "./abort_signal.ffi.mjs", "set_on_abort")
pub fn set_on_abort(signal: AbortSignal, run handler: fn() -> a) -> Nil
