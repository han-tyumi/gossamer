import gleam/option.{None, Some}
import gleeunit/should
import gossamer/async_iterator
import gossamer/iterator_handler_outcome
import gossamer/iterator_result
import gossamer/promise

pub fn new_and_next_test() {
  let iter =
    async_iterator.new(fn(_next) {
      promise.resolve(iterator_result.Return(Nil))
    })

  use result <- promise.then(async_iterator.next(iter))
  should.equal(result, Ok(iterator_result.Return(Nil)))
  promise.resolve(Nil)
}

pub fn stateful_iterator_test() {
  let iter =
    async_iterator.new(fn(next) {
      case next {
        None -> promise.resolve(iterator_result.Yield(0))
        Some(value) ->
          case value < 2 {
            True -> promise.resolve(iterator_result.Yield(value + 1))
            False -> promise.resolve(iterator_result.Return(Nil))
          }
      }
    })

  use result <- promise.then(async_iterator.next(iter))
  should.equal(result, Ok(iterator_result.Yield(0)))

  use result <- promise.then(async_iterator.next_with(iter, 0))
  should.equal(result, Ok(iterator_result.Yield(1)))

  use result <- promise.then(async_iterator.next_with(iter, 1))
  should.equal(result, Ok(iterator_result.Yield(2)))

  use result <- promise.then(async_iterator.next_with(iter, 2))
  should.equal(result, Ok(iterator_result.Return(Nil)))
  promise.resolve(Nil)
}

pub fn return_no_handler_test() {
  let iter =
    async_iterator.new(fn(_) { promise.resolve(iterator_result.Yield(1)) })

  use result <- promise.then(async_iterator.return(iter))
  should.equal(result, Ok(iterator_handler_outcome.NoHandler))
  promise.resolve(Nil)
}

pub fn return_with_handler_test() {
  let iter =
    async_iterator.new(fn(_) { promise.resolve(iterator_result.Yield(1)) })
    |> async_iterator.with_return(fn(_value) {
      promise.resolve(iterator_result.Return(Nil))
    })

  use result <- promise.then(async_iterator.return(iter))
  should.equal(
    result,
    Ok(iterator_handler_outcome.Handled(iterator_result.Return(Nil))),
  )
  promise.resolve(Nil)
}

pub fn return_with_value_test() {
  let iter =
    async_iterator.new(fn(_) { promise.resolve(iterator_result.Yield(1)) })
    |> async_iterator.with_return(fn(value) {
      case value {
        Some(val) -> promise.resolve(iterator_result.Return(val))
        None -> promise.resolve(iterator_result.Return(99))
      }
    })

  use result <- promise.then(async_iterator.return_with(iter, 42))
  should.equal(
    result,
    Ok(iterator_handler_outcome.Handled(iterator_result.Return(42))),
  )
  promise.resolve(Nil)
}

pub fn throw_no_handler_test() {
  let iter =
    async_iterator.new(fn(_) { promise.resolve(iterator_result.Yield(1)) })

  use result <- promise.then(async_iterator.throw(iter, "error"))
  should.equal(result, Ok(iterator_handler_outcome.NoHandler))
  promise.resolve(Nil)
}

pub fn throw_with_handler_test() {
  let iter =
    async_iterator.new(fn(_) { promise.resolve(iterator_result.Yield(1)) })
    |> async_iterator.with_throw(fn(_err) {
      promise.resolve(iterator_result.Return(Nil))
    })

  use result <- promise.then(async_iterator.throw(iter, "error"))
  should.equal(
    result,
    Ok(iterator_handler_outcome.Handled(iterator_result.Return(Nil))),
  )
  promise.resolve(Nil)
}

pub fn throw_passes_reason_test() {
  let iter =
    async_iterator.new(fn(_) { promise.resolve(iterator_result.Yield(1)) })
    |> async_iterator.with_throw(fn(err) {
      promise.resolve(iterator_result.Return(err))
    })

  use result <- promise.then(async_iterator.throw(iter, "specific-reason"))
  should.equal(
    result,
    Ok(
      iterator_handler_outcome.Handled(iterator_result.Return("specific-reason")),
    ),
  )
  promise.resolve(Nil)
}

pub fn for_await_test() {
  // for_await calls next() without arguments (next is always None).
  // Use a finite iterator that returns done immediately.
  let iter =
    async_iterator.new(fn(_next) {
      promise.resolve(iterator_result.Return(Nil))
    })

  use _ <- promise.then(async_iterator.for_await(iter, fn(_value) { Nil }))
  promise.resolve(Nil)
}

pub fn from_list_test() {
  let iter = async_iterator.from_list([10, 20, 30])

  use result <- promise.then(async_iterator.next(iter))
  should.equal(result, Ok(iterator_result.Yield(10)))

  use result <- promise.then(async_iterator.next(iter))
  should.equal(result, Ok(iterator_result.Yield(20)))

  use result <- promise.then(async_iterator.next(iter))
  should.equal(result, Ok(iterator_result.Yield(30)))

  use result <- promise.then(async_iterator.next(iter))
  should.equal(result, Ok(iterator_result.Return(Nil)))
  promise.resolve(Nil)
}

pub fn from_list_empty_test() {
  let iter = async_iterator.from_list([])

  use result <- promise.then(async_iterator.next(iter))
  should.equal(result, Ok(iterator_result.Return(Nil)))
  promise.resolve(Nil)
}

pub fn to_list_test() {
  let iter = async_iterator.from_list([1, 2, 3])

  use result <- promise.then(async_iterator.to_list(iter))
  should.equal(result, Ok([1, 2, 3]))
  promise.resolve(Nil)
}

pub fn to_list_empty_test() {
  let iter = async_iterator.from_list([])

  use result <- promise.then(async_iterator.to_list(iter))
  should.equal(result, Ok([]))
  promise.resolve(Nil)
}

pub fn from_list_to_list_roundtrip_test() {
  let original = [5, 10, 15, 20]
  let iter = async_iterator.from_list(original)

  use result <- promise.then(async_iterator.to_list(iter))
  should.equal(result, Ok(original))
  promise.resolve(Nil)
}
