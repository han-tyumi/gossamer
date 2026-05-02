import gleam/option.{type Option}
import gossamer/iterator_handler_outcome.{type IteratorHandlerOutcome}
import gossamer/iterator_result.{type IteratorResult}
import gossamer/js_error.{type JsError}

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
/// handler. `NoHandler` signals the iterator doesn't define one;
/// otherwise `Handled` carries the result. Returns an error if the
/// handler throws.
///
@external(javascript, "./iterator.ffi.mjs", "return_")
pub fn return(
  iterator: Iterator(a, return, next),
) -> Result(IteratorHandlerOutcome(a, return), JsError)

/// Like `return`, but passes `value` to the iterator's `return` handler.
///
@external(javascript, "./iterator.ffi.mjs", "return_with")
pub fn return_with(
  iterator: Iterator(a, return, next),
  value: return,
) -> Result(IteratorHandlerOutcome(a, return), JsError)

/// Signals an error to the iterator by invoking its optional `throw`
/// handler. `NoHandler` signals the iterator doesn't define one;
/// otherwise `Handled` carries the result. Returns an error if the
/// handler throws.
///
@external(javascript, "./iterator.ffi.mjs", "throw_")
pub fn throw(
  iterator: Iterator(a, return, next),
  reason reason: e,
) -> Result(IteratorHandlerOutcome(a, return), JsError)

@external(javascript, "./iterator.ffi.mjs", "for_")
pub fn for(in iterator: Iterator(a, return, next), run fun: fn(a) -> any) -> Nil

/// Returns a new iterator that yields the results of applying the callback to
/// each value from the source iterator.
///
@external(javascript, "./iterator.ffi.mjs", "map")
pub fn map(
  over iterator: Iterator(a, return, next),
  with callback: fn(a) -> b,
) -> Iterator(b, Nil, Nil)

/// Returns a new iterator that yields only the values from the source iterator
/// for which the predicate returns `True`.
///
@external(javascript, "./iterator.ffi.mjs", "filter")
pub fn filter(
  in iterator: Iterator(a, return, next),
  keeping predicate: fn(a) -> Bool,
) -> Iterator(a, Nil, Nil)

/// Returns a new iterator that yields at most `limit` values from the source
/// iterator.
///
@external(javascript, "./iterator.ffi.mjs", "take")
pub fn take(
  from iterator: Iterator(a, return, next),
  up_to limit: Int,
) -> Iterator(a, Nil, Nil)

/// Returns a new iterator that skips the first `count` values from the source
/// iterator, then yields the rest.
///
@external(javascript, "./iterator.ffi.mjs", "drop")
pub fn drop(
  from iterator: Iterator(a, return, next),
  up_to count: Int,
) -> Iterator(a, Nil, Nil)

/// Returns a new iterator that applies the callback to each value from the
/// source iterator and yields all values from the resulting iterators.
///
@external(javascript, "./iterator.ffi.mjs", "flat_map")
pub fn flat_map(
  over iterator: Iterator(a, return, next),
  with callback: fn(a) -> Iterator(b, Nil, Nil),
) -> Iterator(b, Nil, Nil)

/// Consumes the iterator, calling the reducer with each value and an
/// accumulator. Returns the final accumulator value.
///
@external(javascript, "./iterator.ffi.mjs", "reduce")
pub fn reduce(
  over iterator: Iterator(a, return, next),
  from initial: b,
  with callback: fn(b, a) -> b,
) -> b

/// Consumes the iterator and returns `True` if the predicate returns `True`
/// for any value. Short-circuits on the first match.
///
@external(javascript, "./iterator.ffi.mjs", "some")
pub fn some(
  in iterator: Iterator(a, return, next),
  satisfying predicate: fn(a) -> Bool,
) -> Bool

/// Consumes the iterator and returns `True` if the predicate returns `True`
/// for every value. Short-circuits on the first non-match.
///
@external(javascript, "./iterator.ffi.mjs", "every")
pub fn every(
  in iterator: Iterator(a, return, next),
  satisfying predicate: fn(a) -> Bool,
) -> Bool

/// Consumes the iterator and returns the first value for which the predicate
/// returns `True`. Returns an error if no value matches.
///
@external(javascript, "./iterator.ffi.mjs", "find")
pub fn find(
  in iterator: Iterator(a, return, next),
  one_that predicate: fn(a) -> Bool,
) -> Result(a, Nil)
