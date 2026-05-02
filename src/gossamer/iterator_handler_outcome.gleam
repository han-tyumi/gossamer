import gossamer/iterator_result.{type IteratorResult}

/// The outcome of invoking an iterator's optional `return` or `throw`
/// handler. `NoHandler` indicates the iterator doesn't define the
/// handler. `Handled` carries the `IteratorResult` the handler produced.
///
pub type IteratorHandlerOutcome(a, result) {
  NoHandler
  Handled(result: IteratorResult(a, result))
}
