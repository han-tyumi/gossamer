import gleeunit/should
import gossamer/array_buffer
import gossamer/uint8_array

pub fn new_test() {
  let assert Ok(buffer) = array_buffer.new(8)
  array_buffer.byte_length(buffer) |> should.equal(8)
}

pub fn is_view_uint8array_test() {
  let view = uint8_array.from_list([1, 2, 3])
  array_buffer.is_view(view) |> should.be_true
}

pub fn is_view_buffer_test() {
  let assert Ok(buffer) = array_buffer.new(8)
  array_buffer.is_view(buffer) |> should.be_false
}

pub fn is_view_string_test() {
  array_buffer.is_view("not a view") |> should.be_false
}

pub fn is_detached_fresh_buffer_test() {
  let assert Ok(buffer) = array_buffer.new(8)
  array_buffer.is_detached(buffer) |> should.be_false
}

pub fn transfer_test() {
  let assert Ok(buffer) = array_buffer.new(8)
  let assert Ok(transferred) = array_buffer.transfer(buffer)
  array_buffer.byte_length(transferred) |> should.equal(8)
  array_buffer.is_detached(buffer) |> should.be_true
  array_buffer.is_detached(transferred) |> should.be_false
}

pub fn slice_test() {
  let assert Ok(buffer) = array_buffer.new(8)
  let copy = array_buffer.slice(buffer)
  array_buffer.byte_length(copy) |> should.equal(8)
}

pub fn slice_from_test() {
  let assert Ok(buffer) = array_buffer.new(8)
  let sliced = array_buffer.slice_from(buffer, 4)
  array_buffer.byte_length(sliced) |> should.equal(4)
}

pub fn slice_range_test() {
  let assert Ok(buffer) = array_buffer.new(8)
  let sliced = array_buffer.slice_range(buffer, 2, 6)
  array_buffer.byte_length(sliced) |> should.equal(4)
}

pub fn new_resizable_test() {
  let assert Ok(buffer) = array_buffer.new_resizable(8, 16)
  array_buffer.byte_length(buffer) |> should.equal(8)
  array_buffer.max_byte_length(buffer) |> should.equal(16)
  array_buffer.is_resizable(buffer) |> should.be_true()
}

pub fn is_resizable_fixed_test() {
  let assert Ok(buffer) = array_buffer.new(8)
  array_buffer.is_resizable(buffer) |> should.be_false()
}

pub fn max_byte_length_fixed_test() {
  let assert Ok(buffer) = array_buffer.new(8)
  array_buffer.max_byte_length(buffer) |> should.equal(8)
}

pub fn resize_test() {
  let assert Ok(buffer) = array_buffer.new_resizable(8, 16)
  let assert Ok(_) = array_buffer.resize(buffer, 12)
  array_buffer.byte_length(buffer) |> should.equal(12)
}

pub fn resize_exceeds_max_test() {
  let assert Ok(buffer) = array_buffer.new_resizable(8, 16)
  array_buffer.resize(buffer, 32) |> should.be_error()
}

pub fn resize_fixed_buffer_test() {
  let assert Ok(buffer) = array_buffer.new(8)
  array_buffer.resize(buffer, 4) |> should.be_error()
}
