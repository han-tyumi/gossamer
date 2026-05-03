// Smoke tests for the per-type typed array modules added in v9.
// Each module follows the same surface; one round-trip per module is
// enough to confirm the FFI bindings, since the implementation is
// templated.

import gleeunit/should
import gossamer/array_buffer
import gossamer/big_int
import gossamer/bigint64_array
import gossamer/biguint64_array
import gossamer/float16_array
import gossamer/float32_array
import gossamer/float64_array
import gossamer/int16_array
import gossamer/int32_array
import gossamer/int8_array
import gossamer/uint16_array
import gossamer/uint32_array
import gossamer/uint8_clamped_array

pub fn int8_round_trip_test() {
  let arr = int8_array.from_list([1, 2, -128, 127])
  int8_array.length(arr) |> should.equal(4)
  int8_array.byte_length(arr) |> should.equal(4)
  int8_array.at(arr, index: 2) |> should.equal(Ok(-128))
}

pub fn int8_wraps_overflow_test() {
  // 200 is outside Int8 range; JS wraps mod 256 to -56.
  let arr = int8_array.from_list([200])
  int8_array.at(arr, index: 0) |> should.equal(Ok(-56))
}

pub fn uint8_clamped_clamps_test() {
  // Unlike Uint8Array which wraps, Uint8ClampedArray clamps.
  let arr = uint8_clamped_array.from_list([-10, 300])
  uint8_clamped_array.at(arr, index: 0) |> should.equal(Ok(0))
  uint8_clamped_array.at(arr, index: 1) |> should.equal(Ok(255))
}

pub fn int16_round_trip_test() {
  let arr = int16_array.from_list([-32_768, 0, 32_767])
  int16_array.length(arr) |> should.equal(3)
  int16_array.byte_length(arr) |> should.equal(6)
  int16_array.at(arr, index: 0) |> should.equal(Ok(-32_768))
}

pub fn uint16_round_trip_test() {
  let arr = uint16_array.from_list([0, 65_535])
  uint16_array.length(arr) |> should.equal(2)
  uint16_array.byte_length(arr) |> should.equal(4)
  uint16_array.at(arr, index: 1) |> should.equal(Ok(65_535))
}

pub fn int32_round_trip_test() {
  let arr = int32_array.from_list([-2_147_483_648, 0, 2_147_483_647])
  int32_array.length(arr) |> should.equal(3)
  int32_array.byte_length(arr) |> should.equal(12)
  int32_array.at(arr, index: 2) |> should.equal(Ok(2_147_483_647))
}

pub fn uint32_round_trip_test() {
  let arr = uint32_array.from_list([0, 4_294_967_295])
  uint32_array.length(arr) |> should.equal(2)
  uint32_array.byte_length(arr) |> should.equal(8)
  uint32_array.at(arr, index: 1) |> should.equal(Ok(4_294_967_295))
}

pub fn float32_round_trip_test() {
  let arr = float32_array.from_list([1.5, 2.5, 3.5])
  float32_array.length(arr) |> should.equal(3)
  float32_array.byte_length(arr) |> should.equal(12)
  // Float32 stores 1.5 exactly (half-integer in binary).
  float32_array.at(arr, index: 0) |> should.equal(Ok(1.5))
}

pub fn float64_round_trip_test() {
  let arr = float64_array.from_list([1.1, 2.2, 3.3])
  float64_array.length(arr) |> should.equal(3)
  float64_array.byte_length(arr) |> should.equal(24)
  // Float64 = Gleam Float — exact preservation.
  float64_array.at(arr, index: 0) |> should.equal(Ok(1.1))
}

pub fn float16_round_trip_test() {
  // 0.5 is representable exactly in any precision.
  let arr = float16_array.from_list([0.5, 0.25])
  float16_array.length(arr) |> should.equal(2)
  float16_array.byte_length(arr) |> should.equal(4)
  float16_array.at(arr, index: 0) |> should.equal(Ok(0.5))
}

pub fn bigint64_round_trip_test() {
  let arr =
    bigint64_array.from_list([
      big_int.from_int(-1),
      big_int.from_int(0),
      big_int.from_int(42),
    ])
  bigint64_array.length(arr) |> should.equal(3)
  bigint64_array.byte_length(arr) |> should.equal(24)
  let assert Ok(value) = bigint64_array.at(arr, index: 2)
  big_int.to_int(value) |> should.equal(Ok(42))
}

pub fn biguint64_round_trip_test() {
  let arr =
    biguint64_array.from_list([big_int.from_int(0), big_int.from_int(99)])
  biguint64_array.length(arr) |> should.equal(2)
  biguint64_array.byte_length(arr) |> should.equal(16)
  let assert Ok(value) = biguint64_array.at(arr, index: 1)
  big_int.to_int(value) |> should.equal(Ok(99))
}

pub fn bigint64_from_buffer_misaligned_errors_test() {
  // BigInt64Array requires 8-byte alignment; a 7-byte buffer can't host one.
  let assert Ok(buf) = array_buffer.new(7)
  let assert Error(_) = bigint64_array.from_buffer(buf)
}

pub fn bigint64_from_buffer_aligned_test() {
  let assert Ok(buf) = array_buffer.new(16)
  let assert Ok(arr) = bigint64_array.from_buffer(buf)
  bigint64_array.length(arr) |> should.equal(2)
}

pub fn biguint64_from_buffer_misaligned_errors_test() {
  let assert Ok(buf) = array_buffer.new(7)
  let assert Error(_) = biguint64_array.from_buffer(buf)
}

pub fn slice_test() {
  let arr = int32_array.from_list([10, 20, 30, 40, 50])
  let sliced = int32_array.slice_range(arr, from: 1, to: 4)
  int32_array.length(sliced) |> should.equal(3)
  int32_array.at(sliced, index: 0) |> should.equal(Ok(20))
}

pub fn fill_test() {
  let arr = int32_array.from_list([1, 2, 3, 4])
  let filled = int32_array.fill(arr, with: 99)
  int32_array.at(filled, index: 0) |> should.equal(Ok(99))
  int32_array.at(filled, index: 3) |> should.equal(Ok(99))
}

pub fn to_list_test() {
  let arr = int32_array.from_list([5, 10, 15])
  int32_array.to_list(arr) |> should.equal([5, 10, 15])
}

pub fn from_length_negative_errors_test() {
  let assert Error(_) = int32_array.from_length(-1)
}

pub fn with_out_of_range_errors_test() {
  let arr = int32_array.from_list([1, 2, 3])
  let assert Error(_) = int32_array.with(arr, at_index: 100, value: 99)
}

pub fn set_with_offset_overflow_errors_test() {
  let target = int32_array.from_list([0, 0, 0])
  let values = int32_array.from_list([1, 2, 3, 4])
  let assert Error(_) = int32_array.set(in: target, values: values)
}

pub fn from_buffer_misaligned_errors_test() {
  // Int32Array requires 4-byte alignment; a 7-byte buffer can't host one.
  let assert Ok(buf) = array_buffer.new(7)
  let assert Error(_) = int32_array.from_buffer(buf)
}

pub fn from_buffer_aligned_test() {
  // 8 bytes is divisible by 4; works.
  let assert Ok(buf) = array_buffer.new(8)
  let assert Ok(arr) = int32_array.from_buffer(buf)
  int32_array.length(arr) |> should.equal(2)
}

pub fn from_buffer_int8_any_size_test() {
  // 1-byte alignment; from_buffer doesn't return Result for Int8Array.
  let assert Ok(buf) = array_buffer.new(7)
  let arr = int8_array.from_buffer(buf)
  int8_array.length(arr) |> should.equal(7)
}
