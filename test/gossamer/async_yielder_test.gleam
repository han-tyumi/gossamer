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

pub fn each_test() {
  let result =
    async_yielder.from_list([1, 2, 3])
    |> async_yielder.each(with: fn(_) { Nil })
  use result <- promise.map(result)
  should.equal(result, Ok(Nil))
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

pub fn append_test() {
  let result =
    async_yielder.append(
      to: async_yielder.from_list([1, 2]),
      suffix: async_yielder.from_list([3, 4]),
    )
    |> async_yielder.to_list
  use result <- promise.map(result)
  should.equal(result, Ok([1, 2, 3, 4]))
}

pub fn append_empty_first_test() {
  let result =
    async_yielder.append(
      to: async_yielder.empty(),
      suffix: async_yielder.from_list([1, 2]),
    )
    |> async_yielder.to_list
  use result <- promise.map(result)
  should.equal(result, Ok([1, 2]))
}

pub fn append_empty_second_test() {
  let result =
    async_yielder.append(
      to: async_yielder.from_list([1, 2]),
      suffix: async_yielder.empty(),
    )
    |> async_yielder.to_list
  use result <- promise.map(result)
  should.equal(result, Ok([1, 2]))
}

pub fn flatten_test() {
  let result =
    async_yielder.from_list([
      async_yielder.from_list([1, 2]),
      async_yielder.from_list([3, 4]),
    ])
    |> async_yielder.flatten
    |> async_yielder.to_list
  use result <- promise.map(result)
  should.equal(result, Ok([1, 2, 3, 4]))
}

pub fn flatten_with_empty_inner_test() {
  let result =
    async_yielder.from_list([
      async_yielder.from_list([1]),
      async_yielder.empty(),
      async_yielder.from_list([2]),
    ])
    |> async_yielder.flatten
    |> async_yielder.to_list
  use result <- promise.map(result)
  should.equal(result, Ok([1, 2]))
}

pub fn concat_test() {
  let result =
    async_yielder.concat([
      async_yielder.from_list([1, 2]),
      async_yielder.from_list([3, 4]),
    ])
    |> async_yielder.to_list
  use result <- promise.map(result)
  should.equal(result, Ok([1, 2, 3, 4]))
}

pub fn concat_empty_test() {
  let result =
    async_yielder.concat([])
    |> async_yielder.to_list
  use result <- promise.map(result)
  should.equal(result, Ok([]))
}

pub fn flat_map_test() {
  let result =
    async_yielder.from_list([1, 2, 3])
    |> async_yielder.flat_map(with: fn(x) {
      async_yielder.from_list([x, x * 10])
    })
    |> async_yielder.to_list
  use result <- promise.map(result)
  should.equal(result, Ok([1, 10, 2, 20, 3, 30]))
}

pub fn flat_map_async_test() {
  let result =
    async_yielder.from_list([1, 2])
    |> async_yielder.flat_map_async(with: fn(x) {
      promise.resolve(async_yielder.from_list([x, x * 10]))
    })
    |> async_yielder.to_list
  use result <- promise.map(result)
  should.equal(result, Ok([1, 10, 2, 20]))
}

pub fn filter_map_test() {
  let result =
    async_yielder.from_list([1, 2, 3, 4])
    |> async_yielder.filter_map(keeping_with: fn(x) {
      case x % 2 == 0 {
        True -> Ok(x * 10)
        False -> Error(Nil)
      }
    })
    |> async_yielder.to_list
  use result <- promise.map(result)
  should.equal(result, Ok([20, 40]))
}

pub fn filter_map_async_test() {
  let result =
    async_yielder.from_list([1, 2, 3, 4])
    |> async_yielder.filter_map_async(keeping_with: fn(x) {
      case x % 2 == 0 {
        True -> promise.resolve(Ok(x * 10))
        False -> promise.resolve(Error(Nil))
      }
    })
    |> async_yielder.to_list
  use result <- promise.map(result)
  should.equal(result, Ok([20, 40]))
}

pub fn scan_test() {
  let result =
    async_yielder.from_list([1, 2, 3, 4])
    |> async_yielder.scan(from: 0, with: fn(acc, x) { acc + x })
    |> async_yielder.to_list
  use result <- promise.map(result)
  should.equal(result, Ok([1, 3, 6, 10]))
}

pub fn scan_empty_test() {
  let result =
    async_yielder.empty()
    |> async_yielder.scan(from: 0, with: fn(acc, x) { acc + x })
    |> async_yielder.to_list
  use result <- promise.map(result)
  should.equal(result, Ok([]))
}

pub fn scan_async_test() {
  let result =
    async_yielder.from_list([1, 2, 3])
    |> async_yielder.scan_async(from: 0, with: fn(acc, x) {
      promise.resolve(acc + x)
    })
    |> async_yielder.to_list
  use result <- promise.map(result)
  should.equal(result, Ok([1, 3, 6]))
}

pub fn index_test() {
  let result =
    async_yielder.from_list(["a", "b", "c"])
    |> async_yielder.index
    |> async_yielder.to_list
  use result <- promise.map(result)
  should.equal(result, Ok([#("a", 0), #("b", 1), #("c", 2)]))
}

pub fn intersperse_test() {
  let result =
    async_yielder.from_list([1, 2, 3])
    |> async_yielder.intersperse(with: 0)
    |> async_yielder.to_list
  use result <- promise.map(result)
  should.equal(result, Ok([1, 0, 2, 0, 3]))
}

pub fn intersperse_empty_test() {
  let result =
    async_yielder.empty()
    |> async_yielder.intersperse(with: 0)
    |> async_yielder.to_list
  use result <- promise.map(result)
  should.equal(result, Ok([]))
}

pub fn intersperse_single_test() {
  let result =
    async_yielder.from_list([42])
    |> async_yielder.intersperse(with: 0)
    |> async_yielder.to_list
  use result <- promise.map(result)
  should.equal(result, Ok([42]))
}

pub fn transform_test() {
  let result =
    async_yielder.from_list([1, 2, 3])
    |> async_yielder.transform(from: 0, with: fn(acc, x) {
      async_yielder.Next(acc + x, acc + x)
    })
    |> async_yielder.to_list
  use result <- promise.map(result)
  should.equal(result, Ok([1, 3, 6]))
}

pub fn transform_early_done_test() {
  let result =
    async_yielder.from_list([1, 2, 3, 4, 5])
    |> async_yielder.transform(from: 0, with: fn(acc, x) {
      let sum = acc + x
      case sum > 5 {
        True -> async_yielder.Done
        False -> async_yielder.Next(sum, sum)
      }
    })
    |> async_yielder.to_list
  use result <- promise.map(result)
  should.equal(result, Ok([1, 3]))
}

pub fn transform_async_test() {
  let result =
    async_yielder.from_list([1, 2, 3])
    |> async_yielder.transform_async(from: 0, with: fn(acc, x) {
      promise.resolve(async_yielder.Next(acc + x, acc + x))
    })
    |> async_yielder.to_list
  use result <- promise.map(result)
  should.equal(result, Ok([1, 3, 6]))
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
