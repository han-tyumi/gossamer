//// The source side of the Streams API. Build one from a pull-based
//// source via the `Builder`, or bridge from a Gleam `Yielder` /
//// `AsyncIterator`. Reads happen through a [`Reader`](./readable_stream/reader.html)
//// acquired with [`get_reader`](#get_reader).

import gleam/dynamic.{type Dynamic}
import gleam/javascript/promise.{type Promise}
import gleam/option.{type Option, None, Some}
import gleam/yielder.{type Yielder}
import gossamer/abort_signal.{type AbortSignal}
import gossamer/iteration/async_iterator.{type AsyncIterator}
import gossamer/stream.{type QueuingStrategy, type StreamLifecycleError}
import gossamer/stream/readable_stream/default_controller.{
  type DefaultController,
}
import gossamer/stream/readable_stream/reader.{type Reader}
import gossamer/stream/writable_stream.{type WritableStream}

/// A JavaScript `ReadableStream` — a pull-based stream of bytes or
/// objects used as a source for data.
///
/// See [ReadableStream](https://developer.mozilla.org/en-US/docs/Web/API/ReadableStream) on MDN.
///
@external(javascript, "./readable_stream.type.ts", "ReadableStream$")
pub type ReadableStream(a)

/// The configuration for a `ReadableStream`. Construct with `new` and
/// refine with `with_start`, `with_pull`, `with_cancel`, and
/// `with_queuing_strategy`, then call `build` to create the stream.
///
pub opaque type Builder(a) {
  Builder(
    start: Option(fn(DefaultController(a)) -> Nil),
    pull: Option(fn(DefaultController(a)) -> Promise(Nil)),
    cancel: Option(fn(Dynamic) -> Promise(Nil)),
    queuing_strategy: Option(QueuingStrategy),
  )
}

/// Per-call options for `pipe_through` and `pipe_to`. Construct with
/// `pipe_options` and chain setters.
///
pub type PipeOptions {
  PipeOptions(
    prevent_abort: Bool,
    prevent_cancel: Bool,
    prevent_close: Bool,
    signal: Option(AbortSignal),
  )
}

/// A `PipeOptions` with every flag at its default. The three prevent
/// flags default to `False`; no abort signal is attached.
///
pub fn pipe_options() -> PipeOptions {
  PipeOptions(
    prevent_abort: False,
    prevent_cancel: False,
    prevent_close: False,
    signal: None,
  )
}

/// Sets whether errors in the destination should propagate back to
/// abort the source.
///
pub fn set_prevent_abort(opts: PipeOptions, value: Bool) -> PipeOptions {
  PipeOptions(..opts, prevent_abort: value)
}

/// Sets whether errors in the source should propagate forward to
/// cancel the destination.
///
pub fn set_prevent_cancel(opts: PipeOptions, value: Bool) -> PipeOptions {
  PipeOptions(..opts, prevent_cancel: value)
}

/// Sets whether closing the source should also close the destination.
///
pub fn set_prevent_close(opts: PipeOptions, value: Bool) -> PipeOptions {
  PipeOptions(..opts, prevent_close: value)
}

/// Sets an abort signal that, when triggered, aborts the pipe.
///
pub fn set_signal(opts: PipeOptions, value: AbortSignal) -> PipeOptions {
  PipeOptions(..opts, signal: Some(value))
}

/// Creates a `Builder` with no underlying-source callbacks set.
///
pub fn new() -> Builder(a) {
  Builder(start: None, pull: None, cancel: None, queuing_strategy: None)
}

/// Registers the `start` callback that runs once at construction. Use to
/// enqueue initial chunks or set up state.
///
pub fn with_start(
  builder: Builder(a),
  run callback: fn(DefaultController(a)) -> Nil,
) -> Builder(a) {
  Builder(..builder, start: Some(callback))
}

/// Registers the `pull` callback that runs whenever the consumer requests
/// more chunks.
///
pub fn with_pull(
  builder: Builder(a),
  run callback: fn(DefaultController(a)) -> Promise(Nil),
) -> Builder(a) {
  Builder(..builder, pull: Some(callback))
}

