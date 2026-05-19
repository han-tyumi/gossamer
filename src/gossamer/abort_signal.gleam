//// Accept an `AbortSignal` in cancelable operations like
//// `fetch_extra.send`, then observe its state via
//// [`is_aborted`](#is_aborted) / [`reason`](#reason) or await
//// cancellation via [`on_abort`](#on_abort). Signals are produced by
//// [`new`](#new) (paired with an abort function) or by the static
//// constructors [`abort`](#abort), [`any`](#any), and
//// [`timeout`](#timeout).

import gleam/dynamic.{type Dynamic}
import gleam/javascript/promise.{type Promise}
import gleam/time/duration.{type Duration}

/// A signal that communicates when an operation should be aborted.
/// Used with `fetch`, streams, and other cancelable operations.
///
/// See [AbortSignal](https://developer.mozilla.org/en-US/docs/Web/API/AbortSignal) on MDN.
///
@external(javascript, "./abort_signal.type.ts", "AbortSignal$")
pub type AbortSignal

/// Returns a fresh `AbortSignal` paired with a function that aborts
/// it. Pass the signal to cancelable operations; call the abort
/// function (with a `reason`, or `Nil` for the default `AbortError`)
/// when it's time to cancel. Equivalent to constructing a JavaScript
/// `AbortController` and exposing its `signal` and `abort` method.
///
@external(javascript, "./abort_signal.ffi.mjs", "new_")
pub fn new() -> #(AbortSignal, fn(r) -> Nil)

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

/// The reason the signal was aborted with. Returns `Error(Nil)` while
/// the signal has not been aborted. Once aborted, returns `Ok(reason)`
/// carrying whatever value the abort site supplied, including the
/// spec default `AbortError` `DOMException` when no reason was given.
///
@external(javascript, "./abort_signal.ffi.mjs", "reason")
pub fn reason(signal: AbortSignal) -> Result(Dynamic, Nil)

/// Resolves with the abort reason when `signal` aborts, or
/// immediately if `signal` is already aborted. Each call returns an
/// independent `Promise`, so multiple awaiters can each receive the
/// notification. Equivalent to listening once for JavaScript's `abort`
/// event and reading `signal.reason`.
///
@external(javascript, "./abort_signal.ffi.mjs", "on_abort")
pub fn on_abort(signal: AbortSignal) -> Promise(Dynamic)
