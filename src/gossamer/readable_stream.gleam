import gleam/dynamic.{type Dynamic}
import gossamer/abort_signal.{type AbortSignal}
import gossamer/async_iterator.{type AsyncIterator}
import gossamer/iterator.{type Iterator}
import gossamer/js_error.{type JsError}
import gossamer/promise.{type Promise}
import gossamer/readable_stream/byob_reader.{type ByobReader}
import gossamer/readable_stream/default_controller.{type DefaultController}
import gossamer/readable_stream/reader.{type Reader}
import gossamer/writable_stream.{type WritableStream}

/// A pull-based stream of bytes or objects, used as a source for data.
///
/// See [ReadableStream](https://developer.mozilla.org/en-US/docs/Web/API/ReadableStream) on MDN.
///
@external(javascript, "./readable_stream.type.ts", "ReadableStream$")
pub type ReadableStream(a)

pub type UnderlyingSource(a) {
  Start(fn(DefaultController(a)) -> Nil)
  Pull(fn(DefaultController(a)) -> Promise(Nil))
  Cancel(fn(Dynamic) -> Promise(Nil))
}

pub type StreamPipeOption {
  PreventAbort
  PreventCancel
  PreventClose
  Signal(AbortSignal)
}

/// Creates a `ReadableStream` driven by the given underlying-source
/// callbacks (`Start`, `Pull`, `Cancel`). Returns an error if the `Start`
/// callback throws synchronously.
///
@external(javascript, "./readable_stream.ffi.mjs", "new_")
pub fn new(
  source: List(UnderlyingSource(a)),
) -> Result(ReadableStream(a), JsError)

/// Creates a `ReadableStream` from only a `Start` callback — use when all
/// chunks can be enqueued up front. Returns an error if `start` throws
/// synchronously.
///
pub fn from_start(
  start: fn(DefaultController(a)) -> Nil,
) -> Result(ReadableStream(a), JsError) {
  new([Start(start)])
}

/// Creates a `ReadableStream` from only a `Pull` callback — use when chunks
/// are produced on demand. Returns an error if `pull` throws synchronously
/// at construction.
///
pub fn from_pull(
  pull: fn(DefaultController(a)) -> Promise(Nil),
) -> Result(ReadableStream(a), JsError) {
  new([Pull(pull)])
}

/// Creates a `ReadableStream` from an `Iterator`.
///
/// Note: Not available on Bun.
/// See https://github.com/oven-sh/bun/issues/3700
///
@external(javascript, "./readable_stream.ffi.mjs", "from_iterator")
pub fn from_iterator(iterator: Iterator(a, r, n)) -> ReadableStream(a)

/// Creates a `ReadableStream` from an `AsyncIterator`.
///
/// Note: Not available on Bun.
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

/// Signals consumer disinterest in the stream. Returns an error if the
/// underlying source's cancel callback throws or returns a rejecting
/// promise.
///
@external(javascript, "./readable_stream.ffi.mjs", "cancel")
pub fn cancel(
  stream: ReadableStream(a),
  reason reason: r,
) -> Promise(Result(Nil, JsError))

/// Acquires a `Reader` that locks the stream. Returns an error if the
/// stream is already locked.
///
@external(javascript, "./readable_stream.ffi.mjs", "get_reader")
pub fn get_reader(stream: ReadableStream(a)) -> Result(Reader(a), JsError)

/// Acquires a `ByobReader` for bring-your-own-buffer reads. Returns an
/// error if the stream is already locked or is not a byte stream.
///
@external(javascript, "./readable_stream.ffi.mjs", "get_byob_reader")
pub fn get_byob_reader(
  stream: ReadableStream(a),
) -> Result(ByobReader(a), JsError)

/// Pipes the stream through a transform (a writable+readable pair),
/// returning the readable side. Returns an error if this stream or the
/// writable side is already locked.
///
@external(javascript, "./readable_stream.ffi.mjs", "pipe_through")
pub fn pipe_through(
  stream: ReadableStream(a),
  transform: #(ReadableStream(b), WritableStream(a)),
  with options: List(StreamPipeOption),
) -> Result(ReadableStream(b), JsError)

/// Pipes the stream to a `WritableStream`. Returns an error if piping
/// fails (stream errored, destination errored, or either side already
/// locked).
///
@external(javascript, "./readable_stream.ffi.mjs", "pipe_to")
pub fn pipe_to(
  stream: ReadableStream(a),
  destination: WritableStream(a),
  with options: List(StreamPipeOption),
) -> Promise(Result(Nil, JsError))

/// Splits the stream into two independent streams reading the same data.
/// Returns an error if the stream is already locked.
///
@external(javascript, "./readable_stream.ffi.mjs", "tee")
pub fn tee(
  stream: ReadableStream(a),
) -> Result(#(ReadableStream(a), ReadableStream(a)), JsError)

/// Returns an `AsyncIterator` that reads from the stream. The iterator
/// locks the stream until reading completes.
///
@external(javascript, "./readable_stream.ffi.mjs", "async_iterator")
pub fn async_iterator(
  of stream: ReadableStream(a),
) -> AsyncIterator(a, Nil, Nil)
