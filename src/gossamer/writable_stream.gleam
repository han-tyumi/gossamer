import gossamer/promise.{type Promise}
import gossamer/writable_stream/default_controller.{type DefaultController}
import gossamer/writable_stream/underlying_sink.{type UnderlyingSink}
import gossamer/writable_stream/writer.{type Writer}

@external(javascript, "./writable_stream.type.ts", "WritableStream$")
pub type WritableStream(a)

@external(javascript, "./writable_stream.ffi.mjs", "new_")
pub fn new(sink: List(UnderlyingSink(a))) -> WritableStream(a)

/// Creates a WritableStream that processes each chunk via a write callback.
///
pub fn from_write(
  write: fn(a, DefaultController) -> Promise(Nil),
) -> WritableStream(a) {
  new([underlying_sink.Write(write)])
}

@external(javascript, "./writable_stream.ffi.mjs", "is_locked")
pub fn is_locked(stream: WritableStream(a)) -> Bool

@external(javascript, "./writable_stream.ffi.mjs", "abort")
pub fn abort(stream: WritableStream(a), reason: r) -> Promise(Nil)

@external(javascript, "./writable_stream.ffi.mjs", "close")
pub fn close(stream: WritableStream(a)) -> Promise(Nil)

@external(javascript, "./writable_stream.ffi.mjs", "get_writer")
pub fn get_writer(stream: WritableStream(a)) -> Writer(a)
