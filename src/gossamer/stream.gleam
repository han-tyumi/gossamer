//// Parent module for the stream family — `ReadableStream`,
//// `WritableStream`, `TransformStream`, and their readers, writers,
//// and controllers. Hosts `StreamLifecycleError`, the shared error
//// type returned by stream operations that fail because of the
//// stream's current state, and `QueuingStrategy`, the shared
//// backpressure-tuning enum applied via stream builders.

import gleam/dynamic.{type Dynamic}

/// The backpressure threshold applied to a stream's internal queue.
///
pub type QueuingStrategy {
  /// Backpressure measured by chunk count — the queue holds at most
  /// `high_water_mark` chunks before signaling pressure.
  ByCount(high_water_mark: Int)

  /// Backpressure measured by byte size — the queue holds at most
  /// `high_water_mark` total bytes across all chunks before signaling
  /// pressure.
  ByByteLength(high_water_mark: Int)

  /// Disables backpressure signaling entirely. The stream accepts
  /// chunks as fast as they arrive.
  Unlimited
}

/// Errors raised by stream lifecycle operations.
pub type StreamLifecycleError {
  /// The stream is locked to a reader or writer. Acquiring another
  /// lock or piping a locked stream is not allowed.
  Locked

  /// The reader or writer no longer holds the lock on its stream.
  /// Operations on a released reader/writer reject.
  Released

  /// The stream or controller is closed. Enqueueing into or closing a
  /// closed controller is not allowed.
  Closed

  /// The stream is in an errored state. `reason` is the value the
  /// stream was errored with, either by the underlying source's
  /// callback throwing or by the consumer explicitly erroring the
  /// controller.
  Errored(reason: Dynamic)

  /// A `pipe_to` operation was aborted via the `AbortSignal` set on
  /// its `PipeOptions`. The `reason` payload carries whatever value
  /// was passed to `abort(reason)` — or an `AbortError` `DOMException`
  /// if `abort()` was called with no argument.
  Aborted(reason: Dynamic)
}
