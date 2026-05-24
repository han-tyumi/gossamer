import gleam/dict
import gleam/javascript/promise
import gleam/list
import gleeunit/should
import gossamer/iteration/async_yielder

pub fn from_list_to_list_test() {
  let yielder = async_yielder.from_list([1, 2, 3])
  use result <- promise.map(async_yielder.to_list(yielder))
  should.equal(result, [1, 2, 3])
}

pub fn empty_to_list_test() {
  let yielder = async_yielder.empty()
  use result <- promise.map(async_yielder.to_list(yielder))
  should.equal(result, [])
}

pub fn map_test() {
  let result =
    async_yielder.from_list([1, 2, 3])
    |> async_yielder.map(with: fn(x) { x * 2 })
    |> async_yielder.to_list
  use result <- promise.map(result)
  should.equal(result, [2, 4, 6])
}

pub fn filter_test() {
  let result =
    async_yielder.from_list([1, 2, 3, 4, 5])
    |> async_yielder.filter(keeping: fn(x) { x > 2 })
    |> async_yielder.to_list
  use result <- promise.map(result)
  should.equal(result, [3, 4, 5])
}

pub fn map_then_filter_test() {
  let result =
    async_yielder.from_list([1, 2, 3, 4, 5])
    |> async_yielder.map(with: fn(x) { x * 2 })
    |> async_yielder.filter(keeping: fn(x) { x > 4 })
    |> async_yielder.to_list
  use result <- promise.map(result)
  should.equal(result, [6, 8, 10])
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
  should.equal(result, [2, 4, 6])
}

pub fn filter_async_test() {
  let result =
    async_yielder.from_list([1, 2, 3, 4, 5])
    |> async_yielder.filter_async(keeping: fn(x) { promise.resolve(x > 2) })
    |> async_yielder.to_list
  use result <- promise.map(result)
  should.equal(result, [3, 4, 5])
}

pub fn each_test() {
  let result =
    async_yielder.from_list([1, 2, 3])
    |> async_yielder.each(with: fn(_) { Nil })
  use result <- promise.map(result)
  should.equal(result, Nil)
}

pub fn each_async_test() {
  let result =
    async_yielder.from_list([1, 2, 3])
    |> async_yielder.each_async(with: fn(_) { promise.resolve(Nil) })
  use result <- promise.map(result)
  should.equal(result, Nil)
}

pub fn single_test() {
  let result =
    async_yielder.single(42)
    |> async_yielder.to_list
  use result <- promise.map(result)
  should.equal(result, [42])
}

pub fn once_test() {
  let result =
    async_yielder.once(fn() { 7 })
    |> async_yielder.to_list
  use result <- promise.map(result)
  should.equal(result, [7])
}

pub fn once_async_test() {
  let result =
    async_yielder.once_async(fn() { promise.resolve(7) })
    |> async_yielder.to_list
  use result <- promise.map(result)
  should.equal(result, [7])
}

pub fn range_ascending_test() {
  let result =
    async_yielder.range(from: 1, to: 4)
    |> async_yielder.to_list
  use result <- promise.map(result)
  should.equal(result, [1, 2, 3, 4])
}

pub fn range_descending_test() {
  let result =
    async_yielder.range(from: 3, to: 0)
    |> async_yielder.to_list
  use result <- promise.map(result)
  should.equal(result, [3, 2, 1, 0])
}

pub fn range_eq_test() {
  let result =
    async_yielder.range(from: 5, to: 5)
    |> async_yielder.to_list
  use result <- promise.map(result)
  should.equal(result, [5])
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
  should.equal(result, [0, 1, 2])
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
  should.equal(result, [0, 1, 2])
}

pub fn yield_test() {
  let result =
    async_yielder.yield(1, fn() { async_yielder.from_list([2, 3]) })
    |> async_yielder.to_list
  use result <- promise.map(result)
  should.equal(result, [1, 2, 3])
}

pub fn yield_async_test() {
  let result =
    async_yielder.yield_async(1, fn() {
      promise.resolve(async_yielder.from_list([2, 3]))
    })
    |> async_yielder.to_list
  use result <- promise.map(result)
  should.equal(result, [1, 2, 3])
}

