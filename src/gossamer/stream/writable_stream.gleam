//// The sink side of the Streams API. Build one from an underlying
//// sink via the `Builder` and write into it through a
//// [`Writer`](./writable_stream/writer.html) acquired with
//// [`get_writer`](#get_writer).

import gleam/dynamic.{type Dynamic}
import gleam/javascript/promise.{type Promise}
import gleam/option.{type Option, None, Some}
import gossamer/stream.{type QueuingStrategy, type StreamLifecycleError}
import gossamer/stream/writable_stream/default_controller.{
  type DefaultController,
}
import gossamer/stream/writable_stream/writer.{type Writer}

/// A JavaScript `WritableStream` — a destination for writing bytes or
/// objects.
///
/// See [WritableStream](https://developer.mozilla.org/en-US/docs/Web/API/WritableStream) on MDN.
///
@external(javascript, "./writable_stream.type.ts", "WritableStream$")
pub type WritableStream(a)

/// The configuration for a `WritableStream`. Construct with `new` and
/// refine with `with_start`, `with_write`, `with_close`, `with_abort`, and
/// `with_queuing_strategy`, then call `build` to create the stream.
///
pub opaque type Builder(a) {
  Builder(
    start: Option(fn(DefaultController) -> Nil),
    write: Option(fn(a, DefaultController) -> Promise(Nil)),
    close: Option(fn() -> Promise(Nil)),
    abort: Option(fn(Dynamic) -> Promise(Nil)),
    queuing_strategy: Option(QueuingStrategy),
  )
}

/// Creates a `Builder` with no underlying-sink callbacks set.
///
pub fn new() -> Builder(a) {
  Builder(
    start: None,
    write: None,
    close: None,
    abort: None,
    queuing_strategy: None,
  )
}

/// Registers the `start` callback that runs once at construction. Use to
/// acquire resources or set up state.
///
pub fn with_start(
  builder: Builder(a),
  run callback: fn(DefaultController) -> b,
) -> Builder(a) {
  Builder(
    ..builder,
    start: Some(fn(controller) {
      callback(controller)
      Nil
    }),
  )
}

/// Registers the `write` callback that runs for each chunk written to the
/// sink.
///
pub fn with_write(
  builder: Builder(a),
  run callback: fn(a, DefaultController) -> Promise(Nil),
) -> Builder(a) {
  Builder(..builder, write: Some(callback))
}

/// Registers the `close` callback that runs once after all writes
/// complete.
///
pub fn with_close(
  builder: Builder(a),
  run callback: fn() -> Promise(Nil),
) -> Builder(a) {
  Builder(..builder, close: Some(callback))
}

/// Registers the `abort` callback that runs if the stream is aborted.
/// Receives the abort reason.
///
pub fn with_abort(
  builder: Builder(a),
  run callback: fn(Dynamic) -> Promise(Nil),
) -> Builder(a) {
  Builder(..builder, abort: Some(callback))
}

/// Sets the queuing strategy controlling backpressure on the stream's
/// internal queue. Without this, the stream uses the default strategy
/// (chunk count, high water mark of `1`).
///
pub fn with_queuing_strategy(
  builder: Builder(a),
  strategy: QueuingStrategy,
) -> Builder(a) {
  Builder(..builder, queuing_strategy: Some(strategy))
}

/// Creates a `WritableStream` from the configured `Builder`. Returns
/// `Errored` if the `start` callback throws synchronously; the thrown
/// value is the variant's reason.
///
pub fn build(
  builder: Builder(a),
) -> Result(WritableStream(a), StreamLifecycleError) {
  do_build(
    builder.start,
    builder.write,
    builder.close,
    builder.abort,
    builder.queuing_strategy,
  )
}

@external(javascript, "./writable_stream.ffi.mjs", "build")
@internal
pub fn do_build(
  start: Option(fn(DefaultController) -> Nil),
  write: Option(fn(a, DefaultController) -> Promise(Nil)),
  close: Option(fn() -> Promise(Nil)),
  abort: Option(fn(Dynamic) -> Promise(Nil)),
  queuing_strategy: Option(QueuingStrategy),
) -> Result(WritableStream(a), StreamLifecycleError)

/// Creates a `WritableStream` from only a `write` callback — use when the
/// sink just needs to handle incoming chunks.
///
@external(javascript, "./writable_stream.ffi.mjs", "from_write")
pub fn from_write(
  write: fn(a, DefaultController) -> Promise(Nil),
) -> WritableStream(a)

/// Checks whether the stream is locked to a writer.
///
@external(javascript, "./writable_stream.ffi.mjs", "is_locked")
pub fn is_locked(stream: WritableStream(a)) -> Bool

/// Aborts the stream. Returns `Errored` if the underlying sink's
/// abort callback throws or returns a rejecting promise.
///
@external(javascript, "./writable_stream.ffi.mjs", "abort")
pub fn abort(
  stream: WritableStream(a),
  reason reason: r,
) -> Promise(Result(Nil, StreamLifecycleError))

/// Closes the stream after all writes complete. Returns `Errored` if
/// the underlying sink's close callback throws or returns a rejecting
/// promise.
///
@external(javascript, "./writable_stream.ffi.mjs", "close")
pub fn close(
  stream: WritableStream(a),
) -> Promise(Result(Nil, StreamLifecycleError))

/// Acquires a `Writer` that locks the stream. Returns `Locked` if the
/// stream is already locked.
///
@external(javascript, "./writable_stream.ffi.mjs", "get_writer")
pub fn get_writer(
  stream: WritableStream(a),
) -> Result(Writer(a), StreamLifecycleError)
