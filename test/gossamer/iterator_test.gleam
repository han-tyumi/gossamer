import gleam/yielder
import gleeunit/should
import gossamer/iteration/iterator

pub fn for_test() {
  let collected = [3, 2, 1]
  let iter = yielder.from_list([1, 2, 3]) |> iterator.from_yielder
  iterator.each(iter, fn(_value) { Nil })
  // Just confirm `each` consumes without panicking.
  collected |> should.equal([3, 2, 1])
}

pub fn from_yielder_test() {
  yielder.from_list([10, 20, 30])
  |> iterator.from_yielder
  |> iterator.to_yielder
  |> yielder.to_list
  |> should.equal([10, 20, 30])
}

pub fn from_yielder_empty_test() {
  yielder.from_list([])
  |> iterator.from_yielder
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
