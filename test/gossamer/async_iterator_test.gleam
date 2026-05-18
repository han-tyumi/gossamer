import gleam/javascript/promise
import gleeunit/should
import gossamer/iteration/async_iterator
import gossamer/iteration/async_yielder

pub fn new_to_list_test() {
  let iter = async_iterator.from_list([1, 2, 3])

  use result <- promise.await(async_iterator.to_list(iter))
  should.equal(result, Ok([1, 2, 3]))
  promise.resolve(Nil)
}

pub fn each_test() {
  let iter = async_iterator.from_list([1, 2, 3])

  use result <- promise.await(
    async_iterator.each(iter, fn(_value) { promise.resolve(Nil) }),
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

pub fn from_async_yielder_test() {
  let yielder = async_yielder.from_list([1, 2, 3])
  let iter = async_iterator.from_async_yielder(yielder)

  use result <- promise.await(async_iterator.to_list(iter))
  should.equal(result, Ok([1, 2, 3]))
  promise.resolve(Nil)
}

pub fn to_async_yielder_test() {
  let iter = async_iterator.from_list([1, 2, 3])
  let yielder = async_iterator.to_async_yielder(iter)

  use result <- promise.map(async_yielder.to_list(yielder))
  should.equal(result, [1, 2, 3])
}

pub fn async_yielder_roundtrip_test() {
  let original = [1, 2, 3, 4, 5]
  let result =
    async_yielder.from_list(original)
    |> async_iterator.from_async_yielder
    |> async_iterator.to_async_yielder
    |> async_yielder.to_list

  use result <- promise.map(result)
  should.equal(result, original)
}
