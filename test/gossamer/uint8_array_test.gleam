import gleam/order
import gleeunit/should
import gossamer/uint8_array

pub fn new_test() {
  uint8_array.new()
  |> uint8_array.length()
  |> should.equal(0)
}

pub fn from_length_test() {
  uint8_array.from_length(5)
  |> uint8_array.length()
  |> should.equal(5)
}

pub fn from_list_test() {
  let array = uint8_array.from_list([1, 2, 3])
  uint8_array.length(array) |> should.equal(3)
  uint8_array.at(array, 0) |> should.equal(Ok(1))
  uint8_array.at(array, 2) |> should.equal(Ok(3))
}

pub fn byte_length_test() {
  uint8_array.from_length(10)
  |> uint8_array.byte_length()
  |> should.equal(10)
}

pub fn byte_offset_test() {
  uint8_array.from_length(10)
  |> uint8_array.byte_offset()
  |> should.equal(0)
}

pub fn at_test() {
  let array = uint8_array.from_list([10, 20, 30])
  uint8_array.at(array, 0) |> should.equal(Ok(10))
  uint8_array.at(array, -1) |> should.equal(Ok(30))
  uint8_array.at(array, 5) |> should.equal(Error(Nil))
}

pub fn includes_test() {
  let array = uint8_array.from_list([1, 2, 3])
  uint8_array.includes(array, 2) |> should.be_true()
  uint8_array.includes(array, 4) |> should.be_false()
}

pub fn includes_from_test() {
  let array = uint8_array.from_list([1, 2, 3])
  uint8_array.includes_from(array, 1, 1) |> should.be_false()
  uint8_array.includes_from(array, 2, 1) |> should.be_true()
}

pub fn index_of_test() {
  let array = uint8_array.from_list([1, 2, 3, 2])
  uint8_array.index_of(array, 2) |> should.equal(1)
  uint8_array.index_of(array, 5) |> should.equal(-1)
}

pub fn last_index_of_test() {
  let array = uint8_array.from_list([1, 2, 3, 2])
  uint8_array.last_index_of(array, 2) |> should.equal(3)
}

pub fn slice_test() {
  let array = uint8_array.from_list([1, 2, 3])
  let copy = uint8_array.slice(array)
  uint8_array.length(copy) |> should.equal(3)
  uint8_array.at(copy, 0) |> should.equal(Ok(1))
}

pub fn slice_range_test() {
  let array = uint8_array.from_list([1, 2, 3, 4, 5])
  let sliced = uint8_array.slice_range(array, 1, 3)
  uint8_array.length(sliced) |> should.equal(2)
  uint8_array.at(sliced, 0) |> should.equal(Ok(2))
  uint8_array.at(sliced, 1) |> should.equal(Ok(3))
}

pub fn fill_test() {
  let array = uint8_array.from_length(3)
  uint8_array.fill(array, 42)
  uint8_array.at(array, 0) |> should.equal(Ok(42))
  uint8_array.at(array, 2) |> should.equal(Ok(42))
}

pub fn reverse_test() {
  let array = uint8_array.from_list([1, 2, 3])
  uint8_array.reverse(array)
  uint8_array.at(array, 0) |> should.equal(Ok(3))
  uint8_array.at(array, 2) |> should.equal(Ok(1))
}

pub fn with_test() {
  let array = uint8_array.from_list([1, 2, 3])
  let updated = uint8_array.with(array, 1, 42)
  uint8_array.at(updated, 1) |> should.equal(Ok(42))
  uint8_array.at(array, 1) |> should.equal(Ok(2))
}

pub fn set_test() {
  let array = uint8_array.from_length(5)
  uint8_array.set(array, uint8_array.from_list([10, 20]))
  uint8_array.at(array, 0) |> should.equal(Ok(10))
  uint8_array.at(array, 1) |> should.equal(Ok(20))
  uint8_array.at(array, 2) |> should.equal(Ok(0))
}

pub fn copy_within_test() {
  let array = uint8_array.from_list([1, 2, 3, 4, 5])
  uint8_array.copy_within(array, 0, 3)
  uint8_array.at(array, 0) |> should.equal(Ok(4))
  uint8_array.at(array, 1) |> should.equal(Ok(5))
}

pub fn join_test() {
  uint8_array.from_list([1, 2, 3])
  |> uint8_array.join(",")
  |> should.equal("1,2,3")
}

pub fn every_test() {
  let array = uint8_array.from_list([2, 4, 6])
  uint8_array.every(array, fn(value) { value % 2 == 0 }) |> should.be_true()
  uint8_array.every(array, fn(value) { value > 3 }) |> should.be_false()
}

pub fn some_test() {
  let array = uint8_array.from_list([1, 2, 3])
  uint8_array.some(array, fn(value) { value == 2 }) |> should.be_true()
  uint8_array.some(array, fn(value) { value == 5 }) |> should.be_false()
}

pub fn find_test() {
  let array = uint8_array.from_list([1, 2, 3])
  uint8_array.find(array, fn(value) { value > 1 }) |> should.equal(Ok(2))
  uint8_array.find(array, fn(value) { value > 5 }) |> should.equal(Error(Nil))
}

pub fn find_index_test() {
  let array = uint8_array.from_list([10, 20, 30])
  uint8_array.find_index(array, fn(value) { value > 15 }) |> should.equal(1)
  uint8_array.find_index(array, fn(value) { value > 50 }) |> should.equal(-1)
}

