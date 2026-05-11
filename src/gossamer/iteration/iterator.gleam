//// JS `Iterator` binding for interop with APIs that produce or consume
//// iterators (`Map.entries`, `Set.values`, `ReadableStream.from`, etc.).
//// The module is intentionally a transit-type binding: it exposes the
//// type, construction primitives, the iterator protocol (`next`,
//// `return`, `throw`), and bridges to/from `List`. For lazy
//// transformation pipelines, convert via `to_list` and operate on a
//// Gleam-native collection (`gleam/list` for eager, `gleam_yielder` for
//// lazy).

import gleam/option.{type Option}
import gossamer/iteration.{
  type IteratorError, type IteratorHandlerOutcome, type IteratorResult,
}

/// A pull-based iterator that yields values one at a time. `a` is the
/// yielded value type, `return` is the final return value, `next` is the
/// type of values passed in via `next_with`.
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

/// Creates an iterator from a Gleam list.
///
@external(javascript, "./iterator.ffi.mjs", "from_list")
pub fn from_list(list: List(a)) -> Iterator(a, Nil, Nil)

/// Collects all values from an iterator into a list. Consumes the iterator.
///
@external(javascript, "./iterator.ffi.mjs", "to_list")
pub fn to_list(iterator: Iterator(a, return, next)) -> List(a)

/// Adds a `return` handler to the iterator, called when the consumer
/// ends iteration early. Used to release resources.
///
@external(javascript, "./iterator.ffi.mjs", "with_return")
pub fn with_return(
  iterator: Iterator(a, return, next),
  return: fn(Option(return)) -> IteratorResult(a, return),
) -> Iterator(a, return, next)

/// Adds a `throw` handler to the iterator, called when the consumer
/// signals an error.
///
@external(javascript, "./iterator.ffi.mjs", "with_throw")
pub fn with_throw(
  iterator: Iterator(a, return, next),
  throw: fn(e) -> IteratorResult(a, return),
) -> Iterator(a, return, next)

/// Advances the iterator and returns the next result.
///
@external(javascript, "./iterator.ffi.mjs", "next")
pub fn next(iterator: Iterator(a, return, next)) -> IteratorResult(a, return)

/// Advances the iterator, passing `value` to the iterator's internal logic.
///
@external(javascript, "./iterator.ffi.mjs", "next_with")
pub fn next_with(
  iterator: Iterator(a, return, next),
  value: next,
) -> IteratorResult(a, return)

/// Ends iteration early by invoking the iterator's optional `return`
/// handler. `Ok(NoHandler)` if the iterator doesn't define one;
/// `Ok(Handled)` carries the result the handler produced. Returns
/// `Error(CallbackThrew(_))` if the handler throws.
///
@external(javascript, "./iterator.ffi.mjs", "return_")
pub fn return(
  iterator: Iterator(a, return, next),
) -> Result(IteratorHandlerOutcome(a, return), IteratorError)

/// Like `return`, but passes `value` to the iterator's `return` handler.
/// `value` is discarded if the iterator doesn't define one.
///
@external(javascript, "./iterator.ffi.mjs", "return_with")
pub fn return_with(
  iterator: Iterator(a, return, next),
  value: return,
) -> Result(IteratorHandlerOutcome(a, return), IteratorError)

/// Signals an error to the iterator by invoking its optional `throw`
/// handler. `Ok(NoHandler)` if the iterator doesn't define one — `reason`
/// is discarded; the caller must decide whether to propagate. `Ok(Handled)`
/// carries the result the handler produced. Returns
/// `Error(CallbackThrew(_))` if the handler itself throws.
///
@external(javascript, "./iterator.ffi.mjs", "throw_")
pub fn throw(
  iterator: Iterator(a, return, next),
  reason reason: e,
) -> Result(IteratorHandlerOutcome(a, return), IteratorError)

@external(javascript, "./iterator.ffi.mjs", "for_")
pub fn for(in iterator: Iterator(a, return, next), run fun: fn(a) -> any) -> Nil
