import gleeunit/should
import gossamer/iterator
import gossamer/map

pub fn new_test() {
  let m = map.new()
  map.size(m) |> should.equal(0)
}

pub fn from_list_test() {
  let m = map.from_list([#("a", 1), #("b", 2)])
  map.size(m) |> should.equal(2)
  map.get(m, "a") |> should.equal(Ok(1))
  map.get(m, "b") |> should.equal(Ok(2))
}

pub fn set_and_get_test() {
  let m = map.new()
  map.set(m, "key", "value")
  map.get(m, "key") |> should.equal(Ok("value"))
}

pub fn get_missing_test() {
  let m = map.new()
  map.get(m, "missing") |> should.be_error
}

pub fn has_test() {
  let m = map.from_list([#("a", 1)])
  map.has(m, "a") |> should.be_true
  map.has(m, "b") |> should.be_false
}

pub fn delete_test() {
  let m = map.from_list([#("a", 1), #("b", 2)])
  map.delete(from: m, key: "a")
  map.has(m, "a") |> should.be_false
  map.size(m) |> should.equal(1)
}

pub fn delete_missing_test() {
  let m = map.new()
  map.delete(from: m, key: "missing")
  map.size(m) |> should.equal(0)
}

pub fn clear_test() {
  let m = map.from_list([#("a", 1), #("b", 2)])
  map.clear(m)
  map.size(m) |> should.equal(0)
}

pub fn keys_test() {
  let m = map.from_list([#("a", 1), #("b", 2)])
  map.keys(m) |> iterator.to_list |> should.equal(["a", "b"])
}

pub fn values_test() {
  let m = map.from_list([#("a", 1), #("b", 2)])
  map.values(m) |> iterator.to_list |> should.equal([1, 2])
}

pub fn entries_test() {
  let m = map.from_list([#("a", 1), #("b", 2)])
  map.entries(m) |> iterator.to_list |> should.equal([#("a", 1), #("b", 2)])
}

pub fn for_each_test() {
  let m = map.from_list([#("a", 1)])
  map.for_each(m, fn(_key, _value) { Nil })
}

pub fn set_chaining_test() {
  let m =
    map.new()
    |> map.set("a", 1)
    |> map.set("b", 2)
  map.size(m) |> should.equal(2)
}

pub fn set_overwrite_test() {
  let m = map.from_list([#("a", 1)])
  map.set(m, "a", 99)
  map.get(m, "a") |> should.equal(Ok(99))
}
