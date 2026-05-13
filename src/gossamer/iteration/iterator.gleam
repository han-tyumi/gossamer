//// JavaScript `Iterator` binding for interop with APIs that produce or
//// consume iterators (`Map.entries`, `Set.values`, `ReadableStream.from`,
//// etc.).
//// The module is intentionally a transit-type binding: it exposes the
//// type, construction primitives, the iterator protocol (`next`,
//// `return`, `throw`), and bridges to/from `gleam_yielder`'s
//// `Yielder` — the canonical Gleam type for lazy iteration. Convert via
//// `to_yielder` and operate on the Yielder (use `yielder.to_list` when
//// you need an eager `List`).

import gleam/dynamic.{type Dynamic}
import gleam/option.{type Option}
import gleam/yielder.{type Yielder}
import gossamer/iteration.{type IteratorHandlerOutcome, type IteratorResult}

/// A pull-based iterator that yields values one at a time. `a` is the
/// yielded value type, `return` is the final return value, `next` is
/// the type of values passed in to [`next`](#next).
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

/// Sets the iterator's optional `return` handler, called when the
/// consumer ends iteration early — e.g., by breaking out of a `for`
/// loop or returning from a generator.
///
@external(javascript, "./iterator.ffi.mjs", "set_return")
pub fn set_return(
  iterator: Iterator(a, return, next),
  return: fn(Option(return)) -> IteratorResult(a, return),
) -> Iterator(a, return, next)

/// Sets the iterator's optional `throw` handler, called when the
/// consumer signals an error.
///
@external(javascript, "./iterator.ffi.mjs", "set_throw")
pub fn set_throw(
  iterator: Iterator(a, return, next),
  throw: fn(e) -> IteratorResult(a, return),
) -> Iterator(a, return, next)

/// Advances the iterator and returns the next result. Pass
/// `Some(value)` to send a value into the iterator's internal logic
/// (e.g., the right-hand side of `yield` in a generator); pass `None`
/// for a plain advance.
///
@external(javascript, "./iterator.ffi.mjs", "next")
pub fn next(
  iterator: Iterator(a, return, next),
  value value: Option(next),
) -> IteratorResult(a, return)

/// Ends iteration early by invoking the iterator's optional `return`
/// handler. `Ok(NoHandler)` if the iterator doesn't define one;
/// `Ok(Handled)` carries the result the handler produced. Returns an
/// error carrying the thrown value if the handler throws.
///
/// Pass `Some(value)` to forward a value to the handler; pass `None`
/// when the handler is no-arg or you have nothing to forward.
///
@external(javascript, "./iterator.ffi.mjs", "return_")
pub fn return(
  iterator: Iterator(a, return, next),
  value value: Option(return),
) -> Result(IteratorHandlerOutcome(a, return), Dynamic)

/// Signals an error to the iterator by invoking its optional `throw`
/// handler. `Ok(NoHandler)` if the iterator doesn't define one —
/// `reason` is discarded; the caller must decide whether to propagate.
/// `Ok(Handled)` carries the result the handler produced. Returns an
/// error carrying the thrown value if the handler itself throws.
///
@external(javascript, "./iterator.ffi.mjs", "throw_")
pub fn throw(
  iterator: Iterator(a, return, next),
  reason reason: e,
) -> Result(IteratorHandlerOutcome(a, return), Dynamic)

/// Consumes the iterator, calling `fun` on each yielded value. After
/// `for` returns, `next` produces `Return`.
///
@external(javascript, "./iterator.ffi.mjs", "for_")
pub fn for(in iterator: Iterator(a, return, next), run fun: fn(a) -> any) -> Nil
