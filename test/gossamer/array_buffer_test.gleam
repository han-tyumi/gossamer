import gleeunit/should
import gossamer/array_buffer
import gossamer/uint8_array

pub fn new_test() {
  let buffer = array_buffer.new(8)
  array_buffer.byte_length(buffer) |> should.equal(8)
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

pub fn is_detached_fresh_buffer_test() {
  let buffer = array_buffer.new(8)
  array_buffer.is_detached(buffer) |> should.be_false
}

pub fn transfer_test() {
  let buffer = array_buffer.new(8)
  let transferred = array_buffer.transfer(buffer)
  array_buffer.byte_length(transferred) |> should.equal(8)
  array_buffer.is_detached(buffer) |> should.be_true
  array_buffer.is_detached(transferred) |> should.be_false
}

pub fn slice_test() {
  let buffer = array_buffer.new(8)
  let sliced = array_buffer.slice(buffer, 4)
  array_buffer.byte_length(sliced) |> should.equal(4)
}

pub fn slice_with_end_test() {
  let buffer = array_buffer.new(8)
  let sliced = array_buffer.slice_with_end(buffer, 2, 6)
  array_buffer.byte_length(sliced) |> should.equal(4)
}
