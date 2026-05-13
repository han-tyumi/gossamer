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

pub fn to_bit_array_test() {
  let buffer =
    uint8_array.from_list([0x68, 0x69, 0x21, 0x00])
    |> uint8_array.buffer
  array_buffer.to_bit_array(buffer)
  |> should.equal(<<0x68, 0x69, 0x21, 0x00>>)
}

pub fn from_bit_array_test() {
  let buffer = array_buffer.from_bit_array(<<0x68, 0x69, 0x21, 0x00>>)
  array_buffer.byte_length(buffer) |> should.equal(4)
  array_buffer.to_bit_array(buffer)
  |> should.equal(<<0x68, 0x69, 0x21, 0x00>>)
}

pub fn from_bit_array_unaligned_pads_test() {
  // `<<0xA:5>>` is 5 bits — zero-padded to 1 byte at the FFI boundary.
  let buffer = array_buffer.from_bit_array(<<0xA:5>>)
  array_buffer.byte_length(buffer) |> should.equal(1)
}
