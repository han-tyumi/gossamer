import gleam/option.{type Option}
import gossamer/iterator_result.{type IteratorResult}
import gossamer/promise.{type Promise}

@external(javascript, "./async_iterator.type.ts", "AsyncIterator$")
pub type AsyncIterator(a, return, next)

@external(javascript, "./async_iterator.ffi.mjs", "new_")
pub fn new(
  next: fn(Option(next)) -> Promise(IteratorResult(a, return)),
) -> AsyncIterator(a, return, next)

/// Creates an async iterator from a Gleam list.
///
@external(javascript, "./async_iterator.ffi.mjs", "from_list")
pub fn from_list(list: List(a)) -> AsyncIterator(a, Nil, Nil)

/// Collects all values from an async iterator into a list. Consumes the
/// iterator.
///
@external(javascript, "./async_iterator.ffi.mjs", "to_list")
pub fn to_list(
  iterator: AsyncIterator(a, return, next),
) -> Promise(Result(List(a), String))

@external(javascript, "./async_iterator.ffi.mjs", "with_return")
pub fn with_return(
  iterator: AsyncIterator(a, return, next),
  return: fn(Option(return)) -> Promise(IteratorResult(a, return)),
) -> AsyncIterator(a, return, next)

@external(javascript, "./async_iterator.ffi.mjs", "with_throw")
pub fn with_throw(
  iterator: AsyncIterator(a, return, next),
  throw: fn(e) -> Promise(IteratorResult(a, return)),
) -> AsyncIterator(a, return, next)

@external(javascript, "./async_iterator.ffi.mjs", "next")
pub fn next(
  iterator: AsyncIterator(a, return, next),
) -> Promise(Result(IteratorResult(a, return), String))

@external(javascript, "./async_iterator.ffi.mjs", "next_with")
pub fn next_with(
  iterator: AsyncIterator(a, return, next),
  value: next,
) -> Promise(Result(IteratorResult(a, return), String))

@external(javascript, "./async_iterator.ffi.mjs", "return_")
pub fn return(
  iterator: AsyncIterator(a, return, next),
) -> Promise(Result(IteratorResult(a, return), Nil))

@external(javascript, "./async_iterator.ffi.mjs", "return_with")
pub fn return_with(
  iterator: AsyncIterator(a, return, next),
  value: return,
) -> Promise(Result(IteratorResult(a, return), Nil))

@external(javascript, "./async_iterator.ffi.mjs", "throw_")
pub fn throw(
  iterator: AsyncIterator(a, return, next),
  reason reason: e,
) -> Promise(Result(IteratorResult(a, return), Nil))

@external(javascript, "./async_iterator.ffi.mjs", "for_await")
pub fn for_await(
  in iterator: AsyncIterator(a, return, next),
  run fun: fn(a) -> any,
) -> Promise(Result(Nil, String))
