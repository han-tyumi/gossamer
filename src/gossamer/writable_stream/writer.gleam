import gossamer/promise.{type Promise}
import gleam/option.{type Option}

@external(javascript, "./writer.type.ts", "Writer$")
pub type Writer(a)

@external(javascript, "./writer.ffi.mjs", "closed")
pub fn closed(writer: Writer(a)) -> Promise(Nil)

@external(javascript, "./writer.ffi.mjs", "desired_size")
pub fn desired_size(writer: Writer(a)) -> Option(Int)

@external(javascript, "./writer.ffi.mjs", "ready")
pub fn ready(writer: Writer(a)) -> Promise(Nil)

@external(javascript, "./writer.ffi.mjs", "abort")
pub fn abort(writer: Writer(a), reason: r) -> Promise(Nil)

@external(javascript, "./writer.ffi.mjs", "close")
pub fn close(writer: Writer(a)) -> Promise(Nil)

@external(javascript, "./writer.ffi.mjs", "release_lock")
pub fn release_lock(writer: Writer(a)) -> Writer(a)

@external(javascript, "./writer.ffi.mjs", "write")
pub fn write(writer: Writer(a), chunk: a) -> Promise(Nil)
