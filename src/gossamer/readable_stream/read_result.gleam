import gleam/option.{type Option}

/// The result of a read from a `ReadableStream` reader. `Value` carries a
/// chunk; `Done` signals the stream has ended, optionally with a final
/// value.
///
pub type ReadResult(a) {
  Value(a)
  Done(Option(a))
}
