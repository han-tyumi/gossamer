import gleeunit/should
import gossamer/buffer/array_buffer
import gossamer/buffer/uint8_array

pub fn new_test() {
  uint8_array.new()
  |> uint8_array.length()
  |> should.equal(0)
}

pub fn from_list_test() {
  let array = uint8_array.from_list([1, 2, 3])
  uint8_array.length(array) |> should.equal(3)
  uint8_array.at(array, 0) |> should.equal(Ok(1))
  uint8_array.at(array, 2) |> should.equal(Ok(3))
}

pub fn from_list_wraps_out_of_range_test() {
  // Values outside 0–255 wrap modulo 256, matching the JS constructor.
  let array = uint8_array.from_list([257])
  uint8_array.at(array, 0) |> should.equal(Ok(1))
}

pub fn at_test() {
  let array = uint8_array.from_list([10, 20, 30])
  uint8_array.at(array, 0) |> should.equal(Ok(10))
  uint8_array.at(array, -1) |> should.equal(Ok(30))
  uint8_array.at(array, 5) |> should.equal(Error(Nil))
}

pub fn from_buffer_test() {
  let buf = array_buffer.new(4)
  uint8_array.from_buffer(buf) |> uint8_array.length |> should.equal(4)
}

pub fn from_buffer_range_test() {
  let buf = array_buffer.new(8)
  let assert Ok(array) =
    uint8_array.from_buffer_range(buf, byte_offset: 2, length: 4)
  uint8_array.length(array) |> should.equal(4)
}

pub fn from_buffer_range_out_of_range_test() {
  let buf = array_buffer.new(4)
  uint8_array.from_buffer_range(buf, byte_offset: 2, length: 4)
  |> should.equal(Error(Nil))
}

pub fn to_list_test() {
  uint8_array.from_list([5, 6, 7])
  |> uint8_array.to_list
  |> should.equal([5, 6, 7])
}

pub fn from_bit_array_test() {
  uint8_array.from_bit_array(<<1, 2, 3>>)
  |> uint8_array.to_list
  |> should.equal([1, 2, 3])
}

pub fn to_bit_array_test() {
  uint8_array.from_list([1, 2, 3])
  |> uint8_array.to_bit_array
  |> should.equal(<<1, 2, 3>>)
}

pub fn buffer_test() {
  let array = uint8_array.from_list([1, 2, 3, 4])
  uint8_array.buffer(array)
  |> array_buffer.byte_length
  |> should.equal(4)
}
