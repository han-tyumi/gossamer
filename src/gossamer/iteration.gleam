import gleam/dynamic.{type Dynamic}

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

/// Errors raised by iterator and async-iterator operations.
pub type IteratorError {
  /// A callback supplied to the iterator (the `next` function passed to
  /// `new`, a handler attached via `with_return` or `with_throw`, or a
  /// per-call callback like `for_await`'s body) threw synchronously or
  /// returned a rejecting promise. The `reason` payload carries the
  /// thrown value as a `Dynamic`.
  ///
  CallbackThrew(reason: Dynamic)
}
