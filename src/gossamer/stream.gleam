//// Parent module for the stream family — `ReadableStream`,
//// `WritableStream`, `TransformStream`, and their readers, writers,
//// and controllers. Hosts `StreamLifecycleError`, the shared error
//// type returned by stream operations that fail because of the
//// stream's current state.

import gleam/dynamic.{type Dynamic}

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
}
