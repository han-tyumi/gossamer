//// A pull-based async iteration type implemented in pure Gleam. The
//// canonical type for iterating over `Promise`-yielding sources;
//// mirrors `gleam_yielder.Yielder` for async iteration.
////
//// Callback-taking operations come in paired sync (`map`, `filter`,
//// `each`, …) and async (`map_async`, `filter_async`, `each_async`, …)
//// twins; the `_async` twin accepts a `Promise`-returning callback.
//// Promise rejections propagate through transforms; terminals surface
//// them as `Promise(Result(_, Dynamic))`.

import gleam/dynamic.{type Dynamic}
import gleam/javascript/promise.{type Promise}
import gleam/list

/// A pull-based async iterator. Each pull returns a promise for the
/// next [`Step`](#Step).
///
pub opaque type AsyncYielder(a) {
  AsyncYielder(pull: fn() -> Promise(Step(a)))
}

/// One step of an [`AsyncYielder`](#AsyncYielder): either the next
/// `value` paired with the rest of the yielder, or `Done` when the
/// yielder is exhausted.
///
pub type Step(a) {
  Next(value: a, rest: AsyncYielder(a))
  Done
}

/// Pulls the next [`Step`](#Step) from `yielder`.
///
pub fn step(yielder: AsyncYielder(a)) -> Promise(Step(a)) {
  yielder.pull()
}

/// An async yielder that yields nothing.
///
pub fn empty() -> AsyncYielder(a) {
  AsyncYielder(pull: fn() { promise.resolve(Done) })
}

/// Creates an async yielder from a Gleam list. Each value resolves
/// synchronously.
///
pub fn from_list(list: List(a)) -> AsyncYielder(a) {
  AsyncYielder(pull: fn() {
    case list {
      [] -> promise.resolve(Done)
      [first, ..rest] -> promise.resolve(Next(first, from_list(rest)))
    }
  })
}

/// Applies `fun` to each value of `yielder` as it's pulled.
///
pub fn map(
  over yielder: AsyncYielder(a),
  with fun: fn(a) -> b,
) -> AsyncYielder(b) {
  AsyncYielder(pull: fn() {
    use step <- promise.map(yielder.pull())
    case step {
      Done -> Done
      Next(value, rest) -> Next(fun(value), map(rest, fun))
    }
  })
}

/// Like [`map`](#map) but `fun` returns a `Promise`. Each call is
/// awaited before the next.
///
pub fn map_async(
  over yielder: AsyncYielder(a),
  with fun: fn(a) -> Promise(b),
) -> AsyncYielder(b) {
  AsyncYielder(pull: fn() {
    use step <- promise.await(yielder.pull())
    case step {
      Done -> promise.resolve(Done)
      Next(value, rest) -> {
        use mapped <- promise.map(fun(value))
        Next(mapped, map_async(rest, fun))
      }
    }
  })
}

/// Yields only values from `yielder` for which `predicate` returns
/// `True`.
///
pub fn filter(
  yielder: AsyncYielder(a),
  keeping predicate: fn(a) -> Bool,
) -> AsyncYielder(a) {
  AsyncYielder(pull: fn() { filter_loop(yielder, predicate) })
}

fn filter_loop(
  yielder: AsyncYielder(a),
  predicate: fn(a) -> Bool,
) -> Promise(Step(a)) {
  use step <- promise.await(yielder.pull())
  case step {
    Done -> promise.resolve(Done)
    Next(value, rest) ->
      case predicate(value) {
        True -> promise.resolve(Next(value, filter(rest, predicate)))
        False -> filter_loop(rest, predicate)
      }
  }
}

/// Like [`filter`](#filter) but `predicate` returns a `Promise`. Each
/// call is awaited before the next.
///
pub fn filter_async(
  yielder: AsyncYielder(a),
  keeping predicate: fn(a) -> Promise(Bool),
) -> AsyncYielder(a) {
  AsyncYielder(pull: fn() { filter_async_loop(yielder, predicate) })
}

fn filter_async_loop(
  yielder: AsyncYielder(a),
  predicate: fn(a) -> Promise(Bool),
) -> Promise(Step(a)) {
  use step <- promise.await(yielder.pull())
  case step {
    Done -> promise.resolve(Done)
    Next(value, rest) -> {
      use keep <- promise.await(predicate(value))
      case keep {
        True -> promise.resolve(Next(value, filter_async(rest, predicate)))
        False -> filter_async_loop(rest, predicate)
      }
    }
  }
}

/// Drains the yielder, collecting all yielded values into a list.
/// Returns the rejection reason if any pull rejects.
///
pub fn to_list(yielder: AsyncYielder(a)) -> Promise(Result(List(a), Dynamic)) {
  use reason <- promise.rescue(promise.map(to_list_loop(yielder, []), Ok))
  Error(reason)
}

fn to_list_loop(yielder: AsyncYielder(a), acc: List(a)) -> Promise(List(a)) {
  use step <- promise.await(yielder.pull())
  case step {
    Done -> promise.resolve(list.reverse(acc))
    Next(value, rest) -> to_list_loop(rest, [value, ..acc])
  }
}

/// Drains the yielder, calling `fun` on each yielded value. Returns
/// the rejection reason if the yielder or `fun` rejects.
///
pub fn each(
  over yielder: AsyncYielder(a),
  with fun: fn(a) -> b,
) -> Promise(Result(Nil, Dynamic)) {
  use reason <- promise.rescue(
    promise.map(each_loop(yielder, fun), fn(_) { Ok(Nil) }),
  )
  Error(reason)
}

fn each_loop(yielder: AsyncYielder(a), fun: fn(a) -> b) -> Promise(Nil) {
  use step <- promise.await(yielder.pull())
  case step {
    Done -> promise.resolve(Nil)
    Next(value, rest) -> {
      fun(value)
      each_loop(rest, fun)
    }
  }
}

/// Like [`each`](#each) but `fun` returns a `Promise`. Each call is
/// awaited before the next.
///
pub fn each_async(
  over yielder: AsyncYielder(a),
  with fun: fn(a) -> Promise(b),
) -> Promise(Result(Nil, Dynamic)) {
  use reason <- promise.rescue(
    promise.map(each_async_loop(yielder, fun), fn(_) { Ok(Nil) }),
  )
  Error(reason)
}

fn each_async_loop(
  yielder: AsyncYielder(a),
  fun: fn(a) -> Promise(b),
) -> Promise(Nil) {
  use step <- promise.await(yielder.pull())
  case step {
    Done -> promise.resolve(Nil)
    Next(value, rest) -> {
      use _ <- promise.await(fun(value))
      each_async_loop(rest, fun)
    }
  }
}
