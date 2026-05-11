import gossamer/js_error.{type JsError}

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
pub fn desired_size(of controller: DefaultController(a)) -> Result(Int, Nil)

/// Closes the stream. Returns an error if the stream is already closed or
/// errored.
///
@external(javascript, "./default_controller.ffi.mjs", "close")
pub fn close(controller: DefaultController(a)) -> Result(Nil, JsError)

/// Enqueues `chunk` into the stream's internal queue. Returns an error if
/// the stream is closed or errored.
///
@external(javascript, "./default_controller.ffi.mjs", "enqueue")
pub fn enqueue(
  in controller: DefaultController(a),
  chunk chunk: a,
) -> Result(Nil, JsError)

/// Signals an error on the stream. Returns an error if the stream is
/// already closed or errored.
///
@external(javascript, "./default_controller.ffi.mjs", "error")
pub fn error(
  controller: DefaultController(a),
  reason reason: b,
) -> Result(Nil, JsError)
