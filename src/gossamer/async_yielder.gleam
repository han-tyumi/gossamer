//// A pull-based async iteration type implemented in pure Gleam. The
//// canonical type for iterating over `Promise`-yielding sources;
//// mirrors `gleam_yielder.Yielder` for async iteration.
////
//// Callback-taking operations come in paired sync (`map`, `filter`,
//// `each`, …) and async (`map_async`, `filter_async`, `each_async`, …)
//// twins; the `_async` twin accepts a `Promise`-returning callback.
//// Fallible operations should be expressed via `Result` inside the
//// promise, following gleam_javascript convention.

import gleam/dict.{type Dict}
import gleam/int
import gleam/javascript/promise.{type Promise}
import gleam/list
import gleam/option.{None, Some}
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

/// An async yielder that yields `fun()` infinitely.
///
pub fn repeatedly(fun: fn() -> a) -> AsyncYielder(a) {
  unfold(Nil, fn(_) { Next(fun(), Nil) })
}

/// Like [`repeatedly`](#repeatedly) but `fun` returns a `Promise`.
/// Each call is awaited before the next.
///
pub fn repeatedly_async(fun: fn() -> Promise(a)) -> AsyncYielder(a) {
  unfold_async(Nil, fn(_) {
    use value <- promise.map(fun())
    Next(value, Nil)
  })
}

