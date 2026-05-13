//// The control side of the abort-signal pair. Create a controller,
//// pass its [`signal`](#signal) to cancelable operations like
//// `fetch_extra.send`, then call [`abort`](#abort) to cancel them.

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
/// [`abort`](#abort) call.
///
@external(javascript, "./abort_controller.ffi.mjs", "new_")
pub fn new() -> AbortController

/// The `AbortSignal` linked to this controller — pass it to operations
/// that accept a signal.
///
@external(javascript, "./abort_controller.ffi.mjs", "signal")
pub fn signal(controller: AbortController) -> AbortSignal

/// Aborts the controller's signal with `reason` (`Nil` for the
/// default `AbortError`). Other values are surfaced via
/// `abort_signal.reason`.
///
@external(javascript, "./abort_controller.ffi.mjs", "abort")
pub fn abort(controller: AbortController, reason reason: r) -> Nil
