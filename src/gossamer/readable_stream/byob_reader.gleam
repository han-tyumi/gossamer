// TODO: Untested — requires a byte stream (UnderlyingSource with type: "bytes")
// which gossamer doesn't expose yet. Add tests once byte stream support lands.

import gossamer/js_error.{type JsError}
import gossamer/promise.{type Promise}
import gossamer/readable_stream/read_result.{type ReadResult}
import gossamer/uint8_array.{type Uint8Array}

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
pub fn closed(of reader: ByobReader(a)) -> Promise(Result(Nil, JsError))

/// Cancels the stream and releases the reader's lock. Returns an error
/// if the underlying cancel fails.
///
@external(javascript, "./byob_reader.ffi.mjs", "cancel")
pub fn cancel(
  reader: ByobReader(a),
  reason reason: r,
) -> Promise(Result(Nil, JsError))

/// Reads bytes from the stream into `view`. The returned chunk is a new
/// `Uint8Array` over the same underlying buffer, since the original `view`
/// is detached during the read. Returns an error if the stream errored or
/// the reader was released.
///
@external(javascript, "./byob_reader.ffi.mjs", "read")
pub fn read(
  reader: ByobReader(a),
  into view: Uint8Array,
  with options: List(ByobReaderReadOption),
) -> Promise(Result(ReadResult(Uint8Array), JsError))

/// Releases the reader's lock on the stream. Returns an error if the
/// reader has outstanding read requests.
///
@external(javascript, "./byob_reader.ffi.mjs", "release_lock")
pub fn release_lock(reader: ByobReader(a)) -> Result(ByobReader(a), JsError)
