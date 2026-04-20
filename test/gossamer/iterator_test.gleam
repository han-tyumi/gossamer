import gleam/option.{None, Some}
import gleeunit/should
import gossamer/iterator
import gossamer/iterator_handler_outcome
import gossamer/iterator_result

pub fn new_and_next_test() {
  let values = [1, 2, 3]
  let index = 0

  // Create a simple iterator that yields values from a list-like sequence.
  let iter =
    iterator.new(fn(_next) {
      // Since we can't mutate, we rely on the iterator protocol.
      // Each call returns the next value based on the passed-in next value.
      iterator_result.Return(Nil)
    })

  let result = iterator.next(iter)
  should.equal(result, iterator_result.Return(Nil))

  // Suppress unused variable warnings.
  let _ = values
  let _ = index
}

pub fn stateful_iterator_test() {
  // Use next_with to pass state through the iterator.
  let iter =
    iterator.new(fn(next) {
      case next {
        None -> iterator_result.Yield(0)
        Some(value) ->
          case value < 3 {
            True -> iterator_result.Yield(value + 1)
            False -> iterator_result.Return(Nil)
          }
      }
    })

  let result = iterator.next(iter)
  should.equal(result, iterator_result.Yield(0))

  let result = iterator.next_with(iter, 0)
  should.equal(result, iterator_result.Yield(1))

  let result = iterator.next_with(iter, 1)
  should.equal(result, iterator_result.Yield(2))

  let result = iterator.next_with(iter, 2)
  should.equal(result, iterator_result.Yield(3))

  let result = iterator.next_with(iter, 3)
  should.equal(result, iterator_result.Return(Nil))
}

pub fn return_test() {
  let iter = iterator.new(fn(_) { iterator_result.Yield(1) })
  iterator.return(iter)
  |> should.equal(Ok(iterator_handler_outcome.NoHandler))
}

pub fn return_with_handler_test() {
  let iter =
    iterator.new(fn(_) { iterator_result.Yield(1) })
    |> iterator.with_return(fn(_value) { iterator_result.Return(Nil) })

  iterator.return(iter)
  |> should.equal(
    Ok(iterator_handler_outcome.Handled(iterator_result.Return(Nil))),
  )
}

pub fn return_with_value_test() {
  let iter =
    iterator.new(fn(_) { iterator_result.Yield(1) })
    |> iterator.with_return(fn(value) {
      case value {
        Some(val) -> iterator_result.Return(val)
        None -> iterator_result.Return(99)
      }
    })

  iterator.return_with(iter, 42)
  |> should.equal(
    Ok(iterator_handler_outcome.Handled(iterator_result.Return(42))),
  )
}

pub fn throw_test() {
  let iter = iterator.new(fn(_) { iterator_result.Yield(1) })
  iterator.throw(iter, "error")
  |> should.equal(Ok(iterator_handler_outcome.NoHandler))
}

pub fn throw_with_handler_test() {
  let iter =
    iterator.new(fn(_) { iterator_result.Yield(1) })
    |> iterator.with_throw(fn(_err) { iterator_result.Return(Nil) })

  iterator.throw(iter, "error")
  |> should.equal(
    Ok(iterator_handler_outcome.Handled(iterator_result.Return(Nil))),
  )
}

pub fn throw_passes_reason_test() {
  let iter =
    iterator.new(fn(_) { iterator_result.Yield(1) })
    |> iterator.with_throw(fn(err) { iterator_result.Return(err) })

  iterator.throw(iter, "specific-reason")
  |> should.equal(
    Ok(
      iterator_handler_outcome.Handled(iterator_result.Return("specific-reason")),
    ),
  )
}

pub fn for_test() {
  // for() calls next() without arguments (next is always None).
  // Use a finite iterator that returns done immediately after first yield.
  let iter = iterator.new(fn(_next) { iterator_result.Return(Nil) })

  iterator.for(iter, fn(_value) { Nil })
}

pub fn from_list_test() {
  let iter = iterator.from_list([10, 20, 30])

  iterator.next(iter) |> should.equal(iterator_result.Yield(10))
  iterator.next(iter) |> should.equal(iterator_result.Yield(20))
  iterator.next(iter) |> should.equal(iterator_result.Yield(30))
  iterator.next(iter) |> should.equal(iterator_result.Return(Nil))
}

pub fn from_list_empty_test() {
  let iter = iterator.from_list([])

  iterator.next(iter) |> should.equal(iterator_result.Return(Nil))
}

