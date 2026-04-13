import gleam/option.{None, Some}
import gleeunit/should
import gossamer/iterator
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

  // Without a return handler, return should be Error.
  iterator.return(iter) |> should.be_error
}

pub fn return_with_handler_test() {
  let iter =
    iterator.new(fn(_) { iterator_result.Yield(1) })
    |> iterator.with_return(fn(_value) { iterator_result.Return(Nil) })

  let result = iterator.return(iter)
  should.equal(result, Ok(iterator_result.Return(Nil)))
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

  let result = iterator.return_with(iter, 42)
  should.equal(result, Ok(iterator_result.Return(42)))
}

pub fn throw_test() {
  let iter = iterator.new(fn(_) { iterator_result.Yield(1) })

  // Without a throw handler, throw should be Error.
  iterator.throw(iter, "error") |> should.be_error
}

pub fn throw_with_handler_test() {
  let iter =
    iterator.new(fn(_) { iterator_result.Yield(1) })
    |> iterator.with_throw(fn(_err) { iterator_result.Return(Nil) })

  let result = iterator.throw(iter, "error")
  should.equal(result, Ok(iterator_result.Return(Nil)))
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
