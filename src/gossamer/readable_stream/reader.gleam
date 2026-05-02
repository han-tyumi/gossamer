import gossamer/js_error.{type JsError}
import gossamer/promise.{type Promise}
import gossamer/readable_stream/read_result.{type ReadResult}

/// A locked reader over a `ReadableStream`.
///
/// See [ReadableStreamDefaultReader](https://developer.mozilla.org/en-US/docs/Web/API/ReadableStreamDefaultReader) on MDN.
///
@external(javascript, "./reader.type.ts", "Reader$")
pub type Reader(a)

/// Resolves when the stream closes. Returns an error if the stream errored.
///
@external(javascript, "./reader.ffi.mjs", "closed")
pub fn closed(of reader: Reader(a)) -> Promise(Result(Nil, JsError))

/// Cancels the stream and releases the reader's lock. Returns an error
/// if the underlying cancel fails.
///
@external(javascript, "./reader.ffi.mjs", "cancel")
pub fn cancel(
  reader: Reader(a),
  reason reason: r,
) -> Promise(Result(Nil, JsError))

/// Reads the next chunk from the stream. Returns an error if the stream
/// errored or the reader was released.
///
@external(javascript, "./reader.ffi.mjs", "read")
pub fn read(reader: Reader(a)) -> Promise(Result(ReadResult(a), JsError))

/// Releases the reader's lock on the stream. Returns an error if the
/// reader has outstanding read requests.
///
@external(javascript, "./reader.ffi.mjs", "release_lock")
pub fn release_lock(reader: Reader(a)) -> Result(Reader(a), JsError)
