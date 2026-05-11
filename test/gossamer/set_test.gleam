import gleam/set as gleam_set
import gleam/yielder
import gleeunit/should
import gossamer/set

pub fn new_test() {
  let s = set.new()
  set.size(s) |> should.equal(0)
}

pub fn from_list_test() {
  let s = set.from_list([1, 2, 3])
  set.size(s) |> should.equal(3)
}

pub fn from_list_deduplicates_test() {
  let s = set.from_list([1, 1, 2, 2, 3])
  set.size(s) |> should.equal(3)
}

pub fn from_set_test() {
  let s =
    gleam_set.new()
    |> gleam_set.insert(1)
    |> gleam_set.insert(2)
    |> set.from_set
  set.size(s) |> should.equal(2)
  set.has(s, 1) |> should.be_true
  set.has(s, 2) |> should.be_true
}

pub fn to_set_test() {
  let s =
    set.from_list([1, 2, 3])
    |> set.to_set
  gleam_set.size(s) |> should.equal(3)
  gleam_set.contains(s, 2) |> should.be_true
}

pub fn has_test() {
  let s = set.from_list([1, 2, 3])
  set.has(s, 2) |> should.be_true
  set.has(s, 99) |> should.be_false
}

pub fn values_test() {
  let s = set.from_list([1, 2, 3])
  set.values(s)
  |> yielder.to_list
  |> should.equal([1, 2, 3])
}

pub fn entries_test() {
  let s = set.from_list([1, 2])
  set.entries(s)
  |> yielder.to_list
  |> should.equal([#(1, 1), #(2, 2)])
}
