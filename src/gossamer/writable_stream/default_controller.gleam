import gleam/dynamic.{type Dynamic}
import gossamer/abort_signal.{type AbortSignal}

@external(javascript, "./default_controller.type.ts", "DefaultController$")
pub type DefaultController

@external(javascript, "./default_controller.ffi.mjs", "signal")
pub fn signal(of controller: DefaultController) -> AbortSignal

@external(javascript, "./default_controller.ffi.mjs", "error")
pub fn error(controller: DefaultController, reason reason: Dynamic) -> Nil
