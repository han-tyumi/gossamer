@external(javascript, "./default_controller.type.ts", "DefaultController$")
pub type DefaultController(a)

@external(javascript, "./default_controller.ffi.mjs", "desired_size")
pub fn desired_size(of controller: DefaultController(a)) -> Result(Int, Nil)

@external(javascript, "./default_controller.ffi.mjs", "enqueue")
pub fn enqueue(
  in controller: DefaultController(a),
  chunk chunk: a,
) -> Result(Nil, String)

@external(javascript, "./default_controller.ffi.mjs", "error")
pub fn error(
  controller: DefaultController(a),
  reason reason: b,
) -> Result(Nil, String)

@external(javascript, "./default_controller.ffi.mjs", "terminate")
pub fn terminate(controller: DefaultController(a)) -> Result(Nil, String)
