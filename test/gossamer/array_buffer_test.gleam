import gleeunit/should
import gossamer/buffer/array_buffer
import gossamer/buffer/uint8_array

pub fn new_test() {
  let buffer = array_buffer.new(8)
  array_buffer.byte_length(buffer) |> should.equal(8)
}

pub fn new_negative_test() {
  let buffer = array_buffer.new(-5)
  array_buffer.byte_length(buffer) |> should.equal(0)
}

pub fn is_view_uint8array_test() {
  let view = uint8_array.from_list([1, 2, 3])
  array_buffer.is_view(view) |> should.be_true
}

pub fn is_view_buffer_test() {
  let buffer = array_buffer.new(8)
  array_buffer.is_view(buffer) |> should.be_false
}

pub fn is_view_string_test() {
  array_buffer.is_view("not a view") |> should.be_false
}

pub fn to_bit_array_test() {
  let buffer =
    uint8_array.from_list([0x68, 0x69, 0x21, 0x00])
    |> uint8_array.buffer
  array_buffer.to_bit_array(buffer)
  |> should.equal(<<0x68, 0x69, 0x21, 0x00>>)
}
