import gossamer/array_buffer.{type ArrayBuffer}
import gossamer/js_error.{type JsError}

/// A typed array of 16-bit signed integers.
///
/// See [Int16Array](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Int16Array) on MDN.
///
@external(javascript, "./int16_array.type.ts", "Int16Array$")
pub type Int16Array

@external(javascript, "./int16_array.ffi.mjs", "new_")
pub fn new() -> Int16Array

/// Creates a zero-filled `Int16Array` of the given length. Returns
/// an error if `length` is negative or exceeds the maximum
/// allocatable size.
///
@external(javascript, "./int16_array.ffi.mjs", "from_length")
pub fn from_length(length: Int) -> Result(Int16Array, JsError)

/// Creates an `Int16Array` from a list of 16-bit signed integers.
/// Values outside `-32_768`–`32_767` are wrapped modulo `65_536`,
/// matching the JS `Int16Array` constructor.
///
@external(javascript, "./int16_array.ffi.mjs", "from_list")
pub fn from_list(list: List(Int)) -> Int16Array

/// Creates an `Int16Array` view over `buffer`. Returns an error if
/// `buffer.byteLength` is not a multiple of `2` (the element
/// size).
///
@external(javascript, "./int16_array.ffi.mjs", "from_buffer")
pub fn from_buffer(buffer: ArrayBuffer) -> Result(Int16Array, JsError)

/// Creates an `Int16Array` view over a slice of `buffer` starting at
/// `byte_offset` and spanning `length` elements. Returns an error if
/// the range is out of bounds, `buffer` is detached, or `byte_offset`
/// is not a multiple of `2`.
///
@external(javascript, "./int16_array.ffi.mjs", "from_buffer_range")
pub fn from_buffer_range(
  buffer: ArrayBuffer,
  byte_offset byte_offset: Int,
  length length: Int,
) -> Result(Int16Array, JsError)

@external(javascript, "./int16_array.ffi.mjs", "buffer")
pub fn buffer(of array: Int16Array) -> ArrayBuffer

@external(javascript, "./int16_array.ffi.mjs", "byte_length")
pub fn byte_length(of array: Int16Array) -> Int

@external(javascript, "./int16_array.ffi.mjs", "byte_offset")
pub fn byte_offset(of array: Int16Array) -> Int

@external(javascript, "./int16_array.ffi.mjs", "length")
pub fn length(of array: Int16Array) -> Int

/// Returns the element at `index`, or `Error(Nil)` if the index is
/// out of range. Negative indices count from the end.
///
@external(javascript, "./int16_array.ffi.mjs", "at")
pub fn at(array: Int16Array, index index: Int) -> Result(Int, Nil)

/// Returns a copy of `array` with the value at `index` replaced.
/// Negative indices count from the end. Returns an error if `index`
/// is out of range.
///
@external(javascript, "./int16_array.ffi.mjs", "with_")
pub fn with(
  array: Int16Array,
  at_index index: Int,
  value value: Int,
) -> Result(Int16Array, JsError)

@external(javascript, "./int16_array.ffi.mjs", "includes")
pub fn includes(in array: Int16Array, value value: Int) -> Bool

/// Returns the first index of `value`, or `Error(Nil)` if not present.
///
@external(javascript, "./int16_array.ffi.mjs", "index_of")
pub fn index_of(in array: Int16Array, value value: Int) -> Result(Int, Nil)

/// Returns the last index of `value`, or `Error(Nil)` if not present.
///
@external(javascript, "./int16_array.ffi.mjs", "last_index_of")
pub fn last_index_of(in array: Int16Array, value value: Int) -> Result(Int, Nil)

@external(javascript, "./int16_array.ffi.mjs", "slice")
pub fn slice(array: Int16Array) -> Int16Array

@external(javascript, "./int16_array.ffi.mjs", "slice_range")
pub fn slice_range(
  array: Int16Array,
  from start: Int,
  to end: Int,
) -> Int16Array

@external(javascript, "./int16_array.ffi.mjs", "subarray")
pub fn subarray(array: Int16Array, from begin: Int, to end: Int) -> Int16Array

/// Copies `values` into `array` starting at index `0`. Returns an
/// error if `values` would extend past the end of `array`.
///
@external(javascript, "./int16_array.ffi.mjs", "set")
pub fn set(
  in array: Int16Array,
  values values: Int16Array,
) -> Result(Nil, JsError)

/// Copies `values` into `array` starting at `offset`. Returns an
/// error if `offset` is negative or the copy would extend past the
/// end of `array`.
///
@external(javascript, "./int16_array.ffi.mjs", "set_with_offset")
pub fn set_with_offset(
  in array: Int16Array,
  values values: Int16Array,
  offset offset: Int,
) -> Result(Nil, JsError)

@external(javascript, "./int16_array.ffi.mjs", "fill")
pub fn fill(array: Int16Array, with value: Int) -> Int16Array

@external(javascript, "./int16_array.ffi.mjs", "reverse")
pub fn reverse(array: Int16Array) -> Int16Array

@external(javascript, "./int16_array.ffi.mjs", "to_list")
pub fn to_list(array: Int16Array) -> List(Int)
