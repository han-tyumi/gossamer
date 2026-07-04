//// The controller passed to `WritableStream` sink callbacks. Use it to
//// signal an error mid-stream via [`error`](#error) or to observe the
//// stream's abort signal via [`signal`](#signal). See
//// [`gossamer/stream/writable_stream`](../writable_stream.html) for
//// constructing the stream.

import gossamer/abort_signal.{type AbortSignal}

/// A controller for a `WritableStream`'s underlying sink, passed to the
/// `start` and `write` callbacks. Used to signal stream errors and access
/// the abort signal.
///
/// See [WritableStreamDefaultController](https://developer.mozilla.org/en-US/docs/Web/API/WritableStreamDefaultController) on MDN.
///
@external(javascript, "./default_controller.type.ts", "DefaultController$")
pub type DefaultController

/// An `AbortSignal` that fires when the sink should abort its work
/// (e.g., the consumer called `writer.abort` or `writable_stream.abort`).
///
@external(javascript, "./default_controller.ffi.mjs", "signal")
pub fn signal(controller: DefaultController) -> AbortSignal

/// Signals an error on the stream. A no-op if the stream is already
/// closed or errored.
///
@external(javascript, "./default_controller.ffi.mjs", "error")
pub fn error(controller: DefaultController, reason reason: a) -> Nil
