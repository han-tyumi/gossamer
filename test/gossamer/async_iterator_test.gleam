import gleam/javascript/promise
import gleeunit/should
import gossamer/iteration/async_iterator
import gossamer/iteration/async_yielder

pub fn each_test() {
  let iter =
    async_yielder.from_list([1, 2, 3])
    |> async_iterator.from_async_yielder

  use Nil <- promise.await(
    async_iterator.each(iter, fn(_value) { promise.resolve(Nil) }),
  )
  promise.resolve(Nil)
}

pub fn from_async_yielder_test() {
  let result =
    async_yielder.from_list([1, 2, 3])
    |> async_iterator.from_async_yielder
    |> async_iterator.to_async_yielder
    |> async_yielder.to_list

  use result <- promise.map(result)
  should.equal(result, [1, 2, 3])
}

pub fn to_async_yielder_test() {
  let result =
    async_yielder.from_list([5, 10, 15])
    |> async_iterator.from_async_yielder
    |> async_iterator.to_async_yielder
    |> async_yielder.to_list

  use result <- promise.map(result)
  should.equal(result, [5, 10, 15])
}

pub fn async_yielder_roundtrip_empty_test() {
  let result =
    async_yielder.empty()
    |> async_iterator.from_async_yielder
    |> async_iterator.to_async_yielder
    |> async_yielder.to_list

  use result <- promise.map(result)
  should.equal(result, [])
}
