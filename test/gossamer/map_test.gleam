import gleam/dict
import gleeunit/should
import gossamer/map

pub fn new_round_trip_test() {
  map.new()
  |> map.to_dict
  |> dict.size
  |> should.equal(0)
}

pub fn from_list_test() {
  let d =
    map.from_list([#("a", 1), #("b", 2)])
    |> map.to_dict
  dict.size(d) |> should.equal(2)
  dict.get(d, "a") |> should.equal(Ok(1))
  dict.get(d, "b") |> should.equal(Ok(2))
}

pub fn from_dict_test() {
  let d =
    dict.new()
    |> dict.insert("a", 1)
    |> dict.insert("b", 2)
    |> map.from_dict
    |> map.to_dict
  dict.size(d) |> should.equal(2)
  dict.get(d, "a") |> should.equal(Ok(1))
}
