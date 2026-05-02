import gleam/option.{type Option}
import gossamer/iterator_handler_outcome.{type IteratorHandlerOutcome}
import gossamer/iterator_result.{type IteratorResult}
import gossamer/js_error.{type JsError}
import gossamer/promise.{type Promise}

/// A pull-based iterator that yields values asynchronously. Each call to
/// `next` returns a promise. `a` is the yielded value type, `return` is
/// the final return value, `next` is the type of values passed via
/// `next_with`.
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

/// Collects all values from an async iterator into a list. Consumes the
/// iterator. Returns an error if any `next` call rejects.
///
@external(javascript, "./async_iterator.ffi.mjs", "to_list")
pub fn to_list(
  iterator: AsyncIterator(a, return, next),
) -> Promise(Result(List(a), JsError))

/// Adds a `return` handler called when the consumer ends iteration early.
///
@external(javascript, "./async_iterator.ffi.mjs", "with_return")
pub fn with_return(
  iterator: AsyncIterator(a, return, next),
  return: fn(Option(return)) -> Promise(IteratorResult(a, return)),
) -> AsyncIterator(a, return, next)

/// Adds a `throw` handler called when the consumer signals an error.
///
@external(javascript, "./async_iterator.ffi.mjs", "with_throw")
pub fn with_throw(
  iterator: AsyncIterator(a, return, next),
  throw: fn(e) -> Promise(IteratorResult(a, return)),
) -> AsyncIterator(a, return, next)

/// Advances the iterator and returns a promise for the next result.
/// Returns an error if the underlying `next` callback throws or returns
/// a rejecting promise.
///
@external(javascript, "./async_iterator.ffi.mjs", "next")
pub fn next(
  iterator: AsyncIterator(a, return, next),
) -> Promise(Result(IteratorResult(a, return), JsError))

/// Advances the iterator, passing `value` to its internal logic. Returns
/// an error if the underlying callback throws or returns a rejecting
/// promise.
///
@external(javascript, "./async_iterator.ffi.mjs", "next_with")
pub fn next_with(
  iterator: AsyncIterator(a, return, next),
  value: next,
) -> Promise(Result(IteratorResult(a, return), JsError))

/// Ends iteration early by invoking the iterator's optional `return`
/// handler. `NoHandler` signals the iterator doesn't define one;
/// otherwise `Handled` carries the result. Returns an error if the
/// handler rejects.
///
@external(javascript, "./async_iterator.ffi.mjs", "return_")
pub fn return(
  iterator: AsyncIterator(a, return, next),
) -> Promise(Result(IteratorHandlerOutcome(a, return), JsError))

/// Like `return`, but passes `value` to the iterator's `return` handler.
///
@external(javascript, "./async_iterator.ffi.mjs", "return_with")
pub fn return_with(
  iterator: AsyncIterator(a, return, next),
  value: return,
) -> Promise(Result(IteratorHandlerOutcome(a, return), JsError))

/// Signals an error to the iterator by invoking its optional `throw`
/// handler. `NoHandler` signals the iterator doesn't define one;
/// otherwise `Handled` carries the result. Returns an error if the
/// handler rejects.
///
@external(javascript, "./async_iterator.ffi.mjs", "throw_")
pub fn throw(
  iterator: AsyncIterator(a, return, next),
  reason reason: e,
) -> Promise(Result(IteratorHandlerOutcome(a, return), JsError))

/// Consumes the iterator, calling `fun` on each yielded value. Returns
/// an error if the iterator or callback throws.
///
@external(javascript, "./async_iterator.ffi.mjs", "for_await")
pub fn for_await(
  in iterator: AsyncIterator(a, return, next),
  run fun: fn(a) -> any,
) -> Promise(Result(Nil, JsError))
