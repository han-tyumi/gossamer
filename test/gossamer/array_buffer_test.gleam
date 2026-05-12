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

pub fn slice_test() {
  let buffer = array_buffer.new(8)
  let copy = array_buffer.slice(buffer)
  array_buffer.byte_length(copy) |> should.equal(8)
}

pub fn slice_from_test() {
  let buffer = array_buffer.new(8)
  let sliced = array_buffer.slice_from(buffer, 4)
  array_buffer.byte_length(sliced) |> should.equal(4)
}

pub fn slice_range_test() {
  let buffer = array_buffer.new(8)
  let sliced = array_buffer.slice_range(buffer, 2, 6)
  array_buffer.byte_length(sliced) |> should.equal(4)
}

pub fn to_bit_array_test() {
  let buffer =
    uint8_array.from_list([0x68, 0x69, 0x21, 0x00])
    |> uint8_array.buffer
  let assert Ok(bits) = array_buffer.to_bit_array(buffer)
  bits |> should.equal(<<0x68, 0x69, 0x21, 0x00>>)
}
