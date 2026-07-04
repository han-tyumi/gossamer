//// JavaScript `Iterator` binding for interop with APIs that produce or
//// consume iterators (`Map.entries`, `Set.values`, `ReadableStream.from`,
//// etc.). Treated as a transit type: pass an iterator across the FFI
//// boundary and bridge to `gleam_yielder`'s `Yielder` for Gleam-side
//// iteration via [`to_yielder`](#to_yielder).
////
//// The iterator protocol (`next`, `return`, `throw`) is intentionally
//// not exposed publicly — observable mutation lives on the JavaScript
//// side. Build iterators on the Gleam side by composing a `Yielder`
//// and bridging via [`from_yielder`](#from_yielder).
////
//// Throws from the underlying iterator's `next()` propagate as panics
//// at the pull site.

import gleam/yielder.{type Yielder}

/// A pull-based iterator that yields values one at a time.
///
/// See [Iterator](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Iterator) on MDN.
///
@external(javascript, "./iterator.type.ts", "Iterator$")
pub type Iterator(a)

/// Creates an iterator from a `Yielder`. The yielder is consumed
/// lazily as values are pulled from the iterator.
///
@external(javascript, "./iterator.ffi.mjs", "from_yielder")
pub fn from_yielder(yielder: Yielder(a)) -> Iterator(a)

/// Wraps the iterator as a `Yielder`. The iterator is consumed lazily
/// as values are pulled from the yielder; pair with `yielder.to_list`
/// for eager materialization.
///
/// > **Warning**: the returned yielder shares the iterator's state, so
/// > it is single-pass. Pulling from it (or any yielder derived from
/// > it) advances the underlying iterator, so it can't be replayed
/// > like an ordinary `Yielder`.
///
@external(javascript, "./iterator.ffi.mjs", "to_yielder")
pub fn to_yielder(iterator: Iterator(a)) -> Yielder(a)

/// Consumes the iterator, calling `fun` on each yielded value.
/// Equivalent to JavaScript's `for...of` loop.
///
@external(javascript, "./iterator.ffi.mjs", "each")
pub fn each(over iterator: Iterator(a), with fun: fn(a) -> b) -> Nil
