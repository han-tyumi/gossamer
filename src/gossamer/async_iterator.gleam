import gleam/option.{type Option}
import gossamer/iterator_result.{type IteratorResult}
import gossamer/promise.{type Promise}

@external(javascript, "./async_iterator.type.ts", "AsyncIterator$")
pub type AsyncIterator(a, return, next)

@external(javascript, "./async_iterator.ffi.mjs", "new_")
pub fn new(
  next: fn(Option(next)) -> Promise(IteratorResult(a, return)),
) -> AsyncIterator(a, return, next)

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
) -> Promise(IteratorResult(a, return))

@external(javascript, "./async_iterator.ffi.mjs", "next_with")
pub fn next_with(
  iterator: AsyncIterator(a, return, next),
  value: next,
) -> Promise(IteratorResult(a, return))

@external(javascript, "./async_iterator.ffi.mjs", "return_")
pub fn return(
  iterator: AsyncIterator(a, return, next),
) -> Promise(IteratorResult(a, return))

@external(javascript, "./async_iterator.ffi.mjs", "return_with")
pub fn return_with(
  iterator: AsyncIterator(a, return, next),
  value: return,
) -> Promise(IteratorResult(a, return))

@external(javascript, "./async_iterator.ffi.mjs", "throw_")
pub fn throw(
  iterator: AsyncIterator(a, return, next),
  e: e,
) -> Promise(IteratorResult(a, return))

@external(javascript, "./async_iterator.ffi.mjs", "for_await")
pub fn for_await(
  iterator: AsyncIterator(a, return, next),
  fun: fn(a) -> any,
) -> Promise(Nil)
