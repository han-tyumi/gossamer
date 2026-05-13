//// The controller passed to a `TransformStream`'s transformer
//// callbacks. Use it to emit chunks to the readable side via
//// [`enqueue`](#enqueue), error the stream with [`error`](#error),
//// or end transformation with [`terminate`](#terminate).

import gossamer/stream.{type StreamLifecycleError}

/// A JavaScript `TransformStreamDefaultController` — passed to a
/// `TransformStream`'s transformer callbacks. Used to enqueue output
/// chunks, signal errors, or terminate the stream.
///
/// See [TransformStreamDefaultController](https://developer.mozilla.org/en-US/docs/Web/API/TransformStreamDefaultController) on MDN.
///
@external(javascript, "./default_controller.type.ts", "DefaultController$")
pub type DefaultController(a)

/// The desired size to fill the readable side's internal queue. Returns
/// an error if the stream has been closed or errored.
///
@external(javascript, "./default_controller.ffi.mjs", "desired_size")
pub fn desired_size(controller: DefaultController(a)) -> Result(Int, Nil)

/// Enqueues `chunk` into the readable side's internal queue. Returns
/// `Closed` if the stream is already closed or errored.
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

/// Closes the readable side and errors the writable side of the
/// stream. A no-op if the stream is already closed or terminated.
///
@external(javascript, "./default_controller.ffi.mjs", "terminate")
pub fn terminate(controller: DefaultController(a)) -> Nil
