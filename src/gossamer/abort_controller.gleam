//// The control side of the abort-signal pair. Create a controller,
//// pass its [`signal`](#signal) to cancelable operations like
//// `fetch_extra.send`, then call [`abort`](#abort) (or
//// [`abort_with`](#abort_with)) to cancel them.

import gossamer/abort_signal.{type AbortSignal}

/// Signals the cancellation of an operation via its associated
/// `AbortSignal`.
///
/// See [AbortController](https://developer.mozilla.org/en-US/docs/Web/API/AbortController) on MDN.
///
@external(javascript, "./abort_controller.type.ts", "AbortController$")
pub type AbortController

/// Creates a new `AbortController`. Its [`signal`](#signal) starts
/// in the not-yet-aborted state and transitions on the next
/// [`abort`](#abort) or [`abort_with`](#abort_with) call.
///
@external(javascript, "./abort_controller.ffi.mjs", "new_")
pub fn new() -> AbortController

/// The `AbortSignal` linked to this controller — pass it to operations
/// that accept a signal.
///
@external(javascript, "./abort_controller.ffi.mjs", "signal")
pub fn signal(controller: AbortController) -> AbortSignal

/// Aborts the controller's signal with a default `AbortError` reason.
///
@external(javascript, "./abort_controller.ffi.mjs", "abort")
pub fn abort(controller: AbortController) -> Nil

/// Aborts the controller's signal with the given `reason`. Use this
/// when the consumer needs to distinguish abort causes — `reason` is
/// surfaced via `abort_signal.reason`.
///
@external(javascript, "./abort_controller.ffi.mjs", "abort_with")
pub fn abort_with(controller: AbortController, reason reason: r) -> Nil
