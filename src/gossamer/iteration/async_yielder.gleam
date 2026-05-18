//// A pull-based async iteration type implemented in pure Gleam. The
//// canonical type for iterating over `Promise`-yielding sources;
//// mirrors `gleam_yielder.Yielder` for async iteration.
////
//// Callback-taking operations come in paired sync (`map`, `filter`,
//// `each`, …) and async (`map_async`, `filter_async`, `each_async`, …)
//// twins; the `_async` twin accepts a `Promise`-returning callback.
//// Fallible operations should be expressed via `Result` inside the
//// promise, following gleam_javascript convention.

import gleam/int
import gleam/javascript/promise.{type Promise}
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

/// Applies `fun` to each value of `yielder` and flattens the resulting
/// yielders.
///
pub fn flat_map(
  over yielder: AsyncYielder(a),
  with fun: fn(a) -> AsyncYielder(b),
) -> AsyncYielder(b) {
  yielder
  |> map(fun)
  |> flatten
}

/// Like [`flat_map`](#flat_map) but `fun` returns a `Promise`. Each
/// call is awaited before the next.
///
pub fn flat_map_async(
  over yielder: AsyncYielder(a),
  with fun: fn(a) -> Promise(AsyncYielder(b)),
) -> AsyncYielder(b) {
  yielder
  |> map_async(fun)
  |> flatten
}

/// Applies `fun` to each value of `yielder`, keeping the `Ok` results
/// and dropping the `Error`s.
///
pub fn filter_map(
  yielder: AsyncYielder(a),
  keeping_with fun: fn(a) -> Result(b, c),
) -> AsyncYielder(b) {
  AsyncYielder(pull: fn() { filter_map_loop(yielder, fun) })
}

fn filter_map_loop(
  yielder: AsyncYielder(a),
  fun: fn(a) -> Result(b, c),
) -> Promise(Step(b, AsyncYielder(b))) {
  use step <- promise.await(yielder.pull())
  case step {
    Done -> promise.resolve(Done)
    Next(value, rest) ->
      case fun(value) {
        Ok(mapped) -> promise.resolve(Next(mapped, filter_map(rest, fun)))
        Error(_) -> filter_map_loop(rest, fun)
      }
  }
}

/// Like [`filter_map`](#filter_map) but `fun` returns a `Promise`.
/// Each call is awaited before the next.
///
pub fn filter_map_async(
  yielder: AsyncYielder(a),
  keeping_with fun: fn(a) -> Promise(Result(b, c)),
) -> AsyncYielder(b) {
  AsyncYielder(pull: fn() { filter_map_async_loop(yielder, fun) })
}

fn filter_map_async_loop(
  yielder: AsyncYielder(a),
  fun: fn(a) -> Promise(Result(b, c)),
) -> Promise(Step(b, AsyncYielder(b))) {
  use step <- promise.await(yielder.pull())
  case step {
    Done -> promise.resolve(Done)
    Next(value, rest) -> {
      use result <- promise.await(fun(value))
      case result {
        Ok(mapped) -> promise.resolve(Next(mapped, filter_map_async(rest, fun)))
        Error(_) -> filter_map_async_loop(rest, fun)
      }
    }
  }
}

/// Yields the running accumulation of `fun(acc, value)` starting from
/// `initial`. Empty source yields nothing (the initial value is not
/// emitted alone).
///
pub fn scan(
  over yielder: AsyncYielder(a),
  from initial: acc,
  with fun: fn(acc, a) -> acc,
) -> AsyncYielder(acc) {
  AsyncYielder(pull: fn() {
    use step <- promise.map(yielder.pull())
    case step {
      Done -> Done
      Next(value, rest) -> {
        let new_acc = fun(initial, value)
        Next(new_acc, scan(rest, new_acc, fun))
      }
    }
  })
}

/// Like [`scan`](#scan) but `fun` returns a `Promise`. Each call is
/// awaited before the next.
///
pub fn scan_async(
  over yielder: AsyncYielder(a),
  from initial: acc,
  with fun: fn(acc, a) -> Promise(acc),
) -> AsyncYielder(acc) {
  AsyncYielder(pull: fn() {
    use step <- promise.await(yielder.pull())
    case step {
      Done -> promise.resolve(Done)
      Next(value, rest) -> {
        use new_acc <- promise.map(fun(initial, value))
        Next(new_acc, scan_async(rest, new_acc, fun))
      }
    }
  })
}

/// Yields each value of `yielder` paired with its zero-based index.
///
pub fn index(over yielder: AsyncYielder(a)) -> AsyncYielder(#(a, Int)) {
  index_loop(yielder, 0)
}

