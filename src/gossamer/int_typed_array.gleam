import gossamer/bigint64_array.{type BigInt64Array}
import gossamer/biguint64_array.{type BigUint64Array}
import gossamer/int16_array.{type Int16Array}
import gossamer/int32_array.{type Int32Array}
import gossamer/int8_array.{type Int8Array}
import gossamer/typed_array.{type TypedArray}
import gossamer/uint16_array.{type Uint16Array}
import gossamer/uint32_array.{type Uint32Array}
import gossamer/uint8_array.{type Uint8Array}
import gossamer/uint8_clamped_array.{type Uint8ClampedArray}

/// An integer JS typed array. Used by APIs that the spec restricts to
/// integer typed arrays only — chiefly `crypto.get_random_values`,
/// which throws `TypeMismatchError` when passed any float-typed array.
///
pub type IntTypedArray {
  Int8(Int8Array)
  Uint8(Uint8Array)
  Uint8Clamped(Uint8ClampedArray)
  Int16(Int16Array)
  Uint16(Uint16Array)
  Int32(Int32Array)
  Uint32(Uint32Array)
  BigInt64(BigInt64Array)
  BigUint64(BigUint64Array)
}

/// Widens an `IntTypedArray` to the broader `TypedArray` union.
///
pub fn to_typed_array(int_typed: IntTypedArray) -> TypedArray {
  case int_typed {
    Int8(arr) -> typed_array.Int8(arr)
    Uint8(arr) -> typed_array.Uint8(arr)
    Uint8Clamped(arr) -> typed_array.Uint8Clamped(arr)
    Int16(arr) -> typed_array.Int16(arr)
    Uint16(arr) -> typed_array.Uint16(arr)
    Int32(arr) -> typed_array.Int32(arr)
    Uint32(arr) -> typed_array.Uint32(arr)
    BigInt64(arr) -> typed_array.BigInt64(arr)
    BigUint64(arr) -> typed_array.BigUint64(arr)
  }
}
