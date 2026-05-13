import gleam/set as gleam_set
import gleeunit/should
import gossamer/set

pub fn new_round_trip_test() {
  set.new()
  |> set.to_set
  |> gleam_set.size
  |> should.equal(0)
}

pub fn from_list_test() {
  let s =
    set.from_list([1, 2, 3])
    |> set.to_set
  gleam_set.size(s) |> should.equal(3)
  gleam_set.contains(s, 2) |> should.be_true
}

pub fn from_list_deduplicates_test() {
  let s =
    set.from_list([1, 1, 2, 2, 3])
    |> set.to_set
  gleam_set.size(s) |> should.equal(3)
}

pub fn from_set_test() {
  let s =
    gleam_set.new()
    |> gleam_set.insert(1)
    |> gleam_set.insert(2)
    |> set.from_set
    |> set.to_set
  gleam_set.size(s) |> should.equal(2)
  gleam_set.contains(s, 1) |> should.be_true
}
