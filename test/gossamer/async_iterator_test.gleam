import gleam/javascript/promise
import gleeunit/should
import gossamer/iteration/async_iterator

pub fn new_to_list_test() {
  let iter = async_iterator.from_list([1, 2, 3])

  use result <- promise.await(async_iterator.to_list(iter))
  should.equal(result, Ok([1, 2, 3]))
  promise.resolve(Nil)
}

pub fn for_await_test() {
  let iter = async_iterator.from_list([1, 2, 3])

  use result <- promise.await(
    async_iterator.for_await(iter, fn(_value) { promise.resolve(Nil) }),
  )
  should.equal(result, Ok(Nil))
  promise.resolve(Nil)
}

pub fn from_list_to_list_roundtrip_test() {
  let original = [5, 10, 15, 20]
  let iter = async_iterator.from_list(original)

  use result <- promise.await(async_iterator.to_list(iter))
  should.equal(result, Ok(original))
  promise.resolve(Nil)
}

pub fn to_list_empty_test() {
  let iter = async_iterator.from_list([])

  use result <- promise.await(async_iterator.to_list(iter))
  should.equal(result, Ok([]))
  promise.resolve(Nil)
}
