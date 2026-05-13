//// JavaScript `Iterator` binding for interop with APIs that produce or
//// consume iterators (`Map.entries`, `Set.values`, `ReadableStream.from`,
//// etc.). Treated as a transit type: pass an iterator across the FFI
//// boundary and bridge to `gleam_yielder`'s `Yielder` for Gleam-side
//// iteration via [`to_yielder`](#to_yielder). The iterator protocol
//// (`next`, `return`, `throw`) is intentionally not exposed publicly —
//// observable mutation lives on the JavaScript side.

import gleam/option.{type Option}
import gleam/yielder.{type Yielder}
import gossamer/iteration.{type IteratorResult}

/// A pull-based iterator that yields values one at a time. `a` is the
/// yielded value type, `return` is the final return value, `next` is
/// the type of values JavaScript callers can send back into the
/// iterator (the right-hand side of `yield` in a generator).
///
/// See [Iterator](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Iterator) on MDN.
///
@external(javascript, "./iterator.type.ts", "Iterator$")
pub type Iterator(a, return, next)

/// Creates an iterator from a `next` callback — called each time a value
/// is pulled, producing the next value or signaling done.
///
@external(javascript, "./iterator.ffi.mjs", "new_")
pub fn new(
  next: fn(Option(next)) -> IteratorResult(a, return),
) -> Iterator(a, return, next)

/// Creates an iterator from a `Yielder`. The yielder is consumed
/// lazily as values are pulled from the iterator.
///
@external(javascript, "./iterator.ffi.mjs", "from_yielder")
pub fn from_yielder(yielder: Yielder(a)) -> Iterator(a, Nil, Nil)

/// Wraps the iterator as a `Yielder`. The iterator is consumed lazily
/// as values are pulled from the yielder; pair with `yielder.to_list`
/// for eager materialization.
///
@external(javascript, "./iterator.ffi.mjs", "to_yielder")
pub fn to_yielder(iterator: Iterator(a, return, next)) -> Yielder(a)

/// Consumes the iterator, calling `fun` on each yielded value.
///
@external(javascript, "./iterator.ffi.mjs", "for_")
pub fn for(in iterator: Iterator(a, return, next), run fun: fn(a) -> any) -> Nil
