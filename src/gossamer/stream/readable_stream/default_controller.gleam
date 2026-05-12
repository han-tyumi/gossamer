import gossamer/stream.{type StreamLifecycleError}

/// A controller for a `ReadableStream`'s default source, passed to the
/// `Start` and `Pull` callbacks. Used to enqueue chunks, close the stream,
/// or signal an error.
///
/// See [ReadableStreamDefaultController](https://developer.mozilla.org/en-US/docs/Web/API/ReadableStreamDefaultController) on MDN.
///
@external(javascript, "./default_controller.type.ts", "DefaultController$")
pub type DefaultController(a)

/// The desired size to fill the stream's internal queue. Returns an error
/// if the stream has been closed or errored.
///
@external(javascript, "./default_controller.ffi.mjs", "desired_size")
pub fn desired_size(controller: DefaultController(a)) -> Result(Int, Nil)

/// Closes the stream. Returns `Closed` if the stream is already closed.
///
@external(javascript, "./default_controller.ffi.mjs", "close")
pub fn close(
  controller: DefaultController(a),
) -> Result(Nil, StreamLifecycleError)

/// Enqueues `chunk` into the stream's internal queue. Returns `Closed`
/// if the stream is already closed.
///
@external(javascript, "./default_controller.ffi.mjs", "enqueue")
pub fn enqueue(
  in controller: DefaultController(a),
  chunk chunk: a,
) -> Result(Nil, StreamLifecycleError)

/// Signals an error on the stream. A no-op if the stream is already
/// closed or errored.
///
@external(javascript, "./default_controller.ffi.mjs", "error")
pub fn error(controller: DefaultController(a), reason reason: b) -> Nil
