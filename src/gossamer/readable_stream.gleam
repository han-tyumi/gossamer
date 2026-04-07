import gossamer/async_iterator.{type AsyncIterator}
import gossamer/promise.{type Promise}
import gossamer/readable_stream/byob_reader.{type ByobReader}
import gossamer/readable_stream/default_controller.{type DefaultController}
import gossamer/readable_stream/reader.{type Reader}
import gossamer/readable_stream/stream_pipe_option.{type StreamPipeOption}
import gossamer/readable_stream/underlying_source.{type UnderlyingSource}
import gossamer/writable_stream.{type WritableStream}

@external(javascript, "./readable_stream.ffi.ts", "ReadableStream$")
pub type ReadableStream(a)

@external(javascript, "./readable_stream.ffi.mjs", "new_")
pub fn new(source: List(UnderlyingSource(a))) -> ReadableStream(a)

/// Creates a ReadableStream that pushes data from a start callback.
///
pub fn from_start(start: fn(DefaultController(a)) -> Nil) -> ReadableStream(a) {
  new([underlying_source.Start(start)])
}

/// Creates a ReadableStream that produces data on demand via a pull callback.
///
pub fn from_pull(
  pull: fn(DefaultController(a)) -> Promise(Nil),
) -> ReadableStream(a) {
  new([underlying_source.Pull(pull)])
}

/// Creates a ReadableStream from an async or sync iterable.
///
@external(javascript, "./readable_stream.ffi.mjs", "from")
pub fn from(iterable: a) -> ReadableStream(b)

@external(javascript, "./readable_stream.ffi.mjs", "locked")
pub fn locked(stream: ReadableStream(a)) -> Bool

@external(javascript, "./readable_stream.ffi.mjs", "cancel")
pub fn cancel(stream: ReadableStream(a), reason: r) -> Promise(Nil)

@external(javascript, "./readable_stream.ffi.mjs", "get_reader")
pub fn get_reader(stream: ReadableStream(a)) -> Reader(a)

@external(javascript, "./readable_stream.ffi.mjs", "get_byob_reader")
pub fn get_byob_reader(stream: ReadableStream(a)) -> ByobReader(a)

@external(javascript, "./readable_stream.ffi.mjs", "pipe_through")
pub fn pipe_through(
  stream: ReadableStream(a),
  transform: #(ReadableStream(b), WritableStream(a)),
  options: List(StreamPipeOption),
) -> ReadableStream(b)

@external(javascript, "./readable_stream.ffi.mjs", "pipe_to")
pub fn pipe_to(
  stream: ReadableStream(a),
  destination: WritableStream(a),
  options: List(StreamPipeOption),
) -> Promise(Nil)

@external(javascript, "./readable_stream.ffi.mjs", "tee")
pub fn tee(stream: ReadableStream(a)) -> #(ReadableStream(a), ReadableStream(a))

@external(javascript, "./readable_stream.ffi.mjs", "async_iterator")
pub fn async_iterator(stream: ReadableStream(a)) -> AsyncIterator(a, Nil, Nil)
