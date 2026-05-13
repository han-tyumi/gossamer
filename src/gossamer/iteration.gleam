//// Shared types used by both [`iterator`](./iteration/iterator.html)
//// and [`async_iterator`](./iteration/async_iterator.html) — the
//// per-step result variants returned from a `next` callback.

/// The result of advancing an iterator. `Yield` carries a value produced
/// by the iterator; `Return` signals iteration has ended, carrying any
/// final return value.
///
pub type IteratorResult(a, result) {
  Yield(value: a)
  Return(value: result)
}
