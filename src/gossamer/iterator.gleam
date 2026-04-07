import gossamer/iterator_result.{type IteratorResult}
import gleam/option.{type Option}

@external(javascript, "./iterator.type.ts", "Iterator$")
pub type Iterator(a, return, next)

@external(javascript, "./iterator.ffi.mjs", "new_")
pub fn new(
  next: fn(Option(next)) -> IteratorResult(a, return),
) -> Iterator(a, return, next)

@external(javascript, "./iterator.ffi.mjs", "with_return")
pub fn with_return(
  iterator: Iterator(a, return, next),
  return: fn(Option(return)) -> IteratorResult(a, return),
) -> Iterator(a, return, next)

@external(javascript, "./iterator.ffi.mjs", "with_throw")
pub fn with_throw(
  iterator: Iterator(a, return, next),
  throw: fn(e) -> IteratorResult(a, return),
) -> Iterator(a, return, next)

@external(javascript, "./iterator.ffi.mjs", "next")
pub fn next(iterator: Iterator(a, return, next)) -> IteratorResult(a, return)

@external(javascript, "./iterator.ffi.mjs", "next_with")
pub fn next_with(
  iterator: Iterator(a, return, next),
  value: next,
) -> IteratorResult(a, return)

@external(javascript, "./iterator.ffi.mjs", "return_")
pub fn return(
  iterator: Iterator(a, return, next),
) -> Result(IteratorResult(a, return), Nil)

@external(javascript, "./iterator.ffi.mjs", "return_with")
pub fn return_with(
  iterator: Iterator(a, return, next),
  value: return,
) -> Result(IteratorResult(a, return), Nil)

@external(javascript, "./iterator.ffi.mjs", "throw_")
pub fn throw(
  iterator: Iterator(a, return, next),
  e: e,
) -> Result(IteratorResult(a, return), Nil)

@external(javascript, "./iterator.ffi.mjs", "for_")
pub fn for(iterator: Iterator(a, return, next), fun: fn(a) -> any) -> Nil
