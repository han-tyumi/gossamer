//// JavaScript `AsyncIterator` binding for interop with APIs that
//// produce or consume async iterators. Construct from a callback or
//// from a Gleam list, consume with [`for_await`](#for_await) or pull
//// chunks via [`next`](#next).

import gleam/dynamic.{type Dynamic}
import gleam/javascript/promise.{type Promise}
import gleam/option.{type Option}
import gossamer/iteration.{type IteratorHandlerOutcome, type IteratorResult}

/// A pull-based iterator that yields values asynchronously. Each call
/// to [`next`](#next) returns a promise. `a` is the yielded value type,
/// `return` is the final return value, `next` is the type of values
/// passed via [`next`](#next).
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

/// Sets the iterator's optional `return` handler, called when the
/// consumer ends iteration early.
///
@external(javascript, "./async_iterator.ffi.mjs", "set_return")
pub fn set_return(
  iterator: AsyncIterator(a, return, next),
  return: fn(Option(return)) -> Promise(IteratorResult(a, return)),
) -> AsyncIterator(a, return, next)

/// Sets the iterator's optional `throw` handler, called when the
/// consumer signals an error.
///
@external(javascript, "./async_iterator.ffi.mjs", "set_throw")
pub fn set_throw(
  iterator: AsyncIterator(a, return, next),
  throw: fn(e) -> Promise(IteratorResult(a, return)),
) -> AsyncIterator(a, return, next)

/// Advances the iterator and returns a promise for the next result.
/// Pass `Some(value)` to send a value into the iterator's internal
/// logic; pass `None` for a plain advance. Returns the thrown value
/// or rejection reason if the underlying `next` callback throws or
/// returns a rejecting promise.
///
@external(javascript, "./async_iterator.ffi.mjs", "next")
pub fn next(
  iterator: AsyncIterator(a, return, next),
  value value: Option(next),
) -> Promise(Result(IteratorResult(a, return), Dynamic))

/// Ends iteration early by invoking the iterator's optional `return`
/// handler. `Ok(NoHandler)` if the iterator doesn't define one;
/// `Ok(Handled)` carries the result the handler produced. Returns the
/// rejection reason if the handler rejects.
///
/// Pass `Some(value)` to forward a value to the handler; pass `None`
/// when the handler is no-arg or you have nothing to forward.
///
@external(javascript, "./async_iterator.ffi.mjs", "return_")
pub fn return(
  iterator: AsyncIterator(a, return, next),
  value value: Option(return),
) -> Promise(Result(IteratorHandlerOutcome(a, return), Dynamic))

/// Signals an error to the iterator by invoking its optional `throw`
/// handler. `Ok(NoHandler)` if the iterator doesn't define one —
/// `reason` is discarded; the caller must decide whether to propagate.
/// `Ok(Handled)` carries the result the handler produced. Returns the
/// rejection reason if the handler itself rejects.
///
@external(javascript, "./async_iterator.ffi.mjs", "throw_")
pub fn throw(
  iterator: AsyncIterator(a, return, next),
  reason reason: e,
) -> Promise(Result(IteratorHandlerOutcome(a, return), Dynamic))

/// Consumes the iterator, calling `fun` on each yielded value. Returns
/// the thrown value or rejection reason if the iterator or `fun` throws
/// or rejects.
///
@external(javascript, "./async_iterator.ffi.mjs", "for_await")
pub fn for_await(
  in iterator: AsyncIterator(a, return, next),
  run fun: fn(a) -> any,
) -> Promise(Result(Nil, Dynamic))
