import gleam/bit_array
import gleeunit/should
import gossamer/array_buffer
import gossamer/uint8_array

pub fn new_test() {
  uint8_array.new()
  |> uint8_array.to_bit_array
  |> should.equal(<<>>)
}

pub fn from_buffer_test() {
  let buf = array_buffer.new(4)
  uint8_array.from_buffer(buf)
  |> uint8_array.to_bit_array
  |> bit_array.byte_size
  |> should.equal(4)
}

pub fn from_buffer_range_test() {
  let buf = array_buffer.new(8)
  let assert Ok(array) =
    uint8_array.from_buffer_range(buf, byte_offset: 2, length: 4)
  uint8_array.to_bit_array(array)
  |> bit_array.byte_size
  |> should.equal(4)
}

pub fn from_buffer_range_out_of_range_test() {
  let buf = array_buffer.new(4)
  uint8_array.from_buffer_range(buf, byte_offset: 2, length: 4)
  |> should.equal(Error(Nil))
}

pub fn from_bit_array_test() {
  uint8_array.from_bit_array(<<1, 2, 3>>)
  |> uint8_array.to_bit_array
  |> should.equal(<<1, 2, 3>>)
}

pub fn to_bit_array_test() {
  uint8_array.from_bit_array(<<1, 2, 3>>)
  |> uint8_array.to_bit_array
  |> should.equal(<<1, 2, 3>>)
}

pub fn buffer_test() {
  let array = uint8_array.from_bit_array(<<1, 2, 3, 4>>)
  uint8_array.buffer(array)
  |> array_buffer.byte_length
  |> should.equal(4)
}
