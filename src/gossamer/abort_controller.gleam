import gossamer/abort_signal.{type AbortSignal}

/// Signals the cancellation of an operation via its associated
/// `AbortSignal`.
///
/// See [AbortController](https://developer.mozilla.org/en-US/docs/Web/API/AbortController) on MDN.
///
@external(javascript, "./abort_controller.type.ts", "AbortController$")
pub type AbortController

@external(javascript, "./abort_controller.ffi.mjs", "new_")
pub fn new() -> AbortController

@external(javascript, "./abort_controller.ffi.mjs", "signal")
pub fn signal(of controller: AbortController) -> AbortSignal

@external(javascript, "./abort_controller.ffi.mjs", "abort")
pub fn abort(controller: AbortController) -> AbortController

@external(javascript, "./abort_controller.ffi.mjs", "abort_with")
pub fn abort_with(
  controller: AbortController,
  reason reason: r,
) -> AbortController
