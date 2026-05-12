/// The result of advancing an iterator. `Yield` carries a value produced
/// by the iterator; `Return` signals iteration has ended, carrying any
/// final return value.
///
pub type IteratorResult(a, result) {
  Yield(value: a)
  Return(value: result)
}

/// The outcome of invoking an iterator's optional `return` or `throw`
/// handler. `NoHandler` indicates the iterator doesn't define the
/// handler. `Handled` carries the `IteratorResult` the handler produced.
///
pub type IteratorHandlerOutcome(a, result) {
  NoHandler
  Handled(result: IteratorResult(a, result))
}