/// Registers the `cancel` callback that runs when the consumer aborts.
/// Receives the cancellation reason.
///
pub fn with_cancel(
  builder: Builder(a),
  run callback: fn(Dynamic) -> Promise(Nil),
) -> Builder(a) {
  Builder(..builder, cancel: Some(callback))
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

/// Creates a `ReadableStream` from the configured `Builder`. Returns
/// `Errored` if the `start` callback throws synchronously; the
/// thrown value is the variant's reason.
///
pub fn build(
  builder: Builder(a),
) -> Result(ReadableStream(a), StreamLifecycleError) {
  do_build(
    builder.start,
    builder.pull,
    builder.cancel,
    builder.queuing_strategy,
  )
}

@external(javascript, "./readable_stream.ffi.mjs", "build")
@internal
pub fn do_build(
  start: Option(fn(DefaultController(a)) -> Nil),
  pull: Option(fn(DefaultController(a)) -> Promise(Nil)),
  cancel: Option(fn(Dynamic) -> Promise(Nil)),
  queuing_strategy: Option(QueuingStrategy),
) -> Result(ReadableStream(a), StreamLifecycleError)

/// Creates a `ReadableStream` from only a `start` callback — use when all
/// chunks can be enqueued up front. Returns `Errored` if `start` throws
/// synchronously.
///
pub fn from_start(
  start: fn(DefaultController(a)) -> Nil,
) -> Result(ReadableStream(a), StreamLifecycleError) {
  new() |> with_start(run: start) |> build
}

/// Creates a `ReadableStream` from only a `pull` callback — use when chunks
/// are produced on demand.
///
@external(javascript, "./readable_stream.ffi.mjs", "from_pull")
pub fn from_pull(
  pull: fn(DefaultController(a)) -> Promise(Nil),
) -> ReadableStream(a)

/// Creates a `ReadableStream` from a `Yielder`. Values are pulled from
/// the yielder as the stream is read. Panics on Bun — see
/// https://github.com/oven-sh/bun/issues/3700.
///
@external(javascript, "./readable_stream.ffi.mjs", "from_yielder")
pub fn from_yielder(yielder: Yielder(a)) -> ReadableStream(a)

/// Creates a `ReadableStream` from an `AsyncIterator`. Panics on Bun —
/// see https://github.com/oven-sh/bun/issues/3700.
///
@external(javascript, "./readable_stream.ffi.mjs", "from_async_iterator")
pub fn from_async_iterator(
  iterator: AsyncIterator(a, r, n),
) -> ReadableStream(a)

/// Checks whether the stream is locked to a reader.
///
@external(javascript, "./readable_stream.ffi.mjs", "is_locked")
pub fn is_locked(stream: ReadableStream(a)) -> Bool

/// Signals consumer disinterest in the stream. Returns `Errored` if
/// the underlying source's cancel callback throws or returns a
/// rejecting promise; the thrown or rejection value is the reason.
///
@external(javascript, "./readable_stream.ffi.mjs", "cancel")
pub fn cancel(
  stream: ReadableStream(a),
  reason reason: r,
) -> Promise(Result(Nil, StreamLifecycleError))

/// Acquires a `Reader` that locks the stream. Returns `Locked` if the
/// stream is already locked.
///
@external(javascript, "./readable_stream.ffi.mjs", "get_reader")
pub fn get_reader(
  stream: ReadableStream(a),
) -> Result(Reader(a), StreamLifecycleError)

/// Pipes the stream through a transform (a writable+readable pair),
/// returning the readable side. Returns `Locked` if this stream or
/// the writable side of the transform is already locked.
///
@external(javascript, "./readable_stream.ffi.mjs", "pipe_through")
pub fn pipe_through(
  stream: ReadableStream(a),
  transform: #(ReadableStream(b), WritableStream(a)),
  with options: PipeOptions,
) -> Result(ReadableStream(b), StreamLifecycleError)

/// Pipes the stream to a `WritableStream`. Returns `Locked` if either
/// side is already locked, `Aborted(reason)` if the pipe is cancelled
/// via the `AbortSignal` on `options`, or `Errored(reason)` if either
/// side enters an errored state during the pipe.
///
@external(javascript, "./readable_stream.ffi.mjs", "pipe_to")
pub fn pipe_to(
  stream: ReadableStream(a),
  destination: WritableStream(a),
  with options: PipeOptions,
) -> Promise(Result(Nil, StreamLifecycleError))

/// Splits the stream into two independent streams reading the same
/// data. Returns `Locked` if the stream is already locked.
///
@external(javascript, "./readable_stream.ffi.mjs", "tee")
pub fn tee(
  stream: ReadableStream(a),
) -> Result(#(ReadableStream(a), ReadableStream(a)), StreamLifecycleError)

/// Returns an `AsyncIterator` that reads from the stream. The iterator
/// locks the stream until reading completes.
///
@external(javascript, "./readable_stream.ffi.mjs", "async_iterator")
pub fn async_iterator(stream: ReadableStream(a)) -> AsyncIterator(a, Nil, Nil)

/// Consumes a byte stream and decodes the assembled bytes as UTF-8.
/// Invalid bytes are replaced with U+FFFD. Returns `Locked` if the
/// stream is already locked, or `Errored` if the stream enters an
/// errored state during read.
///
@external(javascript, "./readable_stream.ffi.mjs", "read_text")
pub fn read_text(
  stream: ReadableStream(BitArray),
) -> Promise(Result(String, StreamLifecycleError))

/// Consumes a byte stream and returns the assembled bytes as a single
/// `BitArray`. Returns `Locked` if the stream is already locked, or
/// `Errored` if the stream enters an errored state during read.
///
@external(javascript, "./readable_stream.ffi.mjs", "read_bytes")
pub fn read_bytes(
  stream: ReadableStream(BitArray),
) -> Promise(Result(BitArray, StreamLifecycleError))
