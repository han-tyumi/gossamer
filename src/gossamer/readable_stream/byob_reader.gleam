// TODO: Untested — requires a byte stream (UnderlyingSource with type: "bytes")
// which gossamer doesn't expose yet. Add tests once byte stream support lands.

import gossamer/array_buffer.{type ArrayBufferView}
import gossamer/promise.{type Promise}
import gossamer/readable_stream/read_result.{type ReadResult}

/// A reader over a byte `ReadableStream` that reads into caller-provided
/// buffers.
///
/// See [ReadableStreamBYOBReader](https://developer.mozilla.org/en-US/docs/Web/API/ReadableStreamBYOBReader) on MDN.
///
@external(javascript, "./byob_reader.type.ts", "ByobReader$")
pub type ByobReader(a)

pub type ByobReaderReadOption {
  Min(Int)
}

/// Resolves when the stream closes. Returns an error if the stream
/// errored.
///
@external(javascript, "./byob_reader.ffi.mjs", "closed")
pub fn closed(of reader: ByobReader(a)) -> Promise(Result(Nil, String))

/// Cancels the stream and releases the reader's lock. Returns an error
/// if the underlying cancel fails.
///
@external(javascript, "./byob_reader.ffi.mjs", "cancel")
pub fn cancel(
  reader: ByobReader(a),
  reason reason: r,
) -> Promise(Result(Nil, String))

/// Reads bytes from the stream into `view`. Returns an error if the
/// stream errored or the reader was released.
///
@external(javascript, "./byob_reader.ffi.mjs", "read")
pub fn read(
  reader: ByobReader(a),
  into view: ArrayBufferView,
  with options: List(ByobReaderReadOption),
) -> Promise(Result(ReadResult(ArrayBufferView), String))

/// Releases the reader's lock on the stream. Returns an error if the
/// reader has outstanding read requests.
///
@external(javascript, "./byob_reader.ffi.mjs", "release_lock")
pub fn release_lock(reader: ByobReader(a)) -> Result(ByobReader(a), String)
