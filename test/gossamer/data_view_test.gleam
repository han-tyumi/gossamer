import gleam/order
import gleeunit/should
import gossamer/array_buffer
import gossamer/big_int
import gossamer/data_view

fn fresh_view() -> data_view.DataView {
  let assert Ok(buffer) = array_buffer.new(16)
  let assert Ok(view) = data_view.new(buffer)
  view
}

pub fn new_test() {
  let view = fresh_view()
  data_view.byte_length(view) |> should.equal(Ok(16))
  data_view.byte_offset(view) |> should.equal(Ok(0))
}

pub fn buffer_test() {
  let view = fresh_view()
  let buf = data_view.buffer(view)
  array_buffer.byte_length(buf) |> should.equal(16)
}

pub fn new_range_test() {
  let assert Ok(buffer) = array_buffer.new(16)
  let assert Ok(view) =
    data_view.new_range(buffer, byte_offset: 4, byte_length: 8)
  data_view.byte_length(view) |> should.equal(Ok(8))
  data_view.byte_offset(view) |> should.equal(Ok(4))
}

pub fn new_detached_test() {
  let assert Ok(buffer) = array_buffer.new(16)
  let assert Ok(_) = array_buffer.transfer(buffer)
  data_view.new(buffer) |> should.be_error
}

pub fn byte_length_detached_test() {
  let assert Ok(buffer) = array_buffer.new(16)
  let assert Ok(view) = data_view.new(buffer)
  let assert Ok(_) = array_buffer.transfer(buffer)
  data_view.byte_length(view) |> should.be_error
}

pub fn byte_offset_detached_test() {
  let assert Ok(buffer) = array_buffer.new(16)
  let assert Ok(view) = data_view.new(buffer)
  let assert Ok(_) = array_buffer.transfer(buffer)
  data_view.byte_offset(view) |> should.be_error
}

pub fn new_range_out_of_bounds_test() {
  let assert Ok(buffer) = array_buffer.new(16)
  data_view.new_range(buffer, byte_offset: 4, byte_length: 100)
  |> should.be_error
}

pub fn int8_round_trip_test() {
  let view = fresh_view()
  let assert Ok(_) = data_view.set_int8(view, at_offset: 0, value: -42)
  data_view.get_int8(view, at_offset: 0) |> should.equal(Ok(-42))
}

pub fn uint8_round_trip_test() {
  let view = fresh_view()
  let assert Ok(_) = data_view.set_uint8(view, at_offset: 1, value: 200)
  data_view.get_uint8(view, at_offset: 1) |> should.equal(Ok(200))
}

pub fn int16_big_endian_test() {
  let view = fresh_view()
  let assert Ok(_) =
    data_view.set_int16(view, at_offset: 0, value: 0x1234, little_endian: False)
  data_view.get_uint8(view, at_offset: 0) |> should.equal(Ok(0x12))
  data_view.get_uint8(view, at_offset: 1) |> should.equal(Ok(0x34))
}

pub fn int16_little_endian_test() {
  let view = fresh_view()
  let assert Ok(_) =
    data_view.set_int16(view, at_offset: 0, value: 0x1234, little_endian: True)
  data_view.get_uint8(view, at_offset: 0) |> should.equal(Ok(0x34))
  data_view.get_uint8(view, at_offset: 1) |> should.equal(Ok(0x12))
}

pub fn uint16_round_trip_test() {
  let view = fresh_view()
  let assert Ok(_) =
    data_view.set_uint16(
      view,
      at_offset: 2,
      value: 0xABCD,
      little_endian: False,
    )
  data_view.get_uint16(view, at_offset: 2, little_endian: False)
  |> should.equal(Ok(0xABCD))
}

pub fn int32_round_trip_test() {
  let view = fresh_view()
  let assert Ok(_) =
    data_view.set_int32(
      view,
      at_offset: 0,
      value: -123_456,
      little_endian: True,
    )
  data_view.get_int32(view, at_offset: 0, little_endian: True)
  |> should.equal(Ok(-123_456))
}

pub fn uint32_round_trip_test() {
  let view = fresh_view()
  let assert Ok(_) =
    data_view.set_uint32(
      view,
      at_offset: 4,
      value: 0xDEADBEEF,
      little_endian: False,
    )
  data_view.get_uint32(view, at_offset: 4, little_endian: False)
  |> should.equal(Ok(0xDEADBEEF))
}

pub fn float16_round_trip_test() {
  let view = fresh_view()
  let assert Ok(_) =
    data_view.set_float16(view, at_offset: 0, value: 1.5, little_endian: True)
  let assert Ok(value) =
    data_view.get_float16(view, at_offset: 0, little_endian: True)
  value |> should.equal(1.5)
}

pub fn float32_round_trip_test() {
  let view = fresh_view()
  let assert Ok(_) =
    data_view.set_float32(view, at_offset: 0, value: 3.5, little_endian: True)
  let assert Ok(value) =
    data_view.get_float32(view, at_offset: 0, little_endian: True)
  value |> should.equal(3.5)
}

pub fn float64_round_trip_test() {
  let view = fresh_view()
  let assert Ok(_) =
    data_view.set_float64(view, at_offset: 0, value: 1.234, little_endian: True)
  let assert Ok(value) =
    data_view.get_float64(view, at_offset: 0, little_endian: True)
  value |> should.equal(1.234)
}

pub fn bigint64_round_trip_test() {
  let view = fresh_view()
  let large = big_int.from_int(1_000_000_000)
  let assert Ok(_) =
    data_view.set_bigint64(
      view,
      at_offset: 0,
      value: large,
      little_endian: False,
    )
  let assert Ok(read) =
    data_view.get_bigint64(view, at_offset: 0, little_endian: False)
  big_int.compare(read, large) |> should.equal(order.Eq)
}

pub fn biguint64_round_trip_test() {
  let view = fresh_view()
  let big = big_int.from_int(999_999_999)
  let assert Ok(_) =
    data_view.set_biguint64(view, at_offset: 8, value: big, little_endian: True)
  let assert Ok(read) =
    data_view.get_biguint64(view, at_offset: 8, little_endian: True)
  big_int.compare(read, big) |> should.equal(order.Eq)
}

pub fn get_out_of_range_test() {
  let view = fresh_view()
  data_view.get_int32(view, at_offset: 100, little_endian: False)
  |> should.be_error
}

pub fn set_out_of_range_test() {
  let view = fresh_view()
  data_view.set_int32(view, at_offset: 100, value: 1, little_endian: False)
  |> should.be_error
}

pub fn detached_buffer_get_test() {
  let assert Ok(buffer) = array_buffer.new(16)
  let assert Ok(view) = data_view.new(buffer)
  let assert Ok(_) = array_buffer.transfer(buffer)
  data_view.get_int8(view, at_offset: 0) |> should.be_error
}
