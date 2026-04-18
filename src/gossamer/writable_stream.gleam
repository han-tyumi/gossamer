import gleam/dynamic.{type Dynamic}
import gossamer/promise.{type Promise}
import gossamer/writable_stream/default_controller.{type DefaultController}
import gossamer/writable_stream/writer.{type Writer}

@external(javascript, "./writable_stream.type.ts", "WritableStream$")
pub type WritableStream(a)

pub type UnderlyingSink(a) {
  Start(fn(DefaultController) -> Nil)
  Write(fn(a, DefaultController) -> Promise(Nil))
  Close(fn() -> Promise(Nil))
  Abort(fn(Dynamic) -> Promise(Nil))
}

@external(javascript, "./writable_stream.ffi.mjs", "new_")
pub fn new(sink: List(UnderlyingSink(a))) -> WritableStream(a)

pub fn from_write(
  write: fn(a, DefaultController) -> Promise(Nil),
) -> WritableStream(a) {
  new([Write(write)])
}

@external(javascript, "./writable_stream.ffi.mjs", "is_locked")
pub fn is_locked(stream: WritableStream(a)) -> Bool

@external(javascript, "./writable_stream.ffi.mjs", "abort")
pub fn abort(
  stream: WritableStream(a),
  reason reason: r,
) -> Promise(Result(Nil, String))

@external(javascript, "./writable_stream.ffi.mjs", "close")
pub fn close(stream: WritableStream(a)) -> Promise(Result(Nil, String))

@external(javascript, "./writable_stream.ffi.mjs", "get_writer")
pub fn get_writer(stream: WritableStream(a)) -> Result(Writer(a), String)
