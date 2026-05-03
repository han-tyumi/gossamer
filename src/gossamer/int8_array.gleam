import gossamer/array_buffer.{type ArrayBuffer}
import gossamer/js_error.{type JsError}

/// A typed array of 8-bit signed integers.
///
/// See [Int8Array](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Int8Array) on MDN.
///
@external(javascript, "./int8_array.type.ts", "Int8Array$")
pub type Int8Array

@external(javascript, "./int8_array.ffi.mjs", "new_")
pub fn new() -> Int8Array

/// Creates a zero-filled `Int8Array` of the given length. Returns an
/// error if `length` is negative or exceeds the maximum allocatable
/// size.
///
@external(javascript, "./int8_array.ffi.mjs", "from_length")
pub fn from_length(length: Int) -> Result(Int8Array, JsError)

/// Creates an `Int8Array` from a list of 8-bit signed integers.
/// Values outside `-128`–`127` are wrapped modulo `256`, matching the
/// JS `Int8Array` constructor.
///
@external(javascript, "./int8_array.ffi.mjs", "from_list")
pub fn from_list(list: List(Int)) -> Int8Array

@external(javascript, "./int8_array.ffi.mjs", "from_buffer")
pub fn from_buffer(buffer: ArrayBuffer) -> Int8Array

@external(javascript, "./int8_array.ffi.mjs", "buffer")
pub fn buffer(of array: Int8Array) -> ArrayBuffer

@external(javascript, "./int8_array.ffi.mjs", "byte_length")
pub fn byte_length(of array: Int8Array) -> Int

@external(javascript, "./int8_array.ffi.mjs", "byte_offset")
pub fn byte_offset(of array: Int8Array) -> Int

@external(javascript, "./int8_array.ffi.mjs", "length")
pub fn length(of array: Int8Array) -> Int

/// Returns the element at `index`, or `Error(Nil)` if the index is
/// out of range. Negative indices count from the end.
///
@external(javascript, "./int8_array.ffi.mjs", "at")
pub fn at(array: Int8Array, index index: Int) -> Result(Int, Nil)

/// Returns a copy of `array` with the value at `index` replaced.
/// Negative indices count from the end. Returns an error if `index`
/// is out of range.
///
@external(javascript, "./int8_array.ffi.mjs", "with_")
pub fn with(
  array: Int8Array,
  at_index index: Int,
  value value: Int,
) -> Result(Int8Array, JsError)

@external(javascript, "./int8_array.ffi.mjs", "includes")
pub fn includes(in array: Int8Array, value value: Int) -> Bool

/// Returns the first index of `value`, or `Error(Nil)` if not present.
///
@external(javascript, "./int8_array.ffi.mjs", "index_of")
pub fn index_of(in array: Int8Array, value value: Int) -> Result(Int, Nil)

/// Returns the last index of `value`, or `Error(Nil)` if not present.
///
@external(javascript, "./int8_array.ffi.mjs", "last_index_of")
pub fn last_index_of(in array: Int8Array, value value: Int) -> Result(Int, Nil)

@external(javascript, "./int8_array.ffi.mjs", "slice")
pub fn slice(array: Int8Array) -> Int8Array

@external(javascript, "./int8_array.ffi.mjs", "slice_range")
pub fn slice_range(array: Int8Array, from start: Int, to end: Int) -> Int8Array

@external(javascript, "./int8_array.ffi.mjs", "subarray")
pub fn subarray(array: Int8Array, from begin: Int, to end: Int) -> Int8Array

/// Copies `values` into `array` starting at index `0`. Returns an
/// error if `values` would extend past the end of `array`.
///
@external(javascript, "./int8_array.ffi.mjs", "set")
pub fn set(
  in array: Int8Array,
  values values: Int8Array,
) -> Result(Nil, JsError)

/// Copies `values` into `array` starting at `offset`. Returns an
/// error if `offset` is negative or the copy would extend past the
/// end of `array`.
///
@external(javascript, "./int8_array.ffi.mjs", "set_with_offset")
pub fn set_with_offset(
  in array: Int8Array,
  values values: Int8Array,
  offset offset: Int,
) -> Result(Nil, JsError)

@external(javascript, "./int8_array.ffi.mjs", "fill")
pub fn fill(array: Int8Array, with value: Int) -> Int8Array

@external(javascript, "./int8_array.ffi.mjs", "reverse")
pub fn reverse(array: Int8Array) -> Int8Array

@external(javascript, "./int8_array.ffi.mjs", "to_list")
pub fn to_list(array: Int8Array) -> List(Int)
