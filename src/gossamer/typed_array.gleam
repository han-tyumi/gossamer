import gossamer/array_buffer.{type ArrayBuffer}
import gossamer/bigint64_array.{type BigInt64Array}
import gossamer/biguint64_array.{type BigUint64Array}
import gossamer/float16_array.{type Float16Array}
import gossamer/float32_array.{type Float32Array}
import gossamer/float64_array.{type Float64Array}
import gossamer/int16_array.{type Int16Array}
import gossamer/int32_array.{type Int32Array}
import gossamer/int8_array.{type Int8Array}
import gossamer/uint16_array.{type Uint16Array}
import gossamer/uint32_array.{type Uint32Array}
import gossamer/uint8_array.{type Uint8Array}
import gossamer/uint8_clamped_array.{type Uint8ClampedArray}

/// A JS typed array, as a tagged union over every per-type module.
/// Pattern match to recover the concrete type:
///
/// ```gleam
/// case received {
///   typed_array.Uint8(arr) -> uint8_array.at(arr, index: 0)
///   typed_array.Int32(arr) -> int32_array.at(arr, index: 0)
///   _ -> Error(Nil)
/// }
/// ```
///
pub type TypedArray {
  Int8(Int8Array)
  Uint8(Uint8Array)
  Uint8Clamped(Uint8ClampedArray)
  Int16(Int16Array)
  Uint16(Uint16Array)
  Int32(Int32Array)
  Uint32(Uint32Array)
  Float16(Float16Array)
  Float32(Float32Array)
  Float64(Float64Array)
  BigInt64(BigInt64Array)
  BigUint64(BigUint64Array)
}

@external(javascript, "./typed_array.ffi.mjs", "length")
pub fn length(of array: TypedArray) -> Int

@external(javascript, "./typed_array.ffi.mjs", "byte_length")
pub fn byte_length(of array: TypedArray) -> Int

@external(javascript, "./typed_array.ffi.mjs", "byte_offset")
pub fn byte_offset(of array: TypedArray) -> Int

@external(javascript, "./typed_array.ffi.mjs", "buffer")
pub fn buffer(of array: TypedArray) -> ArrayBuffer
