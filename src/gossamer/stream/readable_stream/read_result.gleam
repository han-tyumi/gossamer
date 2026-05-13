//// The outcome of pulling the next chunk from a `ReadableStream`
//// reader.

import gleam/option.{type Option}

/// The result of a read from a `ReadableStream` reader.
///
pub type ReadResult(a) {
  /// A chunk produced by the stream.
  Value(a)

  /// The stream has ended. The payload carries an optional final
  /// value, present when the source returned one on `close`.
  Done(Option(a))
}
