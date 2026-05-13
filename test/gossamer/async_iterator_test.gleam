import gleam/javascript/promise
import gleam/option.{None, Some}
import gleeunit/should
import gossamer/iteration
import gossamer/iteration/async_iterator

pub fn new_and_next_test() {
  let iter =
    async_iterator.new(fn(_next) { promise.resolve(iteration.Return(Nil)) })

  use result <- promise.await(async_iterator.next(iter, value: None))
  should.equal(result, Ok(iteration.Return(Nil)))
  promise.resolve(Nil)
}

pub fn stateful_iterator_test() {
  let iter =
    async_iterator.new(fn(next) {
      case next {
        None -> promise.resolve(iteration.Yield(0))
        Some(value) ->
          case value < 2 {
            True -> promise.resolve(iteration.Yield(value + 1))
            False -> promise.resolve(iteration.Return(Nil))
          }
      }
    })

  use result <- promise.await(async_iterator.next(iter, value: None))
  should.equal(result, Ok(iteration.Yield(0)))

  use result <- promise.await(async_iterator.next(iter, value: Some(0)))
  should.equal(result, Ok(iteration.Yield(1)))

  use result <- promise.await(async_iterator.next(iter, value: Some(1)))
  should.equal(result, Ok(iteration.Yield(2)))

  use result <- promise.await(async_iterator.next(iter, value: Some(2)))
  should.equal(result, Ok(iteration.Return(Nil)))
  promise.resolve(Nil)
}

pub fn return_no_handler_test() {
  let iter = async_iterator.new(fn(_) { promise.resolve(iteration.Yield(1)) })

  use result <- promise.await(async_iterator.return(iter, value: None))
  should.equal(result, Ok(iteration.NoHandler))
  promise.resolve(Nil)
}

pub fn return_with_handler_test() {
  let iter =
    async_iterator.new(fn(_) { promise.resolve(iteration.Yield(1)) })
    |> async_iterator.set_return(fn(_value) {
      promise.resolve(iteration.Return(Nil))
    })

  use result <- promise.await(async_iterator.return(iter, value: None))
  should.equal(result, Ok(iteration.Handled(iteration.Return(Nil))))
  promise.resolve(Nil)
}

pub fn return_with_value_test() {
  let iter =
    async_iterator.new(fn(_) { promise.resolve(iteration.Yield(1)) })
    |> async_iterator.set_return(fn(value) {
      case value {
        Some(val) -> promise.resolve(iteration.Return(val))
        None -> promise.resolve(iteration.Return(99))
      }
    })

  use result <- promise.await(async_iterator.return(iter, value: Some(42)))
  should.equal(result, Ok(iteration.Handled(iteration.Return(42))))
  promise.resolve(Nil)
}

pub fn throw_no_handler_test() {
  let iter = async_iterator.new(fn(_) { promise.resolve(iteration.Yield(1)) })

  use result <- promise.await(async_iterator.throw(iter, "error"))
  should.equal(result, Ok(iteration.NoHandler))
  promise.resolve(Nil)
}

pub fn throw_with_handler_test() {
  let iter =
    async_iterator.new(fn(_) { promise.resolve(iteration.Yield(1)) })
    |> async_iterator.set_throw(fn(_err) {
      promise.resolve(iteration.Return(Nil))
    })

  use result <- promise.await(async_iterator.throw(iter, "error"))
  should.equal(result, Ok(iteration.Handled(iteration.Return(Nil))))
  promise.resolve(Nil)
}

pub fn throw_passes_reason_test() {
  let iter =
    async_iterator.new(fn(_) { promise.resolve(iteration.Yield(1)) })
    |> async_iterator.set_throw(fn(err) {
      promise.resolve(iteration.Return(err))
    })

  use result <- promise.await(async_iterator.throw(iter, "specific-reason"))
  should.equal(
    result,
    Ok(iteration.Handled(iteration.Return("specific-reason"))),
  )
  promise.resolve(Nil)
}

pub fn next_callback_throws_test() {
  let iter = async_iterator.new(fn(_) { panic as "next boom" })

  use result <- promise.await(async_iterator.next(iter, value: None))
  let assert Error(_) = result
  promise.resolve(Nil)
}

pub fn for_await_test() {
  // `for_await` consumes the iterator. After it resolves, `next` must
  // return Return.
  let iter = async_iterator.from_list([1, 2, 3])
  use for_result <- promise.await(
    async_iterator.for_await(iter, fn(_value) { promise.resolve(Nil) }),
  )
  should.equal(for_result, Ok(Nil))

  use next_result <- promise.await(async_iterator.next(iter, value: None))
  should.equal(next_result, Ok(iteration.Return(Nil)))
  promise.resolve(Nil)
}

pub fn from_list_test() {
  let iter = async_iterator.from_list([10, 20, 30])

  use result <- promise.await(async_iterator.next(iter, value: None))
  should.equal(result, Ok(iteration.Yield(10)))

  use result <- promise.await(async_iterator.next(iter, value: None))
  should.equal(result, Ok(iteration.Yield(20)))

  use result <- promise.await(async_iterator.next(iter, value: None))
  should.equal(result, Ok(iteration.Yield(30)))

  use result <- promise.await(async_iterator.next(iter, value: None))
  should.equal(result, Ok(iteration.Return(Nil)))
  promise.resolve(Nil)
}

pub fn from_list_empty_test() {
  let iter = async_iterator.from_list([])

  use result <- promise.await(async_iterator.next(iter, value: None))
  should.equal(result, Ok(iteration.Return(Nil)))
  promise.resolve(Nil)
}

pub fn to_list_test() {
  let iter = async_iterator.from_list([1, 2, 3])

  use result <- promise.await(async_iterator.to_list(iter))
  should.equal(result, Ok([1, 2, 3]))
  promise.resolve(Nil)
}

pub fn to_list_empty_test() {
  let iter = async_iterator.from_list([])

  use result <- promise.await(async_iterator.to_list(iter))
  should.equal(result, Ok([]))
  promise.resolve(Nil)
}

pub fn from_list_to_list_roundtrip_test() {
  let original = [5, 10, 15, 20]
  let iter = async_iterator.from_list(original)

  use result <- promise.await(async_iterator.to_list(iter))
  should.equal(result, Ok(original))
  promise.resolve(Nil)
}
