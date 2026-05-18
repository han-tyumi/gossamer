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
import gleam/int
import gleam/javascript/promise.{type Promise}
import gleam/list
import gleam/order

/// A pull-based async iterator. Each pull returns a promise for the
/// next [`Step`](#Step).
///
pub opaque type AsyncYielder(a) {
  AsyncYielder(pull: fn() -> Promise(Step(a, AsyncYielder(a))))
}

/// One step of iteration: either the next `element` paired with an
/// `accumulator` to feed into the next step, or `Done` to halt.
///
/// When returned from [`step`](#step), `accumulator` is the next
/// [`AsyncYielder`](#AsyncYielder). When passed to [`unfold`](#unfold),
/// `accumulator` is the user's state.
///
pub type Step(element, accumulator) {
  Next(element: element, accumulator: accumulator)
  Done
}

/// Pulls the next [`Step`](#Step) from `yielder`.
///
pub fn step(yielder: AsyncYielder(a)) -> Promise(Step(a, AsyncYielder(a))) {
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

/// An async yielder that yields exactly `elem`, then stops.
///
pub fn single(elem: a) -> AsyncYielder(a) {
  once(fn() { elem })
}

/// An async yielder that yields the result of `fun()`, then stops.
///
pub fn once(fun: fn() -> a) -> AsyncYielder(a) {
  AsyncYielder(pull: fn() { promise.resolve(Next(fun(), empty())) })
}

/// Like [`once`](#once) but `fun` returns a `Promise`. The promise is
/// awaited when the yielder is first pulled.
///
pub fn once_async(fun: fn() -> Promise(a)) -> AsyncYielder(a) {
  AsyncYielder(pull: fn() {
    use value <- promise.map(fun())
    Next(value, empty())
  })
}

/// An async yielder of integers from `start` up to (or down to) `stop`,
/// inclusive on both ends.
///
pub fn range(from start: Int, to stop: Int) -> AsyncYielder(Int) {
  case int.compare(start, stop) {
    order.Eq -> once(fn() { start })
    order.Gt ->
      unfold(from: start, with: fn(current) {
        case current < stop {
          False -> Next(current, current - 1)
          True -> Done
        }
      })
    order.Lt ->
      unfold(from: start, with: fn(current) {
        case current > stop {
          False -> Next(current, current + 1)
          True -> Done
        }
      })
  }
}

/// Constructs an async yielder by repeatedly calling `fun` with an
/// accumulator, starting with `initial`. Each `Next(element,
/// accumulator)` yields the element and feeds the new accumulator into
/// the next call; `Done` stops the yielder.
///
pub fn unfold(
  from initial: acc,
  with fun: fn(acc) -> Step(a, acc),
) -> AsyncYielder(a) {
  AsyncYielder(pull: fn() {
    case fun(initial) {
      Done -> promise.resolve(Done)
      Next(element, accumulator) ->
        promise.resolve(Next(element, unfold(accumulator, fun)))
    }
  })
}

/// Like [`unfold`](#unfold) but `fun` returns a `Promise`. Each call is
/// awaited before the next.
///
pub fn unfold_async(
  from initial: acc,
  with fun: fn(acc) -> Promise(Step(a, acc)),
) -> AsyncYielder(a) {
  AsyncYielder(pull: fn() {
    use next_step <- promise.map(fun(initial))
    case next_step {
      Done -> Done
      Next(element, accumulator) ->
        Next(element, unfold_async(accumulator, fun))
    }
  })
}

/// Yields `element` followed by whatever `next()` produces. `next()` is
/// only called when the yielder is first pulled.
///
pub fn yield(element: a, next: fn() -> AsyncYielder(a)) -> AsyncYielder(a) {
  AsyncYielder(pull: fn() { promise.resolve(Next(element, next())) })
}

/// Like [`yield`](#yield) but `next` returns a `Promise`. The promise
/// is awaited when the yielder is first pulled.
///
pub fn yield_async(
  element: a,
  next: fn() -> Promise(AsyncYielder(a)),
) -> AsyncYielder(a) {
  AsyncYielder(pull: fn() {
    use rest <- promise.map(next())
    Next(element, rest)
  })
}

/// Adds `element` to the front of `yielder`.
///
pub fn prepend(yielder: AsyncYielder(a), element: a) -> AsyncYielder(a) {
  use <- yield(element)
  yielder
}

/// Concatenates two yielders: yields all of `first`'s values, then all
/// of `second`'s.
///
pub fn append(
  to first: AsyncYielder(a),
  suffix second: AsyncYielder(a),
) -> AsyncYielder(a) {
  AsyncYielder(pull: fn() {
    use step <- promise.await(first.pull())
    case step {
      Done -> second.pull()
      Next(value, rest) -> promise.resolve(Next(value, append(rest, second)))
    }
  })
}

/// Flattens a yielder of yielders into a single yielder, yielding all
/// of each inner yielder's values in order.
///
pub fn flatten(yielder: AsyncYielder(AsyncYielder(a))) -> AsyncYielder(a) {
  AsyncYielder(pull: fn() {
    use outer_step <- promise.await(yielder.pull())
    case outer_step {
      Done -> promise.resolve(Done)
      Next(inner, outer_rest) -> append(inner, flatten(outer_rest)).pull()
    }
  })
}

/// Concatenates a list of yielders into a single yielder.
///
pub fn concat(yielders: List(AsyncYielder(a))) -> AsyncYielder(a) {
  flatten(from_list(yielders))
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
) -> Promise(Step(a, AsyncYielder(a))) {
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
) -> Promise(Step(a, AsyncYielder(a))) {
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
