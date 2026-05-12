import gleam/javascript/promise.{type Promise}
import gossamer/stream.{type StreamLifecycleError}
import gossamer/stream/readable_stream/read_result.{type ReadResult}

/// A locked reader over a `ReadableStream`.
///
/// See [ReadableStreamDefaultReader](https://developer.mozilla.org/en-US/docs/Web/API/ReadableStreamDefaultReader) on MDN.
///
@external(javascript, "./reader.type.ts", "Reader$")
pub type Reader(a)

/// Resolves when the stream closes. Returns `Errored` if the stream
/// enters an errored state; the reason is the variant's payload.
///
@external(javascript, "./reader.ffi.mjs", "closed")
pub fn closed(reader: Reader(a)) -> Promise(Result(Nil, StreamLifecycleError))

/// Cancels the stream and releases the reader's lock. Returns `Errored`
/// if the underlying source's cancel callback throws or rejects.
///
@external(javascript, "./reader.ffi.mjs", "cancel")
pub fn cancel(
  reader: Reader(a),
  reason reason: r,
) -> Promise(Result(Nil, StreamLifecycleError))

/// Reads the next chunk from the stream. Returns `Released` if the
/// reader no longer holds the lock, or `Errored` if the stream enters
/// an errored state.
///
@external(javascript, "./reader.ffi.mjs", "read")
pub fn read(
  reader: Reader(a),
) -> Promise(Result(ReadResult(a), StreamLifecycleError))

/// Releases the reader's lock on the stream. Returns `Released` if the
/// reader is no longer the active reader.
///
@external(javascript, "./reader.ffi.mjs", "release_lock")
pub fn release_lock(
  reader: Reader(a),
) -> Result(Reader(a), StreamLifecycleError)
