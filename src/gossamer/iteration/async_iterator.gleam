//// JavaScript `AsyncIterator` binding for interop with APIs that
//// produce or consume async iterators. Treated as a transit type:
//// pass an async iterator across the FFI boundary and consume from
//// Gleam via [`each`](#each) or [`to_list`](#to_list). The iterator
//// protocol (`next`, `return`, `throw`) is intentionally not exposed
//// publicly — observable mutation lives on the JavaScript side.

import gleam/dynamic.{type Dynamic}
import gleam/javascript/promise.{type Promise}
import gleam/option.{type Option}
import gossamer/iteration.{type IteratorResult}
import gossamer/iteration/async_yielder.{type AsyncYielder}

/// A pull-based iterator that yields values asynchronously. Each call
/// to `next` returns a promise. `a` is the yielded value type,
/// `return` is the final return value, `next` is the type of values
/// passed via `next`.
///
/// See [AsyncIterator](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/AsyncIterator) on MDN.
///
@external(javascript, "./async_iterator.type.ts", "AsyncIterator$")
pub type AsyncIterator(a, return, next)

/// Creates an async iterator from a `next` callback that returns a
/// promise for each next result.
///
@external(javascript, "./async_iterator.ffi.mjs", "new_")
pub fn new(
  next: fn(Option(next)) -> Promise(IteratorResult(a, return)),
) -> AsyncIterator(a, return, next)

/// Creates an async iterator from a Gleam list.
///
@external(javascript, "./async_iterator.ffi.mjs", "from_list")
pub fn from_list(list: List(a)) -> AsyncIterator(a, Nil, Nil)

/// Collects all values from an async iterator into a list. Consumes
/// the iterator. Returns the rejection reason if any `next` call
/// rejects.
///
@external(javascript, "./async_iterator.ffi.mjs", "to_list")
pub fn to_list(
  iterator: AsyncIterator(a, return, next),
) -> Promise(Result(List(a), Dynamic))

/// Creates an async iterator from an
/// [`AsyncYielder`](async_yielder.html#AsyncYielder). The yielder is
/// consumed lazily as values are pulled from the iterator.
///
@external(javascript, "./async_iterator.ffi.mjs", "from_async_yielder")
pub fn from_async_yielder(
  yielder: AsyncYielder(a),
) -> AsyncIterator(a, Nil, Nil)

/// Wraps the iterator as an
/// [`AsyncYielder`](async_yielder.html#AsyncYielder). The iterator is
/// consumed lazily as values are pulled from the yielder; pair with
/// [`async_yielder.to_list`](async_yielder.html#to_list) for eager
/// materialization.
///
@external(javascript, "./async_iterator.ffi.mjs", "to_async_yielder")
pub fn to_async_yielder(
  iterator: AsyncIterator(a, return, next),
) -> AsyncYielder(a)

/// Consumes the iterator, calling `fun` on each yielded value. Returns
/// the thrown value or rejection reason if the iterator or `fun` throws
/// or rejects. Equivalent to JavaScript's `for await...of` loop.
///
@external(javascript, "./async_iterator.ffi.mjs", "each")
pub fn each(
  in iterator: AsyncIterator(a, return, next),
  run fun: fn(a) -> any,
) -> Promise(Result(Nil, Dynamic))