pub fn prepend_test() {
  let result =
    async_yielder.from_list([2, 3])
    |> async_yielder.prepend(1)
    |> async_yielder.to_list
  use result <- promise.map(result)
  should.equal(result, [1, 2, 3])
}

pub fn append_test() {
  let result =
    async_yielder.append(
      to: async_yielder.from_list([1, 2]),
      suffix: async_yielder.from_list([3, 4]),
    )
    |> async_yielder.to_list
  use result <- promise.map(result)
  should.equal(result, [1, 2, 3, 4])
}

pub fn append_empty_first_test() {
  let result =
    async_yielder.append(
      to: async_yielder.empty(),
      suffix: async_yielder.from_list([1, 2]),
    )
    |> async_yielder.to_list
  use result <- promise.map(result)
  should.equal(result, [1, 2])
}

pub fn append_empty_second_test() {
  let result =
    async_yielder.append(
      to: async_yielder.from_list([1, 2]),
      suffix: async_yielder.empty(),
    )
    |> async_yielder.to_list
  use result <- promise.map(result)
  should.equal(result, [1, 2])
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
  should.equal(result, [1, 2, 3, 4])
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
  should.equal(result, [1, 2])
}

pub fn concat_test() {
  let result =
    async_yielder.concat([
      async_yielder.from_list([1, 2]),
      async_yielder.from_list([3, 4]),
    ])
    |> async_yielder.to_list
  use result <- promise.map(result)
  should.equal(result, [1, 2, 3, 4])
}

pub fn concat_empty_test() {
  let result =
    async_yielder.concat([])
    |> async_yielder.to_list
  use result <- promise.map(result)
  should.equal(result, [])
}

pub fn flat_map_test() {
  let result =
    async_yielder.from_list([1, 2, 3])
    |> async_yielder.flat_map(with: fn(x) {
      async_yielder.from_list([x, x * 10])
    })
    |> async_yielder.to_list
  use result <- promise.map(result)
  should.equal(result, [1, 10, 2, 20, 3, 30])
}

pub fn flat_map_async_test() {
  let result =
    async_yielder.from_list([1, 2])
    |> async_yielder.flat_map_async(with: fn(x) {
      promise.resolve(async_yielder.from_list([x, x * 10]))
    })
    |> async_yielder.to_list
  use result <- promise.map(result)
  should.equal(result, [1, 10, 2, 20])
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
  should.equal(result, [20, 40])
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
  should.equal(result, [20, 40])
}

pub fn scan_test() {
  let result =
    async_yielder.from_list([1, 2, 3, 4])
    |> async_yielder.scan(from: 0, with: fn(acc, x) { acc + x })
    |> async_yielder.to_list
  use result <- promise.map(result)
  should.equal(result, [1, 3, 6, 10])
}

pub fn scan_empty_test() {
  let result =
    async_yielder.empty()
    |> async_yielder.scan(from: 0, with: fn(acc, x) { acc + x })
    |> async_yielder.to_list
  use result <- promise.map(result)
  should.equal(result, [])
}

pub fn scan_async_test() {
  let result =
    async_yielder.from_list([1, 2, 3])
    |> async_yielder.scan_async(from: 0, with: fn(acc, x) {
      promise.resolve(acc + x)
    })
    |> async_yielder.to_list
  use result <- promise.map(result)
  should.equal(result, [1, 3, 6])
}

