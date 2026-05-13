import gleam/javascript/promise.{type Promise}
import gossamer/stream.{type StreamLifecycleError}

/// A locked writer over a `WritableStream`.
///
/// See [WritableStreamDefaultWriter](https://developer.mozilla.org/en-US/docs/Web/API/WritableStreamDefaultWriter) on MDN.
///
@external(javascript, "./writer.type.ts", "Writer$")
pub type Writer(a)

/// Resolves when the stream closes. Returns `Errored` if the stream
/// enters an errored state, or `Released` if the writer no longer
/// holds the lock.
///
@external(javascript, "./writer.ffi.mjs", "closed")
pub fn closed(writer: Writer(a)) -> Promise(Result(Nil, StreamLifecycleError))

/// The desired size to fill the stream's internal queue. Returns an error
/// if the stream has been closed or errored.
///
@external(javascript, "./writer.ffi.mjs", "desired_size")
pub fn desired_size(writer: Writer(a)) -> Result(Int, Nil)

/// Resolves when the stream is ready to accept more writes
/// (backpressure has cleared). Returns `Errored` if the stream enters
/// an errored state.
///
@external(javascript, "./writer.ffi.mjs", "ready")
pub fn ready(writer: Writer(a)) -> Promise(Result(Nil, StreamLifecycleError))

/// Aborts the stream. Returns `Errored` if the underlying sink's
/// abort callback throws or returns a rejecting promise.
///
@external(javascript, "./writer.ffi.mjs", "abort")
pub fn abort(
  writer: Writer(a),
  reason reason: r,
) -> Promise(Result(Nil, StreamLifecycleError))

/// Closes the stream after all writes complete. Returns `Errored` if
/// the underlying sink's close callback throws or returns a rejecting
/// promise.
///
@external(javascript, "./writer.ffi.mjs", "close")
pub fn close(writer: Writer(a)) -> Promise(Result(Nil, StreamLifecycleError))

/// Releases the writer's lock on the stream. Returns `Released` if
/// the writer is no longer the active writer.
///
@external(javascript, "./writer.ffi.mjs", "release_lock")
pub fn release_lock(writer: Writer(a)) -> Result(Nil, StreamLifecycleError)

/// Writes `chunk` to the stream. Returns `Errored` if the stream
/// enters an errored state, or `Closed` if the stream was already
/// closed when write was called.
///
@external(javascript, "./writer.ffi.mjs", "write")
pub fn write(
  to writer: Writer(a),
  chunk chunk: a,
) -> Promise(Result(Nil, StreamLifecycleError))
