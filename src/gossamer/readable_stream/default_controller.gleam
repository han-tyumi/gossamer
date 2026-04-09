import gleam/dynamic.{type Dynamic}

@external(javascript, "./default_controller.type.ts", "DefaultController$")
pub type DefaultController(a)

@external(javascript, "./default_controller.ffi.mjs", "desired_size")
pub fn desired_size(of controller: DefaultController(a)) -> Result(Int, Nil)

@external(javascript, "./default_controller.ffi.mjs", "close")
pub fn close(controller: DefaultController(a)) -> Nil

@external(javascript, "./default_controller.ffi.mjs", "enqueue")
pub fn enqueue(in controller: DefaultController(a), chunk chunk: a) -> Nil

@external(javascript, "./default_controller.ffi.mjs", "error")
pub fn error(controller: DefaultController(a), reason reason: Dynamic) -> Nil
