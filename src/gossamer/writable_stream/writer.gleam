import gossamer/promise.{type Promise}

@external(javascript, "./writer.type.ts", "Writer$")
pub type Writer(a)

@external(javascript, "./writer.ffi.mjs", "closed")
pub fn closed(of writer: Writer(a)) -> Promise(Result(Nil, String))

@external(javascript, "./writer.ffi.mjs", "desired_size")
pub fn desired_size(of writer: Writer(a)) -> Result(Int, Nil)

@external(javascript, "./writer.ffi.mjs", "ready")
pub fn ready(of writer: Writer(a)) -> Promise(Result(Nil, String))

@external(javascript, "./writer.ffi.mjs", "abort")
pub fn abort(
  writer: Writer(a),
  reason reason: r,
) -> Promise(Result(Nil, String))

@external(javascript, "./writer.ffi.mjs", "close")
pub fn close(writer: Writer(a)) -> Promise(Result(Nil, String))

@external(javascript, "./writer.ffi.mjs", "release_lock")
pub fn release_lock(writer: Writer(a)) -> Result(Writer(a), String)

@external(javascript, "./writer.ffi.mjs", "write")
pub fn write(
  to writer: Writer(a),
  chunk chunk: a,
) -> Promise(Result(Nil, String))
