import gleam/int
import gleeunit/should
import gossamer/array
import gossamer/iterator

pub fn new_test() {
  let a = array.new()
  array.length(a) |> should.equal(0)
}

pub fn from_list_test() {
  let a = array.from_list([1, 2, 3])
  array.length(a) |> should.equal(3)
  array.at(a, 0) |> should.equal(Ok(1))
}

pub fn from_list_mapped_test() {
  let a =
    array.from_list_mapped(["a", "bb", "ccc"], with: fn(s) {
      case s {
        "a" -> 1
        "bb" -> 2
        _ -> 3
      }
    })
  array.to_list(a) |> should.equal([1, 2, 3])
}

pub fn at_test() {
  let a = array.from_list([10, 20, 30])
  array.at(a, 0) |> should.equal(Ok(10))
  array.at(a, -1) |> should.equal(Ok(30))
  array.at(a, 99) |> should.be_error
}

pub fn includes_test() {
  let a = array.from_list([1, 2, 3])
  array.includes(a, 2) |> should.be_true
  array.includes(a, 99) |> should.be_false
}

pub fn index_of_test() {
  let a = array.from_list([10, 20, 30, 20])
  array.index_of(a, 20) |> should.equal(Ok(1))
  array.index_of(a, 99) |> should.be_error
}

pub fn last_index_of_test() {
  let a = array.from_list([10, 20, 30, 20])
  array.last_index_of(a, 20) |> should.equal(Ok(3))
}

pub fn find_test() {
  let a = array.from_list([1, 2, 3, 4])
  array.find(a, one_that: fn(value) { value > 2 }) |> should.equal(Ok(3))
  array.find(a, one_that: fn(value) { value > 99 }) |> should.be_error
}

pub fn find_index_test() {
  let a = array.from_list([10, 20, 30])
  array.find_index(a, one_that: fn(value) { value > 15 }) |> should.equal(Ok(1))
  array.find_index(a, one_that: fn(value) { value > 99 }) |> should.be_error
}

pub fn find_last_test() {
  let a = array.from_list([1, 2, 3, 4])
  array.find_last(a, one_that: fn(value) { value < 3 }) |> should.equal(Ok(2))
}

pub fn find_last_index_test() {
  let a = array.from_list([1, 2, 3, 2, 1])
  array.find_last_index(a, one_that: fn(value) { value == 2 })
  |> should.equal(Ok(3))
}

pub fn every_test() {
  let a = array.from_list([2, 4, 6])
  array.every(a, satisfying: fn(value) { value % 2 == 0 }) |> should.be_true
  array.every(a, satisfying: fn(value) { value > 3 }) |> should.be_false
}

pub fn some_test() {
  let a = array.from_list([1, 2, 3])
  array.some(a, satisfying: fn(value) { value == 2 }) |> should.be_true
  array.some(a, satisfying: fn(value) { value > 99 }) |> should.be_false
}

pub fn slice_test() {
  let a = array.from_list([1, 2, 3, 4, 5])
  array.slice(a) |> array.to_list |> should.equal([1, 2, 3, 4, 5])
  array.slice_from(a, 2) |> array.to_list |> should.equal([3, 4, 5])
  array.slice_range(a, 1, 3) |> array.to_list |> should.equal([2, 3])
}

pub fn map_test() {
  array.from_list([1, 2, 3])
  |> array.map(with: fn(value) { value * 10 })
  |> array.to_list
  |> should.equal([10, 20, 30])
}

pub fn map_type_change_test() {
  array.from_list([1, 2, 3])
  |> array.map(with: fn(value) {
    case value {
      1 -> "one"
      2 -> "two"
      _ -> "other"
    }
  })
  |> array.to_list
  |> should.equal(["one", "two", "other"])
}

pub fn filter_test() {
  array.from_list([1, 2, 3, 4, 5])
  |> array.filter(keeping: fn(value) { value > 3 })
  |> array.to_list
  |> should.equal([4, 5])
}

pub fn flat_test() {
  let nested =
    array.from_list([
      array.from_list([1, 2]),
      array.from_list([3, 4]),
    ])
  array.flat(nested) |> array.to_list |> should.equal([1, 2, 3, 4])
}

pub fn flat_map_test() {
  array.from_list([1, 2, 3])
  |> array.flat_map(with: fn(value) { array.from_list([value, value * 10]) })
  |> array.to_list
  |> should.equal([1, 10, 2, 20, 3, 30])
}

pub fn concat_test() {
  let a = array.from_list([1, 2])
  let b = array.from_list([3, 4])
  array.concat(a, b) |> array.to_list |> should.equal([1, 2, 3, 4])
}

pub fn to_reversed_test() {
  let a = array.from_list([1, 2, 3])
  array.to_reversed(a) |> array.to_list |> should.equal([3, 2, 1])
  array.to_list(a) |> should.equal([1, 2, 3])
}

pub fn to_sorted_test() {
  let a = array.from_list([3, 1, 2])
  array.to_sorted(a, by: fn(x, y) { int.compare(x, y) })
  |> array.to_list
  |> should.equal([1, 2, 3])
  array.to_list(a) |> should.equal([3, 1, 2])
}

