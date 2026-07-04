import gleam/dict
import gleam/yielder
import gleeunit/should
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

pub fn from_dict_test() {
  let m =
    dict.new()
    |> dict.insert("a", 1)
    |> dict.insert("b", 2)
    |> map.from_dict
  map.size(m) |> should.equal(2)
  map.get(m, "a") |> should.equal(Ok(1))
}

pub fn to_dict_test() {
  let d =
    map.from_list([#("a", 1), #("b", 2)])
    |> map.to_dict
  dict.size(d) |> should.equal(2)
  dict.get(d, "a") |> should.equal(Ok(1))
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

pub fn keys_test() {
  let m = map.from_list([#("a", 1), #("b", 2)])
  map.keys(m)
  |> yielder.to_list
  |> should.equal(["a", "b"])
}

pub fn values_test() {
  let m = map.from_list([#("a", 1), #("b", 2)])
  map.values(m)
  |> yielder.to_list
  |> should.equal([1, 2])
}

pub fn entries_test() {
  let m = map.from_list([#("a", 1), #("b", 2)])
  map.entries(m)
  |> yielder.to_list
  |> should.equal([#("a", 1), #("b", 2)])
}

pub fn get_nil_value_test() {
  let m = map.from_list([#("a", Nil)])
  map.get(m, "a") |> should.equal(Ok(Nil))
  map.get(m, "b") |> should.equal(Error(Nil))
}

pub fn keys_retraversable_test() {
  let keys = map.from_list([#("a", 1), #("b", 2)]) |> map.keys
  keys |> yielder.to_list |> should.equal(["a", "b"])
  keys |> yielder.to_list |> should.equal(["a", "b"])
}
