import gleeunit/should
import gossamer/array_buffer
import gossamer/big_int
import gossamer/bigint64_array
import gossamer/float32_array
import gossamer/int32_array
import gossamer/typed_array
import gossamer/uint8_array

// Wrapping in a function prevents Gleam's flow analysis from
// narrowing the type to the specific variant.
fn opaque_int32() -> typed_array.TypedArray {
  typed_array.Int32(int32_array.from_list([1, 2, 3, 4]))
}

fn opaque_uint8() -> typed_array.TypedArray {
  typed_array.Uint8(uint8_array.from_list([10, 20, 30]))
}

fn opaque_float32() -> typed_array.TypedArray {
  typed_array.Float32(float32_array.from_list([1.5, 2.5]))
}

fn opaque_bigint64() -> typed_array.TypedArray {
  typed_array.BigInt64(
    bigint64_array.from_list([big_int.from_int(7), big_int.from_int(8)]),
  )
}

pub fn length_int32_test() {
  typed_array.length(opaque_int32()) |> should.equal(4)
}

pub fn length_uint8_test() {
  typed_array.length(opaque_uint8()) |> should.equal(3)
}

pub fn length_float32_test() {
  typed_array.length(opaque_float32()) |> should.equal(2)
}

pub fn length_bigint64_test() {
  typed_array.length(opaque_bigint64()) |> should.equal(2)
}

pub fn byte_length_int32_test() {
  typed_array.byte_length(opaque_int32()) |> should.equal(16)
}

pub fn byte_length_uint8_test() {
  typed_array.byte_length(opaque_uint8()) |> should.equal(3)
}

pub fn byte_length_float32_test() {
  typed_array.byte_length(opaque_float32()) |> should.equal(8)
}

pub fn byte_length_bigint64_test() {
  typed_array.byte_length(opaque_bigint64()) |> should.equal(16)
}

pub fn byte_offset_int32_test() {
  typed_array.byte_offset(opaque_int32()) |> should.equal(0)
}

pub fn buffer_int32_test() {
  let buf = typed_array.buffer(opaque_int32())
  array_buffer.byte_length(buf) |> should.equal(16)
}

// Pattern match dispatch — all 12 variants need to be covered to
// satisfy exhaustiveness, but we only care about the few we test.
pub fn dispatch_int32_test() {
  let result = case opaque_int32() {
    typed_array.Int32(arr) -> int32_array.at(arr, index: 0)
    typed_array.Uint8(arr) -> uint8_array.at(arr, index: 0)
    _ -> Error(Nil)
  }
  result |> should.equal(Ok(1))
}

pub fn dispatch_uint8_test() {
  let result = case opaque_uint8() {
    typed_array.Int32(arr) -> int32_array.at(arr, index: 0)
    typed_array.Uint8(arr) -> uint8_array.at(arr, index: 0)
    _ -> Error(Nil)
  }
  result |> should.equal(Ok(10))
}
