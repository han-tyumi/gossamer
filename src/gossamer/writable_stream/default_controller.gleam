import gossamer/abort_signal.{type AbortSignal}

/// A controller for a `WritableStream`'s underlying sink, passed to the
/// `Start`, `Write`, `Close`, and `Abort` callbacks. Used to signal stream
/// errors and access the abort signal.
///
/// See [WritableStreamDefaultController](https://developer.mozilla.org/en-US/docs/Web/API/WritableStreamDefaultController) on MDN.
///
@external(javascript, "./default_controller.type.ts", "DefaultController$")
pub type DefaultController

@external(javascript, "./default_controller.ffi.mjs", "signal")
pub fn signal(of controller: DefaultController) -> AbortSignal

/// Signals an error on the stream. Returns an error if the stream is
/// already closed or errored.
///
@external(javascript, "./default_controller.ffi.mjs", "error")
pub fn error(
  controller: DefaultController,
  reason reason: a,
) -> Result(Nil, String)
