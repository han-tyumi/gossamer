import gleam/dynamic.{type Dynamic}
import gossamer/promise.{type Promise}
import gossamer/writable_stream/default_controller.{type DefaultController}
import gossamer/writable_stream/writer.{type Writer}

/// A destination stream for writing bytes or objects.
///
/// See [WritableStream](https://developer.mozilla.org/en-US/docs/Web/API/WritableStream) on MDN.
///
@external(javascript, "./writable_stream.type.ts", "WritableStream$")
pub type WritableStream(a)

pub type UnderlyingSink(a) {
  Start(fn(DefaultController) -> Nil)
  Write(fn(a, DefaultController) -> Promise(Nil))
  Close(fn() -> Promise(Nil))
  Abort(fn(Dynamic) -> Promise(Nil))
}

/// Creates a `WritableStream` driven by the given underlying-sink callbacks
/// (`Start`, `Write`, `Close`, `Abort`).
///
@external(javascript, "./writable_stream.ffi.mjs", "new_")
pub fn new(sink: List(UnderlyingSink(a))) -> WritableStream(a)

/// Creates a `WritableStream` from only a `Write` callback — use when the
/// sink just needs to handle incoming chunks.
///
pub fn from_write(
  write: fn(a, DefaultController) -> Promise(Nil),
) -> WritableStream(a) {
  new([Write(write)])
}

/// Checks whether the stream is locked to a writer.
///
@external(javascript, "./writable_stream.ffi.mjs", "is_locked")
pub fn is_locked(stream: WritableStream(a)) -> Bool

/// Aborts the stream. Rejects if the underlying sink's abort callback
/// throws or returns a rejecting promise.
///
@external(javascript, "./writable_stream.ffi.mjs", "abort")
pub fn abort(
  stream: WritableStream(a),
  reason reason: r,
) -> Promise(Result(Nil, String))

/// Closes the stream after all writes complete. Rejects if the underlying
/// sink's close callback throws or returns a rejecting promise.
///
@external(javascript, "./writable_stream.ffi.mjs", "close")
pub fn close(stream: WritableStream(a)) -> Promise(Result(Nil, String))

/// Acquires a `Writer` that locks the stream. Returns an error if the
/// stream is already locked.
///
@external(javascript, "./writable_stream.ffi.mjs", "get_writer")
pub fn get_writer(stream: WritableStream(a)) -> Result(Writer(a), String)
