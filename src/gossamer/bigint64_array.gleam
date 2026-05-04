import gossamer/array_buffer.{type ArrayBuffer}
import gossamer/big_int.{type BigInt}
import gossamer/js_error.{type JsError}

/// A typed array of 64-bit signed integers, holding `BigInt` values.
///
/// See [BigInt64Array](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/BigInt64Array) on MDN.
///
@external(javascript, "./bigint64_array.type.ts", "BigInt64Array$")
pub type BigInt64Array

@external(javascript, "./bigint64_array.ffi.mjs", "new_")
pub fn new() -> BigInt64Array

/// Creates a zero-filled `BigInt64Array` of the given length. Returns
/// an error if `length` is negative or exceeds the maximum allocatable
/// size.
///
@external(javascript, "./bigint64_array.ffi.mjs", "from_length")
pub fn from_length(length: Int) -> Result(BigInt64Array, JsError)

/// Creates a `BigInt64Array` from a list of `BigInt` values. Values
/// outside −2^63 to 2^63 − 1 are wrapped modulo 2^64, matching the JS
/// `BigInt64Array` constructor.
///
@external(javascript, "./bigint64_array.ffi.mjs", "from_list")
pub fn from_list(list: List(BigInt)) -> BigInt64Array

/// Creates a `BigInt64Array` view over `buffer`. Returns an error if
/// `buffer.byteLength` is not a multiple of `8` (the element size).
///
@external(javascript, "./bigint64_array.ffi.mjs", "from_buffer")
pub fn from_buffer(buffer: ArrayBuffer) -> Result(BigInt64Array, JsError)

/// Creates a `BigInt64Array` view over a slice of `buffer` starting at
/// `byte_offset` and spanning `length` elements. Returns an error if
/// the range is out of bounds, `buffer` is detached, or `byte_offset`
/// is not a multiple of `8`.
///
@external(javascript, "./bigint64_array.ffi.mjs", "from_buffer_range")
pub fn from_buffer_range(
  buffer: ArrayBuffer,
  byte_offset byte_offset: Int,
  length length: Int,
) -> Result(BigInt64Array, JsError)

@external(javascript, "./bigint64_array.ffi.mjs", "buffer")
pub fn buffer(of array: BigInt64Array) -> ArrayBuffer

@external(javascript, "./bigint64_array.ffi.mjs", "byte_length")
pub fn byte_length(of array: BigInt64Array) -> Int

@external(javascript, "./bigint64_array.ffi.mjs", "byte_offset")
pub fn byte_offset(of array: BigInt64Array) -> Int

@external(javascript, "./bigint64_array.ffi.mjs", "length")
pub fn length(of array: BigInt64Array) -> Int

/// Returns the element at `index`, or `Error(Nil)` if the index is
/// out of range. Negative indices count from the end.
///
@external(javascript, "./bigint64_array.ffi.mjs", "at")
pub fn at(array: BigInt64Array, index index: Int) -> Result(BigInt, Nil)

/// Returns a copy of `array` with the value at `index` replaced.
/// Negative indices count from the end. Returns an error if `index`
/// is out of range.
///
@external(javascript, "./bigint64_array.ffi.mjs", "with_")
pub fn with(
  array: BigInt64Array,
  at_index index: Int,
  value value: BigInt,
) -> Result(BigInt64Array, JsError)

@external(javascript, "./bigint64_array.ffi.mjs", "includes")
pub fn includes(in array: BigInt64Array, value value: BigInt) -> Bool

/// Returns the first index of `value`, or `Error(Nil)` if not present.
///
@external(javascript, "./bigint64_array.ffi.mjs", "index_of")
pub fn index_of(
  in array: BigInt64Array,
  value value: BigInt,
) -> Result(Int, Nil)

/// Returns the last index of `value`, or `Error(Nil)` if not present.
///
@external(javascript, "./bigint64_array.ffi.mjs", "last_index_of")
pub fn last_index_of(
  in array: BigInt64Array,
  value value: BigInt,
) -> Result(Int, Nil)

@external(javascript, "./bigint64_array.ffi.mjs", "slice")
pub fn slice(array: BigInt64Array) -> BigInt64Array

@external(javascript, "./bigint64_array.ffi.mjs", "slice_range")
pub fn slice_range(
  array: BigInt64Array,
  from start: Int,
  to end: Int,
) -> BigInt64Array

@external(javascript, "./bigint64_array.ffi.mjs", "subarray")
pub fn subarray(
  array: BigInt64Array,
  from begin: Int,
  to end: Int,
) -> BigInt64Array

/// Copies `values` into `array` starting at index `0`. Returns an
/// error if `values` would extend past the end of `array`.
///
@external(javascript, "./bigint64_array.ffi.mjs", "set")
pub fn set(
  in array: BigInt64Array,
  values values: BigInt64Array,
) -> Result(Nil, JsError)

/// Copies `values` into `array` starting at `offset`. Returns an
/// error if `offset` is negative or the copy would extend past the
/// end of `array`.
///
@external(javascript, "./bigint64_array.ffi.mjs", "set_with_offset")
pub fn set_with_offset(
  in array: BigInt64Array,
  values values: BigInt64Array,
  offset offset: Int,
) -> Result(Nil, JsError)

@external(javascript, "./bigint64_array.ffi.mjs", "fill")
pub fn fill(array: BigInt64Array, with value: BigInt) -> BigInt64Array

@external(javascript, "./bigint64_array.ffi.mjs", "reverse")
pub fn reverse(array: BigInt64Array) -> BigInt64Array

@external(javascript, "./bigint64_array.ffi.mjs", "to_list")
pub fn to_list(array: BigInt64Array) -> List(BigInt)
