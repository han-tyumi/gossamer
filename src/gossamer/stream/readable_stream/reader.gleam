//// The pull-side cursor over a `ReadableStream`. Acquire one with
//// [`gossamer/stream/readable_stream.get_reader`](../readable_stream.html#get_reader)
//// then call [`read`](#read) to pull chunks. Release the lock via
//// [`release_lock`](#release_lock) when done.

import gleam/javascript/promise.{type Promise}
import gleam/option.{type Option}
import gossamer/stream.{type StreamLifecycleError}

/// A JavaScript `ReadableStreamDefaultReader` — a locked reader over a
/// `ReadableStream`.
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

/// Reads the next chunk: `Some(chunk)` while data remains, `None` once
/// the stream is exhausted. Returns `Errored` if the stream enters an
/// errored state, or if the reader no longer holds the lock; the reason
/// payload distinguishes the two.
///
@external(javascript, "./reader.ffi.mjs", "read")
pub fn read(
  reader: Reader(a),
) -> Promise(Result(Option(a), StreamLifecycleError))

/// Releases the reader's lock on the stream. Pending reads reject
/// asynchronously after release.
///
@external(javascript, "./reader.ffi.mjs", "release_lock")
pub fn release_lock(reader: Reader(a)) -> Nil