pub fn index_test() {
  let result =
    async_yielder.from_list(["a", "b", "c"])
    |> async_yielder.index
    |> async_yielder.to_list
  use result <- promise.map(result)
  should.equal(result, [#("a", 0), #("b", 1), #("c", 2)])
}

pub fn intersperse_test() {
  let result =
    async_yielder.from_list([1, 2, 3])
    |> async_yielder.intersperse(with: 0)
    |> async_yielder.to_list
  use result <- promise.map(result)
  should.equal(result, [1, 0, 2, 0, 3])
}

pub fn intersperse_empty_test() {
  let result =
    async_yielder.empty()
    |> async_yielder.intersperse(with: 0)
    |> async_yielder.to_list
  use result <- promise.map(result)
  should.equal(result, [])
}

pub fn intersperse_single_test() {
  let result =
    async_yielder.from_list([42])
    |> async_yielder.intersperse(with: 0)
    |> async_yielder.to_list
  use result <- promise.map(result)
  should.equal(result, [42])
}

pub fn transform_test() {
  let result =
    async_yielder.from_list([1, 2, 3])
    |> async_yielder.transform(from: 0, with: fn(acc, x) {
      async_yielder.Next(acc + x, acc + x)
    })
    |> async_yielder.to_list
  use result <- promise.map(result)
  should.equal(result, [1, 3, 6])
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
  should.equal(result, [1, 3])
}

pub fn transform_async_test() {
  let result =
    async_yielder.from_list([1, 2, 3])
    |> async_yielder.transform_async(from: 0, with: fn(acc, x) {
      promise.resolve(async_yielder.Next(acc + x, acc + x))
    })
    |> async_yielder.to_list
  use result <- promise.map(result)
  should.equal(result, [1, 3, 6])
}

pub fn take_test() {
  let result =
    async_yielder.from_list([1, 2, 3, 4, 5])
    |> async_yielder.take(up_to: 3)
    |> async_yielder.to_list
  use result <- promise.map(result)
  should.equal(result, [1, 2, 3])
}

pub fn take_more_than_length_test() {
  let result =
    async_yielder.from_list([1, 2])
    |> async_yielder.take(up_to: 10)
    |> async_yielder.to_list
  use result <- promise.map(result)
  should.equal(result, [1, 2])
}

pub fn take_zero_test() {
  let result =
    async_yielder.from_list([1, 2])
    |> async_yielder.take(up_to: 0)
    |> async_yielder.to_list
  use result <- promise.map(result)
  should.equal(result, [])
}

pub fn take_negative_test() {
  let result =
    async_yielder.from_list([1, 2])
    |> async_yielder.take(up_to: -5)
    |> async_yielder.to_list
  use result <- promise.map(result)
  should.equal(result, [])
}

pub fn drop_test() {
  let result =
    async_yielder.from_list([1, 2, 3, 4, 5])
    |> async_yielder.drop(up_to: 2)
    |> async_yielder.to_list
  use result <- promise.map(result)
  should.equal(result, [3, 4, 5])
}

pub fn drop_more_than_length_test() {
  let result =
    async_yielder.from_list([1, 2])
    |> async_yielder.drop(up_to: 10)
    |> async_yielder.to_list
  use result <- promise.map(result)
  should.equal(result, [])
}

pub fn drop_zero_test() {
  let result =
    async_yielder.from_list([1, 2])
    |> async_yielder.drop(up_to: 0)
    |> async_yielder.to_list
  use result <- promise.map(result)
  should.equal(result, [1, 2])
}

pub fn drop_negative_test() {
  let result =
    async_yielder.from_list([1, 2])
    |> async_yielder.drop(up_to: -5)
    |> async_yielder.to_list
  use result <- promise.map(result)
  should.equal(result, [1, 2])
}

pub fn take_while_test() {
  let result =
    async_yielder.from_list([1, 2, 3, 4, 1])
    |> async_yielder.take_while(satisfying: fn(x) { x < 3 })
    |> async_yielder.to_list
  use result <- promise.map(result)
  should.equal(result, [1, 2])
}

pub fn take_while_async_test() {
  let result =
    async_yielder.from_list([1, 2, 3, 4])
    |> async_yielder.take_while_async(satisfying: fn(x) {
      promise.resolve(x < 3)
    })
    |> async_yielder.to_list
  use result <- promise.map(result)
  should.equal(result, [1, 2])
}

pub fn drop_while_test() {
  let result =
    async_yielder.from_list([1, 2, 3, 4, 1])
    |> async_yielder.drop_while(satisfying: fn(x) { x < 3 })
    |> async_yielder.to_list
  use result <- promise.map(result)
  should.equal(result, [3, 4, 1])
}

pub fn drop_while_async_test() {
  let result =
    async_yielder.from_list([1, 2, 3, 4])
    |> async_yielder.drop_while_async(satisfying: fn(x) {
      promise.resolve(x < 3)
    })
    |> async_yielder.to_list
  use result <- promise.map(result)
  should.equal(result, [3, 4])
}

pub fn fold_test() {
  let result =
    async_yielder.from_list([1, 2, 3, 4])
    |> async_yielder.fold(from: 0, with: fn(acc, x) { acc + x })
  use result <- promise.map(result)
  should.equal(result, 10)
}

pub fn fold_empty_test() {
  let result =
    async_yielder.empty()
    |> async_yielder.fold(from: 42, with: fn(acc, x) { acc + x })
  use result <- promise.map(result)
  should.equal(result, 42)
}

pub fn fold_async_test() {
  let result =
    async_yielder.from_list([1, 2, 3, 4])
    |> async_yielder.fold_async(from: 0, with: fn(acc, x) {
      promise.resolve(acc + x)
    })
  use result <- promise.map(result)
  should.equal(result, 10)
}

pub fn run_test() {
  let result = async_yielder.run(async_yielder.from_list([1, 2, 3]))
  use result <- promise.map(result)
  should.equal(result, Nil)
}

pub fn length_test() {
  let result = async_yielder.length(async_yielder.from_list([1, 2, 3, 4, 5]))
  use result <- promise.map(result)
  should.equal(result, 5)
}

pub fn length_empty_test() {
  let result = async_yielder.length(async_yielder.empty())
  use result <- promise.map(result)
  should.equal(result, 0)
}

pub fn first_test() {
  let result = async_yielder.first(from: async_yielder.from_list([1, 2, 3]))
  use result <- promise.map(result)
  should.equal(result, Ok(1))
}

pub fn first_empty_test() {
  let result = async_yielder.first(from: async_yielder.empty())
  use result <- promise.map(result)
  should.equal(result, Error(Nil))
}

pub fn last_test() {
  let result = async_yielder.last(async_yielder.from_list([1, 2, 3]))
  use result <- promise.map(result)
  should.equal(result, Ok(3))
}

pub fn last_empty_test() {
  let result = async_yielder.last(async_yielder.empty())
  use result <- promise.map(result)
  should.equal(result, Error(Nil))
}

pub fn at_test() {
  let result =
    async_yielder.from_list(["a", "b", "c", "d"])
    |> async_yielder.at(get: 2)
  use result <- promise.map(result)
  should.equal(result, Ok("c"))
}

pub fn at_zero_test() {
  let result =
    async_yielder.from_list(["a", "b"])
    |> async_yielder.at(get: 0)
  use result <- promise.map(result)
  should.equal(result, Ok("a"))
}

pub fn at_out_of_range_test() {
  let result =
    async_yielder.from_list(["a", "b"])
    |> async_yielder.at(get: 5)
  use result <- promise.map(result)
  should.equal(result, Error(Nil))
}

pub fn reduce_test() {
  let result =
    async_yielder.from_list([1, 2, 3, 4])
    |> async_yielder.reduce(with: fn(a, b) { a + b })
  use result <- promise.map(result)
  should.equal(result, Ok(10))
}

pub fn reduce_empty_test() {
  let result =
    async_yielder.empty()
    |> async_yielder.reduce(with: fn(a, b) { a + b })
  use result <- promise.map(result)
  should.equal(result, Error(Nil))
}

pub fn reduce_async_test() {
  let result =
    async_yielder.from_list([1, 2, 3])
    |> async_yielder.reduce_async(with: fn(a, b) { promise.resolve(a + b) })
  use result <- promise.map(result)
  should.equal(result, Ok(6))
}

pub fn any_true_test() {
  let result =
    async_yielder.from_list([1, 2, 3, 4])
    |> async_yielder.any(satisfying: fn(x) { x > 3 })
  use result <- promise.map(result)
  should.equal(result, True)
}

pub fn any_false_test() {
  let result =
    async_yielder.from_list([1, 2, 3])
    |> async_yielder.any(satisfying: fn(x) { x > 10 })
  use result <- promise.map(result)
  should.equal(result, False)
}

pub fn any_empty_test() {
  let result =
    async_yielder.empty()
    |> async_yielder.any(satisfying: fn(_) { True })
  use result <- promise.map(result)
  should.equal(result, False)
}

pub fn any_async_test() {
  let result =
    async_yielder.from_list([1, 2, 3, 4])
    |> async_yielder.any_async(satisfying: fn(x) { promise.resolve(x > 3) })
  use result <- promise.map(result)
  should.equal(result, True)
}

pub fn all_true_test() {
  let result =
    async_yielder.from_list([2, 4, 6])
    |> async_yielder.all(satisfying: fn(x) { x % 2 == 0 })
  use result <- promise.map(result)
  should.equal(result, True)
}

pub fn all_false_test() {
  let result =
    async_yielder.from_list([2, 3, 4])
    |> async_yielder.all(satisfying: fn(x) { x % 2 == 0 })
  use result <- promise.map(result)
  should.equal(result, False)
}

pub fn all_empty_test() {
  let result =
    async_yielder.empty()
    |> async_yielder.all(satisfying: fn(_) { False })
  use result <- promise.map(result)
  should.equal(result, True)
}

pub fn all_async_test() {
  let result =
    async_yielder.from_list([2, 4, 6])
    |> async_yielder.all_async(satisfying: fn(x) { promise.resolve(x % 2 == 0) })
  use result <- promise.map(result)
  should.equal(result, True)
}

pub fn find_test() {
  let result =
    async_yielder.from_list([1, 2, 3, 4])
    |> async_yielder.find(one_that: fn(x) { x > 2 })
  use result <- promise.map(result)
  should.equal(result, Ok(3))
}

pub fn find_not_found_test() {
  let result =
    async_yielder.from_list([1, 2, 3])
    |> async_yielder.find(one_that: fn(x) { x > 10 })
  use result <- promise.map(result)
  should.equal(result, Error(Nil))
}

pub fn find_async_test() {
  let result =
    async_yielder.from_list([1, 2, 3, 4])
    |> async_yielder.find_async(one_that: fn(x) { promise.resolve(x > 2) })
  use result <- promise.map(result)
  should.equal(result, Ok(3))
}

pub fn find_map_test() {
  let result =
    async_yielder.from_list([1, 2, 3, 4])
    |> async_yielder.find_map(one_that: fn(x) {
      case x > 2 {
        True -> Ok(x * 10)
        False -> Error(Nil)
      }
    })
  use result <- promise.map(result)
  should.equal(result, Ok(30))
}

pub fn find_map_not_found_test() {
  let result =
    async_yielder.from_list([1, 2])
    |> async_yielder.find_map(one_that: fn(_) { Error(Nil) })
  use result <- promise.map(result)
  should.equal(result, Error(Nil))
}

pub fn find_map_async_test() {
  let result =
    async_yielder.from_list([1, 2, 3, 4])
    |> async_yielder.find_map_async(one_that: fn(x) {
      case x > 2 {
        True -> promise.resolve(Ok(x * 10))
        False -> promise.resolve(Error(Nil))
      }
    })
  use result <- promise.map(result)
  should.equal(result, Ok(30))
}

pub fn fold_until_test() {
  let result =
    async_yielder.from_list([1, 2, 3, 4, 5])
    |> async_yielder.fold_until(from: 0, with: fn(acc, x) {
      let sum = acc + x
      case sum > 5 {
        True -> list.Stop(sum)
        False -> list.Continue(sum)
      }
    })
  use result <- promise.map(result)
  should.equal(result, 6)
}

pub fn fold_until_runs_to_done_test() {
  let result =
    async_yielder.from_list([1, 2, 3])
    |> async_yielder.fold_until(from: 0, with: fn(acc, x) {
      list.Continue(acc + x)
    })
  use result <- promise.map(result)
  should.equal(result, 6)
}

pub fn fold_until_async_test() {
  let result =
    async_yielder.from_list([1, 2, 3, 4, 5])
    |> async_yielder.fold_until_async(from: 0, with: fn(acc, x) {
      let sum = acc + x
      case sum > 5 {
        True -> promise.resolve(list.Stop(sum))
        False -> promise.resolve(list.Continue(sum))
      }
    })
  use result <- promise.map(result)
  should.equal(result, 6)
}

pub fn try_fold_test() {
  let result =
    async_yielder.from_list([1, 2, 3, 4])
    |> async_yielder.try_fold(from: 0, with: fn(acc, x) { Ok(acc + x) })
  use result <- promise.map(result)
  should.equal(result, Ok(10))
}

pub fn try_fold_stops_on_error_test() {
  let result =
    async_yielder.from_list([1, 2, 3, 4])
    |> async_yielder.try_fold(from: 0, with: fn(acc, x) {
      case x > 2 {
        True -> Error("too big")
        False -> Ok(acc + x)
      }
    })
  use result <- promise.map(result)
  should.equal(result, Error("too big"))
}

pub fn try_fold_async_test() {
  let result =
    async_yielder.from_list([1, 2, 3])
    |> async_yielder.try_fold_async(from: 0, with: fn(acc, x) {
      promise.resolve(Ok(acc + x))
    })
  use result <- promise.map(result)
  should.equal(result, Ok(6))
}

pub fn chunk_test() {
  let result =
    async_yielder.from_list([1, 1, 2, 2, 2, 3])
    |> async_yielder.chunk(by: fn(x) { x })
    |> async_yielder.to_list
  use result <- promise.map(result)
  should.equal(result, [[1, 1], [2, 2, 2], [3]])
}

pub fn chunk_empty_test() {
  let result =
    async_yielder.empty()
    |> async_yielder.chunk(by: fn(x) { x })
    |> async_yielder.to_list
  use result <- promise.map(result)
  should.equal(result, [])
}

pub fn chunk_async_test() {
  let result =
    async_yielder.from_list([1, 1, 2, 2, 3])
    |> async_yielder.chunk_async(by: fn(x) { promise.resolve(x) })
    |> async_yielder.to_list
  use result <- promise.map(result)
  should.equal(result, [[1, 1], [2, 2], [3]])
}

pub fn sized_chunk_test() {
  let result =
    async_yielder.from_list([1, 2, 3, 4, 5, 6])
    |> async_yielder.sized_chunk(into: 2)
    |> async_yielder.to_list
  use result <- promise.map(result)
  should.equal(result, [[1, 2], [3, 4], [5, 6]])
}

pub fn sized_chunk_partial_last_test() {
  let result =
    async_yielder.from_list([1, 2, 3, 4, 5])
    |> async_yielder.sized_chunk(into: 2)
    |> async_yielder.to_list
  use result <- promise.map(result)
  should.equal(result, [[1, 2], [3, 4], [5]])
}

pub fn sized_chunk_empty_test() {
  let result =
    async_yielder.empty()
    |> async_yielder.sized_chunk(into: 3)
    |> async_yielder.to_list
  use result <- promise.map(result)
  should.equal(result, [])
}

pub fn sized_chunk_zero_clamps_to_one_test() {
  let result =
    async_yielder.from_list([1, 2])
    |> async_yielder.sized_chunk(into: 0)
    |> async_yielder.to_list
  use result <- promise.map(result)
  // `sized_chunk` clamps `count < 1` to `1`, matching `gleam_yielder`.
  should.equal(result, [[1], [2]])
}

pub fn group_test() {
  let result =
    async_yielder.from_list([1, 2, 3, 4, 5, 6])
    |> async_yielder.group(by: fn(x) { x % 2 })
  use grouped <- promise.map(result)
  should.equal(dict.get(grouped, 0), Ok([2, 4, 6]))
  should.equal(dict.get(grouped, 1), Ok([1, 3, 5]))
}

pub fn group_empty_test() {
  let result =
    async_yielder.empty()
    |> async_yielder.group(by: fn(x) { x })
  use grouped <- promise.map(result)
  should.equal(dict.size(grouped), 0)
}

pub fn group_async_test() {
  let result =
    async_yielder.from_list([1, 2, 3, 4])
    |> async_yielder.group_async(by: fn(x) { promise.resolve(x % 2) })
  use grouped <- promise.map(result)
  should.equal(dict.get(grouped, 0), Ok([2, 4]))
  should.equal(dict.get(grouped, 1), Ok([1, 3]))
}

pub fn repeat_test() {
  let result =
    async_yielder.repeat(7)
    |> async_yielder.take(up_to: 4)
    |> async_yielder.to_list
  use result <- promise.map(result)
  should.equal(result, [7, 7, 7, 7])
}

pub fn repeatedly_test() {
  let result =
    async_yielder.repeatedly(fn() { 42 })
    |> async_yielder.take(up_to: 3)
    |> async_yielder.to_list
  use result <- promise.map(result)
  should.equal(result, [42, 42, 42])
}

pub fn repeatedly_async_test() {
  let result =
    async_yielder.repeatedly_async(fn() { promise.resolve("x") })
    |> async_yielder.take(up_to: 3)
    |> async_yielder.to_list
  use result <- promise.map(result)
  should.equal(result, ["x", "x", "x"])
}

pub fn iterate_test() {
  let result =
    async_yielder.iterate(from: 1, with: fn(n) { n * 2 })
    |> async_yielder.take(up_to: 5)
    |> async_yielder.to_list
  use result <- promise.map(result)
  should.equal(result, [1, 2, 4, 8, 16])
}

pub fn iterate_async_test() {
  let result =
    async_yielder.iterate_async(from: 0, with: fn(n) { promise.resolve(n + 3) })
    |> async_yielder.take(up_to: 4)
    |> async_yielder.to_list
  use result <- promise.map(result)
  should.equal(result, [0, 3, 6, 9])
}

pub fn cycle_test() {
  let result =
    async_yielder.from_list([1, 2, 3])
    |> async_yielder.cycle
    |> async_yielder.take(up_to: 7)
    |> async_yielder.to_list
  use result <- promise.map(result)
  should.equal(result, [1, 2, 3, 1, 2, 3, 1])
}

pub fn zip_test() {
  let result =
    async_yielder.zip(
      async_yielder.from_list([1, 2, 3]),
      async_yielder.from_list(["a", "b", "c"]),
    )
    |> async_yielder.to_list
  use result <- promise.map(result)
  should.equal(result, [#(1, "a"), #(2, "b"), #(3, "c")])
}

pub fn zip_uneven_test() {
  let result =
    async_yielder.zip(
      async_yielder.from_list([1, 2, 3, 4]),
      async_yielder.from_list(["a", "b"]),
    )
    |> async_yielder.to_list
  use result <- promise.map(result)
  should.equal(result, [#(1, "a"), #(2, "b")])
}

pub fn map2_test() {
  let result =
    async_yielder.map2(
      async_yielder.from_list([1, 2, 3]),
      async_yielder.from_list([10, 20, 30]),
      with: fn(a, b) { a + b },
    )
    |> async_yielder.to_list
  use result <- promise.map(result)
  should.equal(result, [11, 22, 33])
}

pub fn map2_async_test() {
  let result =
    async_yielder.map2_async(
      async_yielder.from_list([1, 2, 3]),
      async_yielder.from_list([10, 20, 30]),
      with: fn(a, b) { promise.resolve(a * b) },
    )
    |> async_yielder.to_list
  use result <- promise.map(result)
  should.equal(result, [10, 40, 90])
}

pub fn interleave_test() {
  let result =
    async_yielder.from_list([1, 3, 5])
    |> async_yielder.interleave(with: async_yielder.from_list([2, 4, 6]))
    |> async_yielder.to_list
  use result <- promise.map(result)
  should.equal(result, [1, 2, 3, 4, 5, 6])
}

pub fn interleave_uneven_test() {
  let result =
    async_yielder.from_list([1, 3, 5, 7, 9])
    |> async_yielder.interleave(with: async_yielder.from_list([2, 4]))
    |> async_yielder.to_list
  use result <- promise.map(result)
  should.equal(result, [1, 2, 3, 4, 5, 7, 9])
}
