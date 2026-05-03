import gossamer/array_buffer.{type ArrayBuffer}
import gossamer/big_int.{type BigInt}
import gossamer/js_error.{type JsError}

/// A typed array of 64-bit unsigned integers, holding `BigInt` values.
///
/// See [BigUint64Array](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/BigUint64Array) on MDN.
///
@external(javascript, "./biguint64_array.type.ts", "BigUint64Array$")
pub type BigUint64Array

@external(javascript, "./biguint64_array.ffi.mjs", "new_")
pub fn new() -> BigUint64Array

/// Creates a zero-filled `BigUint64Array` of the given length. Returns
/// an error if `length` is negative or exceeds the maximum allocatable
/// size.
///
@external(javascript, "./biguint64_array.ffi.mjs", "from_length")
pub fn from_length(length: Int) -> Result(BigUint64Array, JsError)

/// Creates a `BigUint64Array` from a list of `BigInt` values. Values
/// outside `0` to 2^64 − 1 are wrapped modulo 2^64, matching the JS
/// `BigUint64Array` constructor.
///
@external(javascript, "./biguint64_array.ffi.mjs", "from_list")
pub fn from_list(list: List(BigInt)) -> BigUint64Array

/// Creates a `BigUint64Array` view over `buffer`. Returns an error if
/// `buffer.byteLength` is not a multiple of `8` (the element size).
///
@external(javascript, "./biguint64_array.ffi.mjs", "from_buffer")
pub fn from_buffer(buffer: ArrayBuffer) -> Result(BigUint64Array, JsError)

@external(javascript, "./biguint64_array.ffi.mjs", "buffer")
pub fn buffer(of array: BigUint64Array) -> ArrayBuffer

@external(javascript, "./biguint64_array.ffi.mjs", "byte_length")
pub fn byte_length(of array: BigUint64Array) -> Int

@external(javascript, "./biguint64_array.ffi.mjs", "byte_offset")
pub fn byte_offset(of array: BigUint64Array) -> Int

@external(javascript, "./biguint64_array.ffi.mjs", "length")
pub fn length(of array: BigUint64Array) -> Int

/// Returns the element at `index`, or `Error(Nil)` if the index is
/// out of range. Negative indices count from the end.
///
@external(javascript, "./biguint64_array.ffi.mjs", "at")
pub fn at(array: BigUint64Array, index index: Int) -> Result(BigInt, Nil)

/// Returns a copy of `array` with the value at `index` replaced.
/// Negative indices count from the end. Returns an error if `index`
/// is out of range.
///
@external(javascript, "./biguint64_array.ffi.mjs", "with_")
pub fn with(
  array: BigUint64Array,
  at_index index: Int,
  value value: BigInt,
) -> Result(BigUint64Array, JsError)

@external(javascript, "./biguint64_array.ffi.mjs", "includes")
pub fn includes(in array: BigUint64Array, value value: BigInt) -> Bool

/// Returns the first index of `value`, or `Error(Nil)` if not present.
///
@external(javascript, "./biguint64_array.ffi.mjs", "index_of")
pub fn index_of(
  in array: BigUint64Array,
  value value: BigInt,
) -> Result(Int, Nil)

/// Returns the last index of `value`, or `Error(Nil)` if not present.
///
@external(javascript, "./biguint64_array.ffi.mjs", "last_index_of")
pub fn last_index_of(
  in array: BigUint64Array,
  value value: BigInt,
) -> Result(Int, Nil)

@external(javascript, "./biguint64_array.ffi.mjs", "slice")
pub fn slice(array: BigUint64Array) -> BigUint64Array

@external(javascript, "./biguint64_array.ffi.mjs", "slice_range")
pub fn slice_range(
  array: BigUint64Array,
  from start: Int,
  to end: Int,
) -> BigUint64Array

@external(javascript, "./biguint64_array.ffi.mjs", "subarray")
pub fn subarray(
  array: BigUint64Array,
  from begin: Int,
  to end: Int,
) -> BigUint64Array

/// Copies `values` into `array` starting at index `0`. Returns an
/// error if `values` would extend past the end of `array`.
///
@external(javascript, "./biguint64_array.ffi.mjs", "set")
pub fn set(
  in array: BigUint64Array,
  values values: BigUint64Array,
) -> Result(Nil, JsError)

/// Copies `values` into `array` starting at `offset`. Returns an
/// error if `offset` is negative or the copy would extend past the
/// end of `array`.
///
@external(javascript, "./biguint64_array.ffi.mjs", "set_with_offset")
pub fn set_with_offset(
  in array: BigUint64Array,
  values values: BigUint64Array,
  offset offset: Int,
) -> Result(Nil, JsError)

@external(javascript, "./biguint64_array.ffi.mjs", "fill")
pub fn fill(array: BigUint64Array, with value: BigInt) -> BigUint64Array

@external(javascript, "./biguint64_array.ffi.mjs", "reverse")
pub fn reverse(array: BigUint64Array) -> BigUint64Array

@external(javascript, "./biguint64_array.ffi.mjs", "to_list")
pub fn to_list(array: BigUint64Array) -> List(BigInt)
