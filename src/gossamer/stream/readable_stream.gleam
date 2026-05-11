import gleam/dynamic.{type Dynamic}
import gleam/javascript/promise.{type Promise}
import gleam/option.{type Option, None, Some}
import gossamer/abort_signal.{type AbortSignal}
import gossamer/async_iterator.{type AsyncIterator}
import gossamer/iterator.{type Iterator}
import gossamer/stream.{type StreamLifecycleError}
import gossamer/stream/readable_stream/default_controller.{
  type DefaultController,
}
import gossamer/stream/readable_stream/reader.{type Reader}
import gossamer/stream/writable_stream.{type WritableStream}

/// A pull-based stream of bytes or objects, used as a source for data.
///
/// See [ReadableStream](https://developer.mozilla.org/en-US/docs/Web/API/ReadableStream) on MDN.
///
@external(javascript, "./readable_stream.type.ts", "ReadableStream$")
pub type ReadableStream(a)

/// The configuration for a `ReadableStream`. Construct with `new` and
/// refine with `on_start`, `on_pull`, and `on_cancel`, then call `build`
/// to create the stream.
///
pub type Builder(a) {
  Builder(
    start: Option(fn(DefaultController(a)) -> Nil),
    pull: Option(fn(DefaultController(a)) -> Promise(Nil)),
    cancel: Option(fn(Dynamic) -> Promise(Nil)),
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
  Builder(start: None, pull: None, cancel: None)
}

/// Registers the `start` callback that runs once at construction. Use to
/// enqueue initial chunks or set up state.
///
pub fn on_start(
  builder: Builder(a),
  run callback: fn(DefaultController(a)) -> b,
) -> Builder(a) {
  Builder(
    ..builder,
    start: Some(fn(controller) {
      callback(controller)
      Nil
    }),
  )
}

/// Registers the `pull` callback that runs whenever the consumer requests
/// more chunks.
///
pub fn on_pull(
  builder: Builder(a),
  run callback: fn(DefaultController(a)) -> Promise(Nil),
) -> Builder(a) {
  Builder(..builder, pull: Some(callback))
}

/// Registers the `cancel` callback that runs when the consumer aborts.
/// Receives the cancellation reason.
///
pub fn on_cancel(
  builder: Builder(a),
  run callback: fn(Dynamic) -> Promise(Nil),
) -> Builder(a) {
  Builder(..builder, cancel: Some(callback))
}

/// Creates a `ReadableStream` from the configured `Builder`. Returns
/// `Errored` if the `start` callback throws synchronously; the
/// thrown value is the variant's reason.
///
@external(javascript, "./readable_stream.ffi.mjs", "build")
pub fn build(
  builder: Builder(a),
) -> Result(ReadableStream(a), StreamLifecycleError)

/// Creates a `ReadableStream` from only a `start` callback — use when all
/// chunks can be enqueued up front. Returns `Errored` if `start` throws
/// synchronously.
///
pub fn from_start(
  start: fn(DefaultController(a)) -> Nil,
) -> Result(ReadableStream(a), StreamLifecycleError) {
  new() |> on_start(run: start) |> build
}

/// Creates a `ReadableStream` from only a `pull` callback — use when chunks
/// are produced on demand.
///
@external(javascript, "./readable_stream.ffi.mjs", "from_pull")
pub fn from_pull(
  pull: fn(DefaultController(a)) -> Promise(Nil),
) -> ReadableStream(a)

/// Creates a `ReadableStream` from an `Iterator`.
///
/// Note: Panics on Bun — `ReadableStream.from` is not implemented.
/// See https://github.com/oven-sh/bun/issues/3700
///
@external(javascript, "./readable_stream.ffi.mjs", "from_iterator")
pub fn from_iterator(iterator: Iterator(a, r, n)) -> ReadableStream(a)

/// Creates a `ReadableStream` from an `AsyncIterator`.
///
/// Note: Panics on Bun — `ReadableStream.from` is not implemented.
/// See https://github.com/oven-sh/bun/issues/3700
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
/// side is already locked, or `Errored` if either side enters an
/// errored state during the pipe.
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
