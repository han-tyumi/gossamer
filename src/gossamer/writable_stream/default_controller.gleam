import gossamer/abort_signal.{type AbortSignal}
import gleam/dynamic.{type Dynamic}

@external(javascript, "./default_controller.ffi.ts", "DefaultController$")
pub type DefaultController

@external(javascript, "./default_controller.ffi.mjs", "signal")
pub fn signal(controller: DefaultController) -> AbortSignal

@external(javascript, "./default_controller.ffi.mjs", "error")
pub fn error(controller: DefaultController, reason: Dynamic) -> Nil