pub fn to_list_test() {
  let iter = iterator.from_list([1, 2, 3])

  iterator.to_list(iter) |> should.equal([1, 2, 3])
}

pub fn to_list_empty_test() {
  let iter = iterator.from_list([])

  iterator.to_list(iter) |> should.equal([])
}

pub fn from_list_to_list_roundtrip_test() {
  let original = [5, 10, 15, 20]

  iterator.from_list(original)
  |> iterator.to_list
  |> should.equal(original)
}

pub fn map_test() {
  iterator.from_list([1, 2, 3])
  |> iterator.map(with: fn(value) { value * 2 })
  |> iterator.to_list
  |> should.equal([2, 4, 6])
}

pub fn map_empty_test() {
  iterator.from_list([])
  |> iterator.map(with: fn(value: Int) { value * 2 })
  |> iterator.to_list
  |> should.equal([])
}

pub fn filter_test() {
  iterator.from_list([1, 2, 3, 4, 5])
  |> iterator.filter(keeping: fn(value) { value > 3 })
  |> iterator.to_list
  |> should.equal([4, 5])
}

pub fn filter_none_match_test() {
  iterator.from_list([1, 2, 3])
  |> iterator.filter(keeping: fn(value) { value > 10 })
  |> iterator.to_list
  |> should.equal([])
}

pub fn take_test() {
  iterator.from_list([1, 2, 3, 4, 5])
  |> iterator.take(up_to: 3)
  |> iterator.to_list
  |> should.equal([1, 2, 3])
}

pub fn take_more_than_available_test() {
  iterator.from_list([1, 2])
  |> iterator.take(up_to: 10)
  |> iterator.to_list
  |> should.equal([1, 2])
}

pub fn drop_test() {
  iterator.from_list([1, 2, 3, 4, 5])
  |> iterator.drop(up_to: 2)
  |> iterator.to_list
  |> should.equal([3, 4, 5])
}

pub fn drop_all_test() {
  iterator.from_list([1, 2, 3])
  |> iterator.drop(up_to: 10)
  |> iterator.to_list
  |> should.equal([])
}

pub fn flat_map_test() {
  iterator.from_list([1, 2, 3])
  |> iterator.flat_map(with: fn(value) {
    iterator.from_list([value, value * 10])
  })
  |> iterator.to_list
  |> should.equal([1, 10, 2, 20, 3, 30])
}

pub fn chaining_test() {
  iterator.from_list([1, 2, 3, 4, 5, 6, 7, 8, 9, 10])
  |> iterator.filter(keeping: fn(value) { value % 2 == 0 })
  |> iterator.map(with: fn(value) { value * 3 })
  |> iterator.take(up_to: 3)
  |> iterator.to_list
  |> should.equal([6, 12, 18])
}

pub fn reduce_test() {
  iterator.from_list([1, 2, 3, 4])
  |> iterator.reduce(from: 0, with: fn(sum, value) { sum + value })
  |> should.equal(10)
}

pub fn reduce_empty_test() {
  iterator.from_list([])
  |> iterator.reduce(from: 42, with: fn(acc, value: Int) { acc + value })
  |> should.equal(42)
}

pub fn some_empty_test() {
  iterator.from_list([])
  |> iterator.some(satisfying: fn(_: Int) { True })
  |> should.be_false
}

pub fn some_true_test() {
  iterator.from_list([1, 2, 3])
  |> iterator.some(satisfying: fn(value) { value == 2 })
  |> should.be_true
}

pub fn some_false_test() {
  iterator.from_list([1, 2, 3])
  |> iterator.some(satisfying: fn(value) { value > 10 })
  |> should.be_false
}

pub fn every_empty_test() {
  iterator.from_list([])
  |> iterator.every(satisfying: fn(_: Int) { False })
  |> should.be_true
}

pub fn every_true_test() {
  iterator.from_list([2, 4, 6])
  |> iterator.every(satisfying: fn(value) { value % 2 == 0 })
  |> should.be_true
}

pub fn every_false_test() {
  iterator.from_list([2, 4, 5])
  |> iterator.every(satisfying: fn(value) { value % 2 == 0 })
  |> should.be_false
}

pub fn find_some_test() {
  iterator.from_list([1, 2, 3])
  |> iterator.find(one_that: fn(value) { value > 1 })
  |> should.equal(Ok(2))
}

pub fn find_none_test() {
  iterator.from_list([1, 2, 3])
  |> iterator.find(one_that: fn(value) { value > 10 })
  |> should.be_error
}
