import gleam/dynamic.{type Dynamic}
import gleam/option.{type Option}

@external(javascript, "./default_controller.type.ts", "DefaultController$")
pub type DefaultController(a)

@external(javascript, "./default_controller.ffi.mjs", "desired_size")
pub fn desired_size(controller: DefaultController(a)) -> Option(Int)

@external(javascript, "./default_controller.ffi.mjs", "close")
pub fn close(controller: DefaultController(a)) -> Nil

@external(javascript, "./default_controller.ffi.mjs", "enqueue")
pub fn enqueue(controller: DefaultController(a), chunk: a) -> Nil

@external(javascript, "./default_controller.ffi.mjs", "error")
pub fn error(controller: DefaultController(a), reason: Dynamic) -> Nil