pub fn with_test() {
  let a = array.from_list([1, 2, 3])
  let assert Ok(updated) = array.with(a, at_index: 1, value: 99)
  array.to_list(updated) |> should.equal([1, 99, 3])
  array.to_list(a) |> should.equal([1, 2, 3])
}

pub fn with_out_of_range_test() {
  let a = array.from_list([1, 2, 3])
  let assert Error(_) = array.with(a, at_index: 100, value: 99)
  let assert Error(_) = array.with(a, at_index: -100, value: 99)
}

pub fn to_spliced_test() {
  let a = array.from_list([1, 2, 3, 4, 5])
  array.to_spliced(a, from: 1, removing: 2)
  |> array.to_list
  |> should.equal([1, 4, 5])
}

pub fn to_spliced_with_test() {
  let a = array.from_list([1, 2, 3, 4, 5])
  array.to_spliced_with(a, from: 1, removing: 2, inserting: [10, 20])
  |> array.to_list
  |> should.equal([1, 10, 20, 4, 5])
}

pub fn push_test() {
  let a = array.new()
  array.push(a, 1)
  array.push(a, 2)
  array.to_list(a) |> should.equal([1, 2])
}

pub fn push_chaining_test() {
  let a =
    array.new()
    |> array.push(1)
    |> array.push(2)
    |> array.push(3)
  array.length(a) |> should.equal(3)
}

pub fn pop_test() {
  let a = array.from_list([1, 2, 3])
  array.pop(a) |> should.equal(Ok(3))
  array.length(a) |> should.equal(2)
}

pub fn pop_empty_test() {
  let a = array.new()
  array.pop(a) |> should.be_error
}

pub fn unshift_test() {
  let a = array.from_list([2, 3])
  array.unshift(a, 1)
  array.to_list(a) |> should.equal([1, 2, 3])
}

pub fn shift_test() {
  let a = array.from_list([1, 2, 3])
  array.shift(a) |> should.equal(Ok(1))
  array.length(a) |> should.equal(2)
}

pub fn shift_empty_test() {
  let a = array.new()
  array.shift(a) |> should.be_error
}

pub fn reverse_test() {
  let a = array.from_list([1, 2, 3])
  array.reverse(a)
  array.to_list(a) |> should.equal([3, 2, 1])
}

pub fn sort_test() {
  let a = array.from_list([3, 1, 2])
  array.sort(a, by: fn(x, y) { int.compare(x, y) })
  array.to_list(a) |> should.equal([1, 2, 3])
}

pub fn fill_test() {
  let a = array.from_list([1, 2, 3])
  array.fill(a, with: 0)
  array.to_list(a) |> should.equal([0, 0, 0])
}

pub fn fill_range_test() {
  let a = array.from_list([1, 2, 3, 4])
  array.fill_range(a, with: 0, from: 1, to: 3)
  array.to_list(a) |> should.equal([1, 0, 0, 4])
}

pub fn splice_test() {
  let a = array.from_list([1, 2, 3, 4, 5])
  let removed = array.splice(a, from: 1, removing: 2)
  array.to_list(removed) |> should.equal([2, 3])
  array.to_list(a) |> should.equal([1, 4, 5])
}

pub fn splice_with_test() {
  let a = array.from_list([1, 2, 3, 4, 5])
  let removed = array.splice_with(a, from: 1, removing: 2, inserting: [10, 20])
  array.to_list(removed) |> should.equal([2, 3])
  array.to_list(a) |> should.equal([1, 10, 20, 4, 5])
}

pub fn reduce_test() {
  array.from_list([1, 2, 3, 4])
  |> array.reduce(from: 0, with: fn(sum, value) { sum + value })
  |> should.equal(10)
}

pub fn reduce_right_test() {
  array.from_list(["a", "b", "c"])
  |> array.reduce_right(from: "", with: fn(acc, value) { acc <> value })
  |> should.equal("cba")
}

pub fn for_each_test() {
  let a = array.from_list([1, 2, 3])
  array.for_each(a, fn(_value) { Nil })
}

pub fn join_test() {
  array.from_list(["a", "b", "c"])
  |> array.join(with: ", ")
  |> should.equal("a, b, c")
}

pub fn to_string_test() {
  array.from_list([1, 2, 3])
  |> array.to_string
  |> should.equal("1,2,3")
}

pub fn to_list_roundtrip_test() {
  let original = [1, 2, 3, 4, 5]
  array.from_list(original)
  |> array.to_list
  |> should.equal(original)
}

pub fn keys_test() {
  let a = array.from_list(["a", "b", "c"])
  array.keys(a) |> iterator.to_list |> should.equal([0, 1, 2])
}

pub fn values_test() {
  let a = array.from_list([10, 20, 30])
  array.values(a) |> iterator.to_list |> should.equal([10, 20, 30])
}

pub fn entries_test() {
  let a = array.from_list(["a", "b"])
  array.entries(a) |> iterator.to_list |> should.equal([#(0, "a"), #(1, "b")])
}

pub fn copy_within_test() {
  let a = array.from_list([1, 2, 3, 4, 5])
  array.copy_within(a, to: 0, from: 3)
  array.to_list(a) |> should.equal([4, 5, 3, 4, 5])
}
