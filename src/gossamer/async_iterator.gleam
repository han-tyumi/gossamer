//// JavaScript `AsyncIterator` binding for interop with APIs that
//// produce or consume async iterators. Treated as a transit type:
//// pass an async iterator across the FFI boundary and bridge to
//// `AsyncYielder` for Gleam-side iteration via
//// [`to_async_yielder`](#to_async_yielder).
////
//// The iterator protocol (`next`, `return`, `throw`) is intentionally
//// not exposed publicly — observable mutation lives on the JavaScript
//// side. Build async iterators on the Gleam side by composing an
//// `AsyncYielder` and bridging via
//// [`from_async_yielder`](#from_async_yielder).
////
//// Rejections from the underlying iterator's `next()` propagate as
//// promise rejections; use [`promise.rescue`](https://hexdocs.pm/gleam_javascript/gleam/javascript/promise.html#rescue)
//// at the call site if you need to handle them.

import gleam/javascript/promise.{type Promise}
import gossamer/async_yielder.{type AsyncYielder}

/// A pull-based iterator that yields values asynchronously. Each call
/// to `next` returns a promise.
///
/// See [AsyncIterator](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/AsyncIterator) on MDN.
///
@external(javascript, "./async_iterator.type.ts", "AsyncIterator$")
pub type AsyncIterator(a)

/// Creates an async iterator from an
/// [`AsyncYielder`](async_yielder.html#AsyncYielder). The yielder is
/// consumed lazily as values are pulled from the iterator.
///
@external(javascript, "./async_iterator.ffi.mjs", "from_async_yielder")
pub fn from_async_yielder(yielder: AsyncYielder(a)) -> AsyncIterator(a)

/// Wraps the iterator as an
/// [`AsyncYielder`](async_yielder.html#AsyncYielder). The iterator is
/// consumed lazily as values are pulled from the yielder; pair with
/// [`async_yielder.to_list`](async_yielder.html#to_list) for eager
/// materialization.
///
@external(javascript, "./async_iterator.ffi.mjs", "to_async_yielder")
pub fn to_async_yielder(iterator: AsyncIterator(a)) -> AsyncYielder(a)

/// Consumes the iterator, calling `fun` on each yielded value.
/// Equivalent to JavaScript's `for await...of` loop.
///
@external(javascript, "./async_iterator.ffi.mjs", "each")
pub fn each(
  over iterator: AsyncIterator(a),
  with fun: fn(a) -> b,
) -> Promise(Nil)
