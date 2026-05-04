import gossamer/array_buffer.{type ArrayBuffer}
import gossamer/js_error.{type JsError}

/// A typed array of 16-bit IEEE 754 half-precision floats. Stores
/// only ~3-4 decimal digits of precision and a narrower exponent
/// range than Gleam `Float`; storing then reading is generally lossy.
///
/// See [Float16Array](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Float16Array) on MDN.
///
@external(javascript, "./float16_array.type.ts", "Float16Array$")
pub type Float16Array

@external(javascript, "./float16_array.ffi.mjs", "new_")
pub fn new() -> Float16Array

/// Creates a zero-filled `Float16Array` of the given length. Returns
/// an error if `length` is negative or exceeds the maximum
/// allocatable size.
///
@external(javascript, "./float16_array.ffi.mjs", "from_length")
pub fn from_length(length: Int) -> Result(Float16Array, JsError)

@external(javascript, "./float16_array.ffi.mjs", "from_list")
pub fn from_list(list: List(Float)) -> Float16Array

/// Creates a `Float16Array` view over `buffer`. Returns an error if
/// `buffer.byteLength` is not a multiple of `2` (the element
/// size).
///
@external(javascript, "./float16_array.ffi.mjs", "from_buffer")
pub fn from_buffer(buffer: ArrayBuffer) -> Result(Float16Array, JsError)

/// Creates a `Float16Array` view over a slice of `buffer` starting at
/// `byte_offset` and spanning `length` elements. Returns an error if
/// the range is out of bounds, `buffer` is detached, or `byte_offset`
/// is not a multiple of `2`.
///
@external(javascript, "./float16_array.ffi.mjs", "from_buffer_range")
pub fn from_buffer_range(
  buffer: ArrayBuffer,
  byte_offset byte_offset: Int,
  length length: Int,
) -> Result(Float16Array, JsError)

@external(javascript, "./float16_array.ffi.mjs", "buffer")
pub fn buffer(of array: Float16Array) -> ArrayBuffer

@external(javascript, "./float16_array.ffi.mjs", "byte_length")
pub fn byte_length(of array: Float16Array) -> Int

@external(javascript, "./float16_array.ffi.mjs", "byte_offset")
pub fn byte_offset(of array: Float16Array) -> Int

@external(javascript, "./float16_array.ffi.mjs", "length")
pub fn length(of array: Float16Array) -> Int

/// Returns the element at `index`, or `Error(Nil)` if the index is
/// out of range. Negative indices count from the end.
///
@external(javascript, "./float16_array.ffi.mjs", "at")
pub fn at(array: Float16Array, index index: Int) -> Result(Float, Nil)

/// Returns a copy of `array` with the value at `index` replaced.
/// Negative indices count from the end. Returns an error if `index`
/// is out of range.
///
@external(javascript, "./float16_array.ffi.mjs", "with_")
pub fn with(
  array: Float16Array,
  at_index index: Int,
  value value: Float,
) -> Result(Float16Array, JsError)

@external(javascript, "./float16_array.ffi.mjs", "includes")
pub fn includes(in array: Float16Array, value value: Float) -> Bool

/// Returns the first index of `value`, or `Error(Nil)` if not present.
///
@external(javascript, "./float16_array.ffi.mjs", "index_of")
pub fn index_of(in array: Float16Array, value value: Float) -> Result(Int, Nil)

/// Returns the last index of `value`, or `Error(Nil)` if not present.
///
@external(javascript, "./float16_array.ffi.mjs", "last_index_of")
pub fn last_index_of(
  in array: Float16Array,
  value value: Float,
) -> Result(Int, Nil)

@external(javascript, "./float16_array.ffi.mjs", "slice")
pub fn slice(array: Float16Array) -> Float16Array

@external(javascript, "./float16_array.ffi.mjs", "slice_range")
pub fn slice_range(
  array: Float16Array,
  from start: Int,
  to end: Int,
) -> Float16Array

@external(javascript, "./float16_array.ffi.mjs", "subarray")
pub fn subarray(
  array: Float16Array,
  from begin: Int,
  to end: Int,
) -> Float16Array

/// Copies `values` into `array` starting at index `0`. Returns an
/// error if `values` would extend past the end of `array`.
///
@external(javascript, "./float16_array.ffi.mjs", "set")
pub fn set(
  in array: Float16Array,
  values values: Float16Array,
) -> Result(Nil, JsError)

/// Copies `values` into `array` starting at `offset`. Returns an
/// error if `offset` is negative or the copy would extend past the
/// end of `array`.
///
@external(javascript, "./float16_array.ffi.mjs", "set_with_offset")
pub fn set_with_offset(
  in array: Float16Array,
  values values: Float16Array,
  offset offset: Int,
) -> Result(Nil, JsError)

@external(javascript, "./float16_array.ffi.mjs", "fill")
pub fn fill(array: Float16Array, with value: Float) -> Float16Array

@external(javascript, "./float16_array.ffi.mjs", "reverse")
pub fn reverse(array: Float16Array) -> Float16Array

@external(javascript, "./float16_array.ffi.mjs", "to_list")
pub fn to_list(array: Float16Array) -> List(Float)
