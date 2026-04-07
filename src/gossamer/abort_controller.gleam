import gossamer/abort_signal.{type AbortSignal}

@external(javascript, "./abort_controller.type.ts", "AbortController$")
pub type AbortController

@external(javascript, "./abort_controller.ffi.mjs", "new_")
pub fn new() -> AbortController

@external(javascript, "./abort_controller.ffi.mjs", "signal")
pub fn signal(controller: AbortController) -> AbortSignal

@external(javascript, "./abort_controller.ffi.mjs", "abort")
pub fn abort(controller: AbortController, reason: r) -> AbortController
