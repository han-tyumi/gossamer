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

pub fn add_test() {
  let s = set.new()
  set.add(s, 42)
  set.has(s, 42) |> should.be_true
}

pub fn add_chaining_test() {
  let s =
    set.new()
    |> set.add(1)
    |> set.add(2)
    |> set.add(3)
  set.size(s) |> should.equal(3)
}

pub fn has_test() {
  let s = set.from_list([1, 2, 3])
  set.has(s, 2) |> should.be_true
  set.has(s, 99) |> should.be_false
}

pub fn delete_test() {
  let s = set.from_list([1, 2, 3])
  set.delete(s, 2) |> should.be_true
  set.has(s, 2) |> should.be_false
  set.size(s) |> should.equal(2)
}

pub fn delete_missing_test() {
  let s = set.new()
  set.delete(s, 99) |> should.be_false
}

pub fn clear_test() {
  let s = set.from_list([1, 2, 3])
  set.clear(s)
  set.size(s) |> should.equal(0)
}

pub fn values_test() {
  let s = set.from_list([1, 2, 3])
  set.values(s) |> should.equal([1, 2, 3])
}

pub fn entries_test() {
  let s = set.from_list([1, 2])
  set.entries(s) |> should.equal([#(1, 1), #(2, 2)])
}

pub fn for_each_test() {
  let s = set.from_list([1, 2])
  set.for_each(s, fn(_value) { Nil })
}

pub fn union_test() {
  let a = set.from_list([1, 2, 3])
  let b = set.from_list([3, 4, 5])
  let result = set.union(a, b)
  set.size(result) |> should.equal(5)
}

pub fn intersection_test() {
  let a = set.from_list([1, 2, 3])
  let b = set.from_list([2, 3, 4])
  let result = set.intersection(a, b)
  set.values(result) |> should.equal([2, 3])
}

pub fn difference_test() {
  let a = set.from_list([1, 2, 3])
  let b = set.from_list([2, 3, 4])
  let result = set.difference(a, b)
  set.values(result) |> should.equal([1])
}

pub fn symmetric_difference_test() {
  let a = set.from_list([1, 2, 3])
  let b = set.from_list([2, 3, 4])
  let result = set.symmetric_difference(a, b)
  set.size(result) |> should.equal(2)
  set.has(result, 1) |> should.be_true
  set.has(result, 4) |> should.be_true
}

pub fn is_subset_of_test() {
  let a = set.from_list([1, 2])
  let b = set.from_list([1, 2, 3])
  set.is_subset_of(a, b) |> should.be_true
  set.is_subset_of(b, a) |> should.be_false
}

pub fn is_superset_of_test() {
  let a = set.from_list([1, 2, 3])
  let b = set.from_list([1, 2])
  set.is_superset_of(a, b) |> should.be_true
  set.is_superset_of(b, a) |> should.be_false
}

pub fn is_disjoint_from_test() {
  let a = set.from_list([1, 2])
  let b = set.from_list([3, 4])
  let c = set.from_list([2, 3])
  set.is_disjoint_from(a, b) |> should.be_true
  set.is_disjoint_from(a, c) |> should.be_false
}
