import gossamer/array_buffer.{type ArrayBuffer}
import gossamer/js_error.{type JsError}

/// A typed array of 64-bit IEEE 754 floats. Maps directly to Gleam
/// `Float`; no precision loss on read or write.
///
/// See [Float64Array](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Float64Array) on MDN.
///
@external(javascript, "./float64_array.type.ts", "Float64Array$")
pub type Float64Array

@external(javascript, "./float64_array.ffi.mjs", "new_")
pub fn new() -> Float64Array

/// Creates a zero-filled `Float64Array` of the given length. Returns
/// an error if `length` is negative or exceeds the maximum
/// allocatable size.
///
@external(javascript, "./float64_array.ffi.mjs", "from_length")
pub fn from_length(length: Int) -> Result(Float64Array, JsError)

@external(javascript, "./float64_array.ffi.mjs", "from_list")
pub fn from_list(list: List(Float)) -> Float64Array

/// Creates a `Float64Array` view over `buffer`. Returns an error if
/// `buffer.byteLength` is not a multiple of `8` (the element
/// size).
///
@external(javascript, "./float64_array.ffi.mjs", "from_buffer")
pub fn from_buffer(buffer: ArrayBuffer) -> Result(Float64Array, JsError)

@external(javascript, "./float64_array.ffi.mjs", "buffer")
pub fn buffer(of array: Float64Array) -> ArrayBuffer

@external(javascript, "./float64_array.ffi.mjs", "byte_length")
pub fn byte_length(of array: Float64Array) -> Int

@external(javascript, "./float64_array.ffi.mjs", "byte_offset")
pub fn byte_offset(of array: Float64Array) -> Int

@external(javascript, "./float64_array.ffi.mjs", "length")
pub fn length(of array: Float64Array) -> Int

/// Returns the element at `index`, or `Error(Nil)` if the index is
/// out of range. Negative indices count from the end.
///
@external(javascript, "./float64_array.ffi.mjs", "at")
pub fn at(array: Float64Array, index index: Int) -> Result(Float, Nil)

/// Returns a copy of `array` with the value at `index` replaced.
/// Negative indices count from the end. Returns an error if `index`
/// is out of range.
///
@external(javascript, "./float64_array.ffi.mjs", "with_")
pub fn with(
  array: Float64Array,
  at_index index: Int,
  value value: Float,
) -> Result(Float64Array, JsError)

@external(javascript, "./float64_array.ffi.mjs", "includes")
pub fn includes(in array: Float64Array, value value: Float) -> Bool

/// Returns the first index of `value`, or `Error(Nil)` if not present.
///
@external(javascript, "./float64_array.ffi.mjs", "index_of")
pub fn index_of(in array: Float64Array, value value: Float) -> Result(Int, Nil)

/// Returns the last index of `value`, or `Error(Nil)` if not present.
///
@external(javascript, "./float64_array.ffi.mjs", "last_index_of")
pub fn last_index_of(
  in array: Float64Array,
  value value: Float,
) -> Result(Int, Nil)

@external(javascript, "./float64_array.ffi.mjs", "slice")
pub fn slice(array: Float64Array) -> Float64Array

@external(javascript, "./float64_array.ffi.mjs", "slice_range")
pub fn slice_range(
  array: Float64Array,
  from start: Int,
  to end: Int,
) -> Float64Array

@external(javascript, "./float64_array.ffi.mjs", "subarray")
pub fn subarray(
  array: Float64Array,
  from begin: Int,
  to end: Int,
) -> Float64Array

/// Copies `values` into `array` starting at index `0`. Returns an
/// error if `values` would extend past the end of `array`.
///
@external(javascript, "./float64_array.ffi.mjs", "set")
pub fn set(
  in array: Float64Array,
  values values: Float64Array,
) -> Result(Nil, JsError)

/// Copies `values` into `array` starting at `offset`. Returns an
/// error if `offset` is negative or the copy would extend past the
/// end of `array`.
///
@external(javascript, "./float64_array.ffi.mjs", "set_with_offset")
pub fn set_with_offset(
  in array: Float64Array,
  values values: Float64Array,
  offset offset: Int,
) -> Result(Nil, JsError)

@external(javascript, "./float64_array.ffi.mjs", "fill")
pub fn fill(array: Float64Array, with value: Float) -> Float64Array

@external(javascript, "./float64_array.ffi.mjs", "reverse")
pub fn reverse(array: Float64Array) -> Float64Array

@external(javascript, "./float64_array.ffi.mjs", "to_list")
pub fn to_list(array: Float64Array) -> List(Float)
