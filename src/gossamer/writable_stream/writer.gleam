import gossamer/js_error.{type JsError}
import gossamer/promise.{type Promise}

/// A locked writer over a `WritableStream`.
///
/// See [WritableStreamDefaultWriter](https://developer.mozilla.org/en-US/docs/Web/API/WritableStreamDefaultWriter) on MDN.
///
@external(javascript, "./writer.type.ts", "Writer$")
pub type Writer(a)

/// Resolves when the stream closes. Returns an error if the stream
/// errored or the writer was released.
///
@external(javascript, "./writer.ffi.mjs", "closed")
pub fn closed(of writer: Writer(a)) -> Promise(Result(Nil, JsError))

/// The desired size to fill the stream's internal queue. Returns an error
/// if the stream has been closed or errored.
///
@external(javascript, "./writer.ffi.mjs", "desired_size")
pub fn desired_size(of writer: Writer(a)) -> Result(Int, Nil)

/// Resolves when the stream is ready to accept more writes (backpressure
/// has cleared). Returns an error if the stream errored.
///
@external(javascript, "./writer.ffi.mjs", "ready")
pub fn ready(of writer: Writer(a)) -> Promise(Result(Nil, JsError))

/// Aborts the stream. Returns an error if the underlying sink's abort
/// callback throws or returns a rejecting promise.
///
@external(javascript, "./writer.ffi.mjs", "abort")
pub fn abort(
  writer: Writer(a),
  reason reason: r,
) -> Promise(Result(Nil, JsError))

/// Closes the stream after all writes complete. Returns an error if the
/// underlying sink's close callback throws or returns a rejecting
/// promise.
///
@external(javascript, "./writer.ffi.mjs", "close")
pub fn close(writer: Writer(a)) -> Promise(Result(Nil, JsError))

/// Releases the writer's lock on the stream. Returns an error if there
/// are outstanding writes.
///
@external(javascript, "./writer.ffi.mjs", "release_lock")
pub fn release_lock(writer: Writer(a)) -> Result(Writer(a), JsError)

/// Writes `chunk` to the stream. Returns an error if the stream errored
/// or was closed.
///
@external(javascript, "./writer.ffi.mjs", "write")
pub fn write(
  to writer: Writer(a),
  chunk chunk: a,
) -> Promise(Result(Nil, JsError))