fn index_loop(yielder: AsyncYielder(a), next: Int) -> AsyncYielder(#(a, Int)) {
  AsyncYielder(pull: fn() {
    use step <- promise.map(yielder.pull())
    case step {
      Done -> Done
      Next(value, rest) -> Next(#(value, next), index_loop(rest, next + 1))
    }
  })
}

/// Yields each value of `yielder` with `elem` inserted between
/// consecutive values. No trailing `elem`.
///
pub fn intersperse(
  over yielder: AsyncYielder(a),
  with elem: a,
) -> AsyncYielder(a) {
  AsyncYielder(pull: fn() {
    use step <- promise.map(yielder.pull())
    case step {
      Done -> Done
      Next(value, rest) -> Next(value, intersperse_loop(rest, elem))
    }
  })
}

fn intersperse_loop(yielder: AsyncYielder(a), elem: a) -> AsyncYielder(a) {
  AsyncYielder(pull: fn() {
    use step <- promise.map(yielder.pull())
    case step {
      Done -> Done
      Next(value, rest) ->
        Next(elem, yield(value, fn() { intersperse_loop(rest, elem) }))
    }
  })
}

/// Stateful map: threads `initial` through `fun(acc, value)`, which
/// returns the next [`Step`](#Step). `Next(emit, new_acc)` yields
/// `emit` and continues with `new_acc`; `Done` ends the yielder early.
///
pub fn transform(
  over yielder: AsyncYielder(a),
  from initial: acc,
  with fun: fn(acc, a) -> Step(b, acc),
) -> AsyncYielder(b) {
  AsyncYielder(pull: fn() { transform_loop(yielder, initial, fun) })
}

fn transform_loop(
  yielder: AsyncYielder(a),
  initial: acc,
  fun: fn(acc, a) -> Step(b, acc),
) -> Promise(Step(b, AsyncYielder(b))) {
  use step <- promise.await(yielder.pull())
  case step {
    Done -> promise.resolve(Done)
    Next(value, rest) ->
      case fun(initial, value) {
        Done -> promise.resolve(Done)
        Next(emit, new_acc) ->
          promise.resolve(Next(emit, transform(rest, new_acc, fun)))
      }
  }
}

/// Like [`transform`](#transform) but `fun` returns a `Promise`. Each
/// call is awaited before the next.
///
pub fn transform_async(
  over yielder: AsyncYielder(a),
  from initial: acc,
  with fun: fn(acc, a) -> Promise(Step(b, acc)),
) -> AsyncYielder(b) {
  AsyncYielder(pull: fn() { transform_async_loop(yielder, initial, fun) })
}

fn transform_async_loop(
  yielder: AsyncYielder(a),
  initial: acc,
  fun: fn(acc, a) -> Promise(Step(b, acc)),
) -> Promise(Step(b, AsyncYielder(b))) {
  use step <- promise.await(yielder.pull())
  case step {
    Done -> promise.resolve(Done)
    Next(value, rest) -> {
      use transform_step <- promise.map(fun(initial, value))
      case transform_step {
        Done -> Done
        Next(emit, new_acc) -> Next(emit, transform_async(rest, new_acc, fun))
      }
    }
  }
}

/// Yields the first `desired` values of `yielder`, then stops. If
/// `desired` is non-positive, yields nothing.
///
pub fn take(
  from yielder: AsyncYielder(a),
  up_to desired: Int,
) -> AsyncYielder(a) {
  AsyncYielder(pull: fn() {
    case desired > 0 {
      False -> promise.resolve(Done)
      True -> {
        use step <- promise.map(yielder.pull())
        case step {
          Done -> Done
          Next(value, rest) -> Next(value, take(rest, desired - 1))
        }
      }
    }
  })
}

/// Skips the first `desired` values of `yielder`, then yields the
/// rest. If `desired` is non-positive, yields all values.
///
pub fn drop(
  from yielder: AsyncYielder(a),
  up_to desired: Int,
) -> AsyncYielder(a) {
  AsyncYielder(pull: fn() { drop_loop(yielder, desired) })
}

fn drop_loop(
  yielder: AsyncYielder(a),
  desired: Int,
) -> Promise(Step(a, AsyncYielder(a))) {
  case desired > 0 {
    False -> yielder.pull()
    True -> {
      use step <- promise.await(yielder.pull())
      case step {
        Done -> promise.resolve(Done)
        Next(_, rest) -> drop_loop(rest, desired - 1)
      }
    }
  }
}

/// Yields values from `yielder` while `predicate` returns `True`, then
/// stops at the first value for which it returns `False`.
///
pub fn take_while(
  in yielder: AsyncYielder(a),
  satisfying predicate: fn(a) -> Bool,
) -> AsyncYielder(a) {
  AsyncYielder(pull: fn() { take_while_loop(yielder, predicate) })
}

fn take_while_loop(
  yielder: AsyncYielder(a),
  predicate: fn(a) -> Bool,
) -> Promise(Step(a, AsyncYielder(a))) {
  use step <- promise.await(yielder.pull())
  case step {
    Done -> promise.resolve(Done)
    Next(value, rest) ->
      case predicate(value) {
        True -> promise.resolve(Next(value, take_while(rest, predicate)))
        False -> promise.resolve(Done)
      }
  }
}

/// Like [`take_while`](#take_while) but `predicate` returns a
/// `Promise`. Each call is awaited before the next.
///
pub fn take_while_async(
  in yielder: AsyncYielder(a),
  satisfying predicate: fn(a) -> Promise(Bool),
) -> AsyncYielder(a) {
  AsyncYielder(pull: fn() { take_while_async_loop(yielder, predicate) })
}

fn take_while_async_loop(
  yielder: AsyncYielder(a),
  predicate: fn(a) -> Promise(Bool),
) -> Promise(Step(a, AsyncYielder(a))) {
  use step <- promise.await(yielder.pull())
  case step {
    Done -> promise.resolve(Done)
    Next(value, rest) -> {
      use keep <- promise.await(predicate(value))
      case keep {
        True -> promise.resolve(Next(value, take_while_async(rest, predicate)))
        False -> promise.resolve(Done)
      }
    }
  }
}

/// Skips values from `yielder` while `predicate` returns `True`, then
/// yields the rest starting from the first value for which it returns
/// `False`.
///
pub fn drop_while(
  in yielder: AsyncYielder(a),
  satisfying predicate: fn(a) -> Bool,
) -> AsyncYielder(a) {
  AsyncYielder(pull: fn() { drop_while_loop(yielder, predicate) })
}

fn drop_while_loop(
  yielder: AsyncYielder(a),
  predicate: fn(a) -> Bool,
) -> Promise(Step(a, AsyncYielder(a))) {
  use step <- promise.await(yielder.pull())
  case step {
    Done -> promise.resolve(Done)
    Next(value, rest) ->
      case predicate(value) {
        True -> drop_while_loop(rest, predicate)
        False -> promise.resolve(Next(value, rest))
      }
  }
}

/// Like [`drop_while`](#drop_while) but `predicate` returns a
/// `Promise`. Each call is awaited before the next.
///
pub fn drop_while_async(
  in yielder: AsyncYielder(a),
  satisfying predicate: fn(a) -> Promise(Bool),
) -> AsyncYielder(a) {
  AsyncYielder(pull: fn() { drop_while_async_loop(yielder, predicate) })
}

fn drop_while_async_loop(
  yielder: AsyncYielder(a),
  predicate: fn(a) -> Promise(Bool),
) -> Promise(Step(a, AsyncYielder(a))) {
  use step <- promise.await(yielder.pull())
  case step {
    Done -> promise.resolve(Done)
    Next(value, rest) -> {
      use drop_it <- promise.await(predicate(value))
      case drop_it {
        True -> drop_while_async_loop(rest, predicate)
        False -> promise.resolve(Next(value, rest))
      }
    }
  }
}

/// Drains the yielder, collecting all yielded values into a list.
///
pub fn to_list(yielder: AsyncYielder(a)) -> Promise(List(a)) {
  use step <- promise.await(yielder.pull())
  case step {
    Done -> promise.resolve([])
    Next(value, rest) -> {
      use rest_list <- promise.map(to_list(rest))
      [value, ..rest_list]
    }
  }
}

/// Drains the yielder, calling `fun` on each yielded value.
///
pub fn each(
  over yielder: AsyncYielder(a),
  with fun: fn(a) -> b,
) -> Promise(Nil) {
  use step <- promise.await(yielder.pull())
  case step {
    Done -> promise.resolve(Nil)
    Next(value, rest) -> {
      fun(value)
      each(rest, fun)
    }
  }
}

/// Like [`each`](#each) but `fun` returns a `Promise`. Each call is
/// awaited before the next.
///
pub fn each_async(
  over yielder: AsyncYielder(a),
  with fun: fn(a) -> Promise(b),
) -> Promise(Nil) {
  use step <- promise.await(yielder.pull())
  case step {
    Done -> promise.resolve(Nil)
    Next(value, rest) -> {
      use _ <- promise.await(fun(value))
      each_async(rest, fun)
    }
  }
}
