import gleam/option.{None, Some}
import gleam/yielder
import gleeunit/should
import gossamer/iteration
import gossamer/iteration/iterator

pub fn new_and_next_test() {
  // Cover both `IteratorResult` variants — the callback's return value
  // round-trips through `next` for each.
  let yielded = iterator.new(fn(_next) { iteration.Yield(42) })
  iterator.next(yielded) |> should.equal(iteration.Yield(42))

  let returned = iterator.new(fn(_next) { iteration.Return("done") })
  iterator.next(returned) |> should.equal(iteration.Return("done"))
}

pub fn stateful_iterator_test() {
  // Use next_with to pass state through the iterator.
  let iter =
    iterator.new(fn(next) {
      case next {
        None -> iteration.Yield(0)
        Some(value) ->
          case value < 3 {
            True -> iteration.Yield(value + 1)
            False -> iteration.Return(Nil)
          }
      }
    })

  let result = iterator.next(iter)
  should.equal(result, iteration.Yield(0))

  let result = iterator.next_with(iter, 0)
  should.equal(result, iteration.Yield(1))

  let result = iterator.next_with(iter, 1)
  should.equal(result, iteration.Yield(2))

  let result = iterator.next_with(iter, 2)
  should.equal(result, iteration.Yield(3))

  let result = iterator.next_with(iter, 3)
  should.equal(result, iteration.Return(Nil))
}

pub fn return_test() {
  let iter = iterator.new(fn(_) { iteration.Yield(1) })
  iterator.return(iter)
  |> should.equal(Ok(iteration.NoHandler))
}

pub fn return_with_handler_test() {
  let iter =
    iterator.new(fn(_) { iteration.Yield(1) })
    |> iterator.with_return(fn(_value) { iteration.Return(Nil) })

  iterator.return(iter)
  |> should.equal(Ok(iteration.Handled(iteration.Return(Nil))))
}

pub fn return_with_value_test() {
  let iter =
    iterator.new(fn(_) { iteration.Yield(1) })
    |> iterator.with_return(fn(value) {
      case value {
        Some(val) -> iteration.Return(val)
        None -> iteration.Return(99)
      }
    })

  iterator.return_with(iter, 42)
  |> should.equal(Ok(iteration.Handled(iteration.Return(42))))
}

pub fn throw_test() {
  let iter = iterator.new(fn(_) { iteration.Yield(1) })
  iterator.throw(iter, "error")
  |> should.equal(Ok(iteration.NoHandler))
}

pub fn throw_with_handler_test() {
  let iter =
    iterator.new(fn(_) { iteration.Yield(1) })
    |> iterator.with_throw(fn(_err) { iteration.Return(Nil) })

  iterator.throw(iter, "error")
  |> should.equal(Ok(iteration.Handled(iteration.Return(Nil))))
}

pub fn throw_passes_reason_test() {
  let iter =
    iterator.new(fn(_) { iteration.Yield(1) })
    |> iterator.with_throw(fn(err) { iteration.Return(err) })

  iterator.throw(iter, "specific-reason")
  |> should.equal(Ok(iteration.Handled(iteration.Return("specific-reason"))))
}

pub fn return_callback_throws_test() {
  let iter =
    iterator.new(fn(_) { iteration.Yield(1) })
    |> iterator.with_return(fn(_value) { panic as "handler boom" })

  let assert Error(_) = iterator.return(iter)
}

pub fn for_test() {
  // `for` consumes the iterator. After it runs, `next` must return Return.
  let iter = yielder.from_list([1, 2, 3]) |> iterator.from_yielder
  iterator.for(iter, fn(_value) { Nil })
  iterator.next(iter) |> should.equal(iteration.Return(Nil))
}

pub fn from_yielder_test() {
  let iter = yielder.from_list([10, 20, 30]) |> iterator.from_yielder

  iterator.next(iter) |> should.equal(iteration.Yield(10))
  iterator.next(iter) |> should.equal(iteration.Yield(20))
  iterator.next(iter) |> should.equal(iteration.Yield(30))
  iterator.next(iter) |> should.equal(iteration.Return(Nil))
}

pub fn from_yielder_empty_test() {
  let iter = yielder.from_list([]) |> iterator.from_yielder

  iterator.next(iter) |> should.equal(iteration.Return(Nil))
}

pub fn to_yielder_test() {
  let iter = yielder.from_list([1, 2, 3]) |> iterator.from_yielder

  iter
  |> iterator.to_yielder
  |> yielder.to_list
  |> should.equal([1, 2, 3])
}

pub fn to_yielder_empty_test() {
  let iter = yielder.from_list([]) |> iterator.from_yielder

  iter
  |> iterator.to_yielder
  |> yielder.to_list
  |> should.equal([])
}

pub fn yielder_roundtrip_test() {
  let original = [5, 10, 15, 20]

  yielder.from_list(original)
  |> iterator.from_yielder
  |> iterator.to_yielder
  |> yielder.to_list
  |> should.equal(original)
}