/// An async yielder that yields `x` infinitely.
///
pub fn repeat(x: a) -> AsyncYielder(a) {
  repeatedly(fn() { x })
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

/// Constructs an async yielder by repeatedly applying `fun` to the
/// previous value, starting from `initial`. The yielder is infinite.
///
pub fn iterate(from initial: a, with fun: fn(a) -> a) -> AsyncYielder(a) {
  unfold(from: initial, with: fn(element) { Next(element, fun(element)) })
}

/// Like [`iterate`](#iterate) but `fun` returns a `Promise`. Each call
/// is awaited before the next.
///
pub fn iterate_async(
  from initial: a,
  with fun: fn(a) -> Promise(a),
) -> AsyncYielder(a) {
  unfold_async(from: initial, with: fn(element) {
    use next <- promise.map(fun(element))
    Next(element, next)
  })
}

/// Yields `element` followed by whatever `next()` produces. `next()`
/// is only called when the yielder is pulled past `element`.
///
pub fn yield(element: a, next: fn() -> AsyncYielder(a)) -> AsyncYielder(a) {
  AsyncYielder(pull: fn() {
    promise.resolve(Next(element, AsyncYielder(pull: fn() { next().pull() })))
  })
}

/// Like [`yield`](#yield) but `next` returns a `Promise`. The promise
/// is awaited when the yielder is pulled past `element`.
///
pub fn yield_async(
  element: a,
  next: fn() -> Promise(AsyncYielder(a)),
) -> AsyncYielder(a) {
  AsyncYielder(pull: fn() {
    promise.resolve(Next(
      element,
      AsyncYielder(pull: fn() {
        use rest <- promise.await(next())
        rest.pull()
      }),
    ))
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

/// Repeats `yielder` infinitely, restarting from the beginning each
/// round. Pair with [`take`](#take) to bound it. Cycling an empty
/// yielder yields nothing and never halts, so don't fully drain it.
///
pub fn cycle(yielder: AsyncYielder(a)) -> AsyncYielder(a) {
  repeat(yielder) |> flatten
}

/// Yields pairs of corresponding elements from `left` and `right`,
/// stopping when either runs out.
///
pub fn zip(
  left: AsyncYielder(a),
  right: AsyncYielder(b),
) -> AsyncYielder(#(a, b)) {
  AsyncYielder(pull: fn() {
    use left_step <- promise.await(left.pull())
    case left_step {
      Done -> promise.resolve(Done)
      Next(left_value, left_rest) -> {
        use right_step <- promise.map(right.pull())
        case right_step {
          Done -> Done
          Next(right_value, right_rest) ->
            Next(#(left_value, right_value), zip(left_rest, right_rest))
        }
      }
    }
  })
}

/// Yields the result of `fun(left_value, right_value)` for each
/// corresponding pair from `yielder1` and `yielder2`, stopping when
/// either runs out.
///
pub fn map2(
  yielder1: AsyncYielder(a),
  yielder2: AsyncYielder(b),
  with fun: fn(a, b) -> c,
) -> AsyncYielder(c) {
  zip(yielder1, yielder2) |> map(fn(pair) { fun(pair.0, pair.1) })
}

/// Like [`map2`](#map2) but `fun` returns a `Promise`. Each call is
/// awaited before the next.
///
pub fn map2_async(
  yielder1: AsyncYielder(a),
  yielder2: AsyncYielder(b),
  with fun: fn(a, b) -> Promise(c),
) -> AsyncYielder(c) {
  zip(yielder1, yielder2) |> map_async(fn(pair) { fun(pair.0, pair.1) })
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

/// Alternates yielding values from `left` and `right`. When one side
/// is exhausted, continues with whatever remains of the other.
///
pub fn interleave(
  left: AsyncYielder(a),
  with right: AsyncYielder(a),
) -> AsyncYielder(a) {
  AsyncYielder(pull: fn() { interleave_loop(left, right) })
}

fn interleave_loop(
  current: AsyncYielder(a),
  next: AsyncYielder(a),
) -> Promise(Step(a, AsyncYielder(a))) {
  use step <- promise.await(current.pull())
  case step {
    Done -> next.pull()
    Next(value, current_rest) ->
      promise.resolve(Next(
        value,
        AsyncYielder(pull: fn() { interleave_loop(next, current_rest) }),
      ))
  }
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

/// Reduces the yielder to a single value by repeatedly applying
/// `fun` to an accumulator and each yielded value, starting with
/// `initial`.
///
pub fn fold(
  over yielder: AsyncYielder(a),
  from initial: acc,
  with fun: fn(acc, a) -> acc,
) -> Promise(acc) {
  use step <- promise.await(yielder.pull())
  case step {
    Done -> promise.resolve(initial)
    Next(value, rest) -> fold(rest, fun(initial, value), fun)
  }
}

/// Like [`fold`](#fold) but `fun` returns a `Promise`. Each call is
/// awaited before the next.
///
pub fn fold_async(
  over yielder: AsyncYielder(a),
  from initial: acc,
  with fun: fn(acc, a) -> Promise(acc),
) -> Promise(acc) {
  use step <- promise.await(yielder.pull())
  case step {
    Done -> promise.resolve(initial)
    Next(value, rest) -> {
      use new_acc <- promise.await(fun(initial, value))
      fold_async(rest, new_acc, fun)
    }
  }
}

/// Drains the yielder, discarding all values.
///
pub fn run(yielder: AsyncYielder(a)) -> Promise(Nil) {
  fold(yielder, Nil, fn(_, _) { Nil })
}

/// Counts the elements in the yielder by draining it.
///
pub fn length(over yielder: AsyncYielder(a)) -> Promise(Int) {
  fold(yielder, 0, fn(count, _) { count + 1 })
}

/// Returns the first value of the yielder, or `Error(Nil)` if it's
/// empty.
///
pub fn first(from yielder: AsyncYielder(a)) -> Promise(Result(a, Nil)) {
  use step <- promise.await(yielder.pull())
  case step {
    Done -> promise.resolve(Error(Nil))
    Next(value, _) -> promise.resolve(Ok(value))
  }
}

/// Reduces the yielder to a single value by repeatedly applying
/// `fun` to two values, starting with the first two. Returns
/// `Error(Nil)` if the yielder is empty.
///
pub fn reduce(
  over yielder: AsyncYielder(a),
  with fun: fn(a, a) -> a,
) -> Promise(Result(a, Nil)) {
  use step <- promise.await(yielder.pull())
  case step {
    Done -> promise.resolve(Error(Nil))
    Next(first, rest) -> {
      use folded <- promise.map(fold(rest, first, fun))
      Ok(folded)
    }
  }
}

/// Like [`reduce`](#reduce) but `fun` returns a `Promise`. Each call
/// is awaited before the next.
///
pub fn reduce_async(
  over yielder: AsyncYielder(a),
  with fun: fn(a, a) -> Promise(a),
) -> Promise(Result(a, Nil)) {
  use step <- promise.await(yielder.pull())
  case step {
    Done -> promise.resolve(Error(Nil))
    Next(first, rest) -> {
      use folded <- promise.map(fold_async(rest, first, fun))
      Ok(folded)
    }
  }
}

/// Returns the last value of the yielder, or `Error(Nil)` if it's
/// empty. Drains the yielder.
///
pub fn last(yielder: AsyncYielder(a)) -> Promise(Result(a, Nil)) {
  reduce(yielder, fn(_, elem) { elem })
}

/// Returns the value at zero-based `index`, or `Error(Nil)` if the
/// yielder has fewer than `index + 1` values.
///
pub fn at(
  in yielder: AsyncYielder(a),
  get index: Int,
) -> Promise(Result(a, Nil)) {
  yielder
  |> drop(up_to: index)
  |> first
}

/// Like [`fold`](#fold) but `fun` can stop the iteration early by
/// returning `list.Stop(acc)`; `list.Continue(acc)` proceeds with the
/// new accumulator.
///
pub fn fold_until(
  over yielder: AsyncYielder(a),
  from initial: acc,
  with fun: fn(acc, a) -> list.ContinueOrStop(acc),
) -> Promise(acc) {
  use step <- promise.await(yielder.pull())
  case step {
    Done -> promise.resolve(initial)
    Next(value, rest) ->
      case fun(initial, value) {
        list.Continue(new_acc) -> fold_until(rest, new_acc, fun)
        list.Stop(final_acc) -> promise.resolve(final_acc)
      }
  }
}

/// Like [`fold_until`](#fold_until) but `fun` returns a `Promise`.
/// Each call is awaited before the next.
///
pub fn fold_until_async(
  over yielder: AsyncYielder(a),
  from initial: acc,
  with fun: fn(acc, a) -> Promise(list.ContinueOrStop(acc)),
) -> Promise(acc) {
  use step <- promise.await(yielder.pull())
  case step {
    Done -> promise.resolve(initial)
    Next(value, rest) -> {
      use decision <- promise.await(fun(initial, value))
      case decision {
        list.Continue(new_acc) -> fold_until_async(rest, new_acc, fun)
        list.Stop(final_acc) -> promise.resolve(final_acc)
      }
    }
  }
}

/// Like [`fold`](#fold) but `fun` returns a `Result`; an `Error`
/// halts iteration and surfaces as the overall `Error`.
///
pub fn try_fold(
  over yielder: AsyncYielder(a),
  from initial: acc,
  with fun: fn(acc, a) -> Result(acc, err),
) -> Promise(Result(acc, err)) {
  use step <- promise.await(yielder.pull())
  case step {
    Done -> promise.resolve(Ok(initial))
    Next(value, rest) ->
      case fun(initial, value) {
        Ok(new_acc) -> try_fold(rest, new_acc, fun)
        Error(e) -> promise.resolve(Error(e))
      }
  }
}

/// Like [`try_fold`](#try_fold) but `fun` returns a `Promise`. Each
/// call is awaited before the next.
///
pub fn try_fold_async(
  over yielder: AsyncYielder(a),
  from initial: acc,
  with fun: fn(acc, a) -> Promise(Result(acc, err)),
) -> Promise(Result(acc, err)) {
  use step <- promise.await(yielder.pull())
  case step {
    Done -> promise.resolve(Ok(initial))
    Next(value, rest) -> {
      use result <- promise.await(fun(initial, value))
      case result {
        Ok(new_acc) -> try_fold_async(rest, new_acc, fun)
        Error(e) -> promise.resolve(Error(e))
      }
    }
  }
}

/// Returns `True` if `predicate` returns `True` for any value of
/// `yielder`. Stops at the first match.
///
pub fn any(
  in yielder: AsyncYielder(a),
  satisfying predicate: fn(a) -> Bool,
) -> Promise(Bool) {
  use step <- promise.await(yielder.pull())
  case step {
    Done -> promise.resolve(False)
    Next(value, rest) ->
      case predicate(value) {
        True -> promise.resolve(True)
        False -> any(rest, predicate)
      }
  }
}

/// Like [`any`](#any) but `predicate` returns a `Promise`. Each call
/// is awaited before the next.
///
pub fn any_async(
  in yielder: AsyncYielder(a),
  satisfying predicate: fn(a) -> Promise(Bool),
) -> Promise(Bool) {
  use step <- promise.await(yielder.pull())
  case step {
    Done -> promise.resolve(False)
    Next(value, rest) -> {
      use matched <- promise.await(predicate(value))
      case matched {
        True -> promise.resolve(True)
        False -> any_async(rest, predicate)
      }
    }
  }
}

/// Returns `True` if `predicate` returns `True` for every value of
/// `yielder`. Stops at the first non-match.
///
pub fn all(
  in yielder: AsyncYielder(a),
  satisfying predicate: fn(a) -> Bool,
) -> Promise(Bool) {
  use step <- promise.await(yielder.pull())
  case step {
    Done -> promise.resolve(True)
    Next(value, rest) ->
      case predicate(value) {
        False -> promise.resolve(False)
        True -> all(rest, predicate)
      }
  }
}

/// Like [`all`](#all) but `predicate` returns a `Promise`. Each call
/// is awaited before the next.
///
pub fn all_async(
  in yielder: AsyncYielder(a),
  satisfying predicate: fn(a) -> Promise(Bool),
) -> Promise(Bool) {
  use step <- promise.await(yielder.pull())
  case step {
    Done -> promise.resolve(True)
    Next(value, rest) -> {
      use matched <- promise.await(predicate(value))
      case matched {
        False -> promise.resolve(False)
        True -> all_async(rest, predicate)
      }
    }
  }
}

/// Returns the first value of `haystack` for which `is_desired`
/// returns `True`, or `Error(Nil)` if none match.
///
pub fn find(
  in haystack: AsyncYielder(a),
  one_that is_desired: fn(a) -> Bool,
) -> Promise(Result(a, Nil)) {
  use step <- promise.await(haystack.pull())
  case step {
    Done -> promise.resolve(Error(Nil))
    Next(value, rest) ->
      case is_desired(value) {
        True -> promise.resolve(Ok(value))
        False -> find(rest, is_desired)
      }
  }
}

/// Like [`find`](#find) but `is_desired` returns a `Promise`. Each
/// call is awaited before the next.
///
pub fn find_async(
  in haystack: AsyncYielder(a),
  one_that is_desired: fn(a) -> Promise(Bool),
) -> Promise(Result(a, Nil)) {
  use step <- promise.await(haystack.pull())
  case step {
    Done -> promise.resolve(Error(Nil))
    Next(value, rest) -> {
      use found <- promise.await(is_desired(value))
      case found {
        True -> promise.resolve(Ok(value))
        False -> find_async(rest, is_desired)
      }
    }
  }
}

/// Returns the first `Ok` result of applying `is_desired` to values
/// of `haystack`, or `Error(Nil)` if every call returns `Error`.
///
pub fn find_map(
  in haystack: AsyncYielder(a),
  one_that is_desired: fn(a) -> Result(b, c),
) -> Promise(Result(b, Nil)) {
  use step <- promise.await(haystack.pull())
  case step {
    Done -> promise.resolve(Error(Nil))
    Next(value, rest) ->
      case is_desired(value) {
        Ok(mapped) -> promise.resolve(Ok(mapped))
        Error(_) -> find_map(rest, is_desired)
      }
  }
}

/// Like [`find_map`](#find_map) but `is_desired` returns a `Promise`.
/// Each call is awaited before the next.
///
pub fn find_map_async(
  in haystack: AsyncYielder(a),
  one_that is_desired: fn(a) -> Promise(Result(b, c)),
) -> Promise(Result(b, Nil)) {
  use step <- promise.await(haystack.pull())
  case step {
    Done -> promise.resolve(Error(Nil))
    Next(value, rest) -> {
      use result <- promise.await(is_desired(value))
      case result {
        Ok(mapped) -> promise.resolve(Ok(mapped))
        Error(_) -> find_map_async(rest, is_desired)
      }
    }
  }
}

/// Groups consecutive values of `yielder` that share the same key
/// (computed by `fun`) into lists.
///
pub fn chunk(
  over yielder: AsyncYielder(a),
  by fun: fn(a) -> key,
) -> AsyncYielder(List(a)) {
  AsyncYielder(pull: fn() {
    use step <- promise.await(yielder.pull())
    case step {
      Done -> promise.resolve(Done)
      Next(first_value, rest) ->
        chunk_loop(rest, fun, fun(first_value), [first_value])
    }
  })
}

fn chunk_loop(
  yielder: AsyncYielder(a),
  fun: fn(a) -> key,
  current_key: key,
  current_chunk: List(a),
) -> Promise(Step(List(a), AsyncYielder(List(a)))) {
  use step <- promise.await(yielder.pull())
  case step {
    Done -> promise.resolve(Next(list.reverse(current_chunk), empty()))
    Next(value, rest) -> {
      let value_key = fun(value)
      case value_key == current_key {
        True -> chunk_loop(rest, fun, current_key, [value, ..current_chunk])
        False ->
          promise.resolve(Next(
            list.reverse(current_chunk),
            AsyncYielder(pull: fn() {
              chunk_loop(rest, fun, value_key, [value])
            }),
          ))
      }
    }
  }
}

/// Like [`chunk`](#chunk) but `fun` returns a `Promise`. Each call is
/// awaited before the next.
///
pub fn chunk_async(
  over yielder: AsyncYielder(a),
  by fun: fn(a) -> Promise(key),
) -> AsyncYielder(List(a)) {
  AsyncYielder(pull: fn() {
    use step <- promise.await(yielder.pull())
    case step {
      Done -> promise.resolve(Done)
      Next(first_value, rest) -> {
        use first_key <- promise.await(fun(first_value))
        chunk_async_loop(rest, fun, first_key, [first_value])
      }
    }
  })
}

fn chunk_async_loop(
  yielder: AsyncYielder(a),
  fun: fn(a) -> Promise(key),
  current_key: key,
  current_chunk: List(a),
) -> Promise(Step(List(a), AsyncYielder(List(a)))) {
  use step <- promise.await(yielder.pull())
  case step {
    Done -> promise.resolve(Next(list.reverse(current_chunk), empty()))
    Next(value, rest) -> {
      use value_key <- promise.await(fun(value))
      case value_key == current_key {
        True ->
          chunk_async_loop(rest, fun, current_key, [value, ..current_chunk])
        False ->
          promise.resolve(Next(
            list.reverse(current_chunk),
            AsyncYielder(pull: fn() {
              chunk_async_loop(rest, fun, value_key, [value])
            }),
          ))
      }
    }
  }
}

/// Splits `yielder` into fixed-size lists. The final list may be
/// shorter than `count`. For any `count` less than 1 this function
/// behaves as if it was set to 1.
///
pub fn sized_chunk(
  over yielder: AsyncYielder(a),
  into count: Int,
) -> AsyncYielder(List(a)) {
  let count = int.max(count, 1)
  AsyncYielder(pull: fn() { sized_chunk_loop(yielder, count, [], count) })
}

fn sized_chunk_loop(
  yielder: AsyncYielder(a),
  count: Int,
  current_chunk: List(a),
  remaining: Int,
) -> Promise(Step(List(a), AsyncYielder(List(a)))) {
  case remaining {
    0 ->
      promise.resolve(Next(
        list.reverse(current_chunk),
        AsyncYielder(pull: fn() { sized_chunk_loop(yielder, count, [], count) }),
      ))
    _ -> {
      use step <- promise.await(yielder.pull())
      case step {
        Done ->
          case current_chunk {
            [] -> promise.resolve(Done)
            _ -> promise.resolve(Next(list.reverse(current_chunk), empty()))
          }
        Next(value, rest) ->
          sized_chunk_loop(rest, count, [value, ..current_chunk], remaining - 1)
      }
    }
  }
}

/// Drains the yielder and groups its values into a [`Dict`](https://hexdocs.pm/gleam_stdlib/gleam/dict.html)
/// keyed by `key(value)`, with each key's values in the order they
/// were yielded.
///
pub fn group(
  in yielder: AsyncYielder(a),
  by key: fn(a) -> key,
) -> Promise(Dict(key, List(a))) {
  use grouped <- promise.map(
    fold(yielder, dict.new(), fn(acc, value) {
      dict.upsert(acc, key(value), fn(existing) {
        case existing {
          Some(values) -> [value, ..values]
          None -> [value]
        }
      })
    }),
  )
  dict.map_values(grouped, fn(_, values) { list.reverse(values) })
}

/// Like [`group`](#group) but `key` returns a `Promise`. Each call is
/// awaited before the next.
///
pub fn group_async(
  in yielder: AsyncYielder(a),
  by key: fn(a) -> Promise(key),
) -> Promise(Dict(key, List(a))) {
  use grouped <- promise.map(
    fold_async(yielder, dict.new(), fn(acc, value) {
      use k <- promise.map(key(value))
      dict.upsert(acc, k, fn(existing) {
        case existing {
          Some(values) -> [value, ..values]
          None -> [value]
        }
      })
    }),
  )
  dict.map_values(grouped, fn(_, values) { list.reverse(values) })
}

/// Drains the yielder, collecting all yielded values into a list.
///
pub fn to_list(yielder: AsyncYielder(a)) -> Promise(List(a)) {
  use reversed <- promise.map(
    fold(yielder, [], fn(acc, value) { [value, ..acc] }),
  )
  list.reverse(reversed)
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