pub fn find_last_test() {
  let array = uint8_array.from_list([1, 2, 3])
  uint8_array.find_last(array, fn(value) { value > 1 })
  |> should.equal(Ok(3))
}

pub fn find_last_index_test() {
  let array = uint8_array.from_list([10, 20, 30])
  uint8_array.find_last_index(array, fn(value) { value > 15 })
  |> should.equal(2)
}

pub fn filter_test() {
  let array = uint8_array.from_list([1, 2, 3, 4, 5])
  let filtered = uint8_array.filter(array, fn(value) { value > 3 })
  uint8_array.length(filtered) |> should.equal(2)
  uint8_array.at(filtered, 0) |> should.equal(Ok(4))
}

pub fn map_test() {
  let array = uint8_array.from_list([1, 2, 3])
  let mapped = uint8_array.map(array, fn(value) { value * 2 })
  uint8_array.at(mapped, 0) |> should.equal(Ok(2))
  uint8_array.at(mapped, 2) |> should.equal(Ok(6))
}

pub fn index_map_test() {
  let array = uint8_array.from_list([10, 20, 30])
  let mapped = uint8_array.index_map(array, fn(value, index) { value + index })
  uint8_array.at(mapped, 0) |> should.equal(Ok(10))
  uint8_array.at(mapped, 1) |> should.equal(Ok(21))
  uint8_array.at(mapped, 2) |> should.equal(Ok(32))
}

pub fn sort_test() {
  let array = uint8_array.from_list([3, 1, 2])
  uint8_array.sort(array, fn(a, b) {
    case a < b {
      True -> order.Lt
      False ->
        case a > b {
          True -> order.Gt
          False -> order.Eq
        }
    }
  })
  uint8_array.at(array, 0) |> should.equal(Ok(1))
  uint8_array.at(array, 2) |> should.equal(Ok(3))
}

pub fn to_sorted_test() {
  let array = uint8_array.from_list([3, 1, 2])
  let sorted =
    uint8_array.to_sorted(array, fn(a, b) {
      case a < b {
        True -> order.Lt
        False ->
          case a > b {
            True -> order.Gt
            False -> order.Eq
          }
      }
    })
  uint8_array.at(array, 0) |> should.equal(Ok(3))
  uint8_array.at(sorted, 0) |> should.equal(Ok(1))
}

pub fn to_reversed_test() {
  let array = uint8_array.from_list([1, 2, 3])
  let reversed = uint8_array.to_reversed(array)
  uint8_array.at(array, 0) |> should.equal(Ok(1))
  uint8_array.at(reversed, 0) |> should.equal(Ok(3))
}

pub fn reduce_test() {
  uint8_array.from_list([1, 2, 3])
  |> uint8_array.reduce(0, fn(acc, value) { acc + value })
  |> should.equal(6)
}

pub fn reduce_right_test() {
  uint8_array.from_list([1, 2, 3])
  |> uint8_array.reduce_right("", fn(acc, value) {
    acc
    <> case value {
      1 -> "1"
      2 -> "2"
      3 -> "3"
      _ -> ""
    }
  })
  |> should.equal("321")
}

pub fn to_list_test() {
  uint8_array.from_list([1, 2, 3])
  |> uint8_array.to_list()
  |> should.equal([1, 2, 3])
}

pub fn to_base64_test() {
  uint8_array.from_list([72, 101, 108, 108, 111])
  |> uint8_array.to_base64()
  |> should.equal("SGVsbG8=")
}

pub fn from_base64_test() {
  uint8_array.from_base64("SGVsbG8=")
  |> uint8_array.to_list()
  |> should.equal([72, 101, 108, 108, 111])
}

pub fn to_hex_test() {
  uint8_array.from_list([72, 101, 108, 108, 111])
  |> uint8_array.to_hex()
  |> should.equal("48656c6c6f")
}

pub fn from_hex_test() {
  uint8_array.from_hex("48656c6c6f")
  |> uint8_array.to_list()
  |> should.equal([72, 101, 108, 108, 111])
}

pub fn slice_from_test() {
  let array = uint8_array.from_list([1, 2, 3, 4, 5])
  let sliced = uint8_array.slice_from(array, 3)
  uint8_array.to_list(sliced) |> should.equal([4, 5])
}

pub fn subarray_test() {
  let array = uint8_array.from_list([1, 2, 3, 4, 5])
  let sub = uint8_array.subarray(array, 1, 3)
  uint8_array.to_list(sub) |> should.equal([2, 3])
}

pub fn set_with_offset_test() {
  let array = uint8_array.from_length(5)
  uint8_array.set_with_offset(array, uint8_array.from_list([10, 20]), 2)
  uint8_array.to_list(array) |> should.equal([0, 0, 10, 20, 0])
}

pub fn fill_range_test() {
  let array = uint8_array.from_length(5)
  uint8_array.fill_range(array, 99, 1, 3)
  uint8_array.to_list(array) |> should.equal([0, 99, 99, 0, 0])
}

pub fn for_each_test() {
  // Verify for_each visits every element without crashing.
  uint8_array.from_list([1, 2, 3])
  |> uint8_array.for_each(fn(_value) { Nil })
}

pub fn set_from_base64_test() {
  let array = uint8_array.from_length(10)
  let #(read, written) = uint8_array.set_from_base64(array, "SGVsbG8=")
  read |> should.equal(8)
  written |> should.equal(5)
}

pub fn set_from_hex_test() {
  let array = uint8_array.from_length(10)
  let #(read, written) = uint8_array.set_from_hex(array, "48656c6c6f")
  read |> should.equal(10)
  written |> should.equal(5)
}
