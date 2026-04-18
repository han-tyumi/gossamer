import gleam/dynamic.{type Dynamic}
import gossamer/abort_signal.{type AbortSignal}
import gossamer/async_iterator.{type AsyncIterator}
import gossamer/promise.{type Promise}
import gossamer/readable_stream/byob_reader.{type ByobReader}
import gossamer/readable_stream/default_controller.{type DefaultController}
import gossamer/readable_stream/reader.{type Reader}
import gossamer/writable_stream.{type WritableStream}

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

@external(javascript, "./readable_stream.ffi.mjs", "new_")
pub fn new(source: List(UnderlyingSource(a))) -> ReadableStream(a)

pub fn from_start(start: fn(DefaultController(a)) -> Nil) -> ReadableStream(a) {
  new([Start(start)])
}

pub fn from_pull(
  pull: fn(DefaultController(a)) -> Promise(Nil),
) -> ReadableStream(a) {
  new([Pull(pull)])
}

/// Creates a `ReadableStream` from an iterable or async iterable.
///
/// Note: Not available on Bun.
/// See https://github.com/oven-sh/bun/issues/3700
///
@external(javascript, "./readable_stream.ffi.mjs", "from")
pub fn from(iterable: a) -> Result(ReadableStream(b), String)

@external(javascript, "./readable_stream.ffi.mjs", "is_locked")
pub fn is_locked(stream: ReadableStream(a)) -> Bool

@external(javascript, "./readable_stream.ffi.mjs", "cancel")
pub fn cancel(
  stream: ReadableStream(a),
  reason reason: r,
) -> Promise(Result(Nil, String))

@external(javascript, "./readable_stream.ffi.mjs", "get_reader")
pub fn get_reader(stream: ReadableStream(a)) -> Result(Reader(a), String)

@external(javascript, "./readable_stream.ffi.mjs", "get_byob_reader")
pub fn get_byob_reader(
  stream: ReadableStream(a),
) -> Result(ByobReader(a), String)

@external(javascript, "./readable_stream.ffi.mjs", "pipe_through")
pub fn pipe_through(
  stream: ReadableStream(a),
  transform: #(ReadableStream(b), WritableStream(a)),
  with options: List(StreamPipeOption),
) -> Result(ReadableStream(b), String)

@external(javascript, "./readable_stream.ffi.mjs", "pipe_to")
pub fn pipe_to(
  stream: ReadableStream(a),
  destination: WritableStream(a),
  with options: List(StreamPipeOption),
) -> Promise(Result(Nil, String))

@external(javascript, "./readable_stream.ffi.mjs", "tee")
pub fn tee(
  stream: ReadableStream(a),
) -> Result(#(ReadableStream(a), ReadableStream(a)), String)

@external(javascript, "./readable_stream.ffi.mjs", "async_iterator")
pub fn async_iterator(
  of stream: ReadableStream(a),
) -> AsyncIterator(a, Nil, Nil)
