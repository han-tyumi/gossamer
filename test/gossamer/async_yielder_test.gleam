import gleam/javascript/promise
import gleeunit/should
import gossamer/iteration/async_yielder

pub fn from_list_to_list_test() {
  let yielder = async_yielder.from_list([1, 2, 3])
  use result <- promise.map(async_yielder.to_list(yielder))
  should.equal(result, Ok([1, 2, 3]))
}

pub fn empty_to_list_test() {
  let yielder = async_yielder.empty()
  use result <- promise.map(async_yielder.to_list(yielder))
  should.equal(result, Ok([]))
}

pub fn map_test() {
  let result =
    async_yielder.from_list([1, 2, 3])
    |> async_yielder.map(with: fn(x) { x * 2 })
    |> async_yielder.to_list
  use result <- promise.map(result)
  should.equal(result, Ok([2, 4, 6]))
}

pub fn filter_test() {
  let result =
    async_yielder.from_list([1, 2, 3, 4, 5])
    |> async_yielder.filter(keeping: fn(x) { x > 2 })
    |> async_yielder.to_list
  use result <- promise.map(result)
  should.equal(result, Ok([3, 4, 5]))
}

pub fn map_then_filter_test() {
  let result =
    async_yielder.from_list([1, 2, 3, 4, 5])
    |> async_yielder.map(with: fn(x) { x * 2 })
    |> async_yielder.filter(keeping: fn(x) { x > 4 })
    |> async_yielder.to_list
  use result <- promise.map(result)
  should.equal(result, Ok([6, 8, 10]))
}

pub fn step_advances_test() {
  use step <- promise.await(async_yielder.step(async_yielder.from_list([1, 2])))
  case step {
    async_yielder.Done -> {
      should.fail()
      promise.resolve(Nil)
    }
    async_yielder.Next(value, rest) -> {
      should.equal(value, 1)
      use step <- promise.map(async_yielder.step(rest))
      case step {
        async_yielder.Done -> should.fail()
        async_yielder.Next(value, _) -> should.equal(value, 2)
      }
    }
  }
}

pub fn step_done_on_empty_test() {
  use step <- promise.map(async_yielder.step(async_yielder.empty()))
  case step {
    async_yielder.Done -> Nil
    async_yielder.Next(_, _) -> should.fail()
  }
}

pub fn map_async_test() {
  let result =
    async_yielder.from_list([1, 2, 3])
    |> async_yielder.map_async(with: fn(x) { promise.resolve(x * 2) })
    |> async_yielder.to_list
  use result <- promise.map(result)
  should.equal(result, Ok([2, 4, 6]))
}

pub fn filter_async_test() {
  let result =
    async_yielder.from_list([1, 2, 3, 4, 5])
    |> async_yielder.filter_async(keeping: fn(x) { promise.resolve(x > 2) })
    |> async_yielder.to_list
  use result <- promise.map(result)
  should.equal(result, Ok([3, 4, 5]))
}

pub fn each_async_test() {
  let result =
    async_yielder.from_list([1, 2, 3])
    |> async_yielder.each_async(with: fn(_) { promise.resolve(Nil) })
  use result <- promise.map(result)
  should.equal(result, Ok(Nil))
}

pub fn single_test() {
  let result =
    async_yielder.single(42)
    |> async_yielder.to_list
  use result <- promise.map(result)
  should.equal(result, Ok([42]))
}

pub fn once_test() {
  let result =
    async_yielder.once(fn() { 7 })
    |> async_yielder.to_list
  use result <- promise.map(result)
  should.equal(result, Ok([7]))
}

pub fn once_async_test() {
  let result =
    async_yielder.once_async(fn() { promise.resolve(7) })
    |> async_yielder.to_list
  use result <- promise.map(result)
  should.equal(result, Ok([7]))
}

pub fn range_ascending_test() {
  let result =
    async_yielder.range(from: 1, to: 4)
    |> async_yielder.to_list
  use result <- promise.map(result)
  should.equal(result, Ok([1, 2, 3, 4]))
}

pub fn range_descending_test() {
  let result =
    async_yielder.range(from: 3, to: 0)
    |> async_yielder.to_list
  use result <- promise.map(result)
  should.equal(result, Ok([3, 2, 1, 0]))
}

pub fn range_eq_test() {
  let result =
    async_yielder.range(from: 5, to: 5)
    |> async_yielder.to_list
  use result <- promise.map(result)
  should.equal(result, Ok([5]))
}

pub fn unfold_test() {
  let result =
    async_yielder.unfold(from: 0, with: fn(n) {
      case n < 3 {
        True -> async_yielder.Next(n, n + 1)
        False -> async_yielder.Done
      }
    })
    |> async_yielder.to_list
  use result <- promise.map(result)
  should.equal(result, Ok([0, 1, 2]))
}

pub fn unfold_async_test() {
  let result =
    async_yielder.unfold_async(from: 0, with: fn(n) {
      case n < 3 {
        True -> promise.resolve(async_yielder.Next(n, n + 1))
        False -> promise.resolve(async_yielder.Done)
      }
    })
    |> async_yielder.to_list
  use result <- promise.map(result)
  should.equal(result, Ok([0, 1, 2]))
}

pub fn yield_test() {
  let result =
    async_yielder.yield(1, fn() { async_yielder.from_list([2, 3]) })
    |> async_yielder.to_list
  use result <- promise.map(result)
  should.equal(result, Ok([1, 2, 3]))
}

pub fn yield_async_test() {
  let result =
    async_yielder.yield_async(1, fn() {
      promise.resolve(async_yielder.from_list([2, 3]))
    })
    |> async_yielder.to_list
  use result <- promise.map(result)
  should.equal(result, Ok([1, 2, 3]))
}

pub fn prepend_test() {
  let result =
    async_yielder.from_list([2, 3])
    |> async_yielder.prepend(1)
    |> async_yielder.to_list
  use result <- promise.map(result)
  should.equal(result, Ok([1, 2, 3]))
}

pub fn unfold_async_propagates_rejection_test() {
  let rejecting =
    async_yielder.unfold_async(from: 0, with: fn(_) {
      use _ <- promise.await(promise.resolve(Nil))
      panic as "boom"
    })
  use result <- promise.map(async_yielder.to_list(rejecting))
  should.be_error(result)
}

pub fn map_propagates_rejection_test() {
  let rejecting =
    async_yielder.unfold_async(from: 0, with: fn(_) {
      use _ <- promise.await(promise.resolve(Nil))
      panic as "boom"
    })
  let doubled = async_yielder.map(rejecting, with: fn(x) { x * 2 })
  use result <- promise.map(async_yielder.to_list(doubled))
  should.be_error(result)
}
