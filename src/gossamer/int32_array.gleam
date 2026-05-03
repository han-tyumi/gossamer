import gossamer/array_buffer.{type ArrayBuffer}
import gossamer/js_error.{type JsError}

/// A typed array of 32-bit signed integers.
///
/// See [Int32Array](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Int32Array) on MDN.
///
@external(javascript, "./int32_array.type.ts", "Int32Array$")
pub type Int32Array

@external(javascript, "./int32_array.ffi.mjs", "new_")
pub fn new() -> Int32Array

/// Creates a zero-filled `Int32Array` of the given length. Returns
/// an error if `length` is negative or exceeds the maximum
/// allocatable size.
///
@external(javascript, "./int32_array.ffi.mjs", "from_length")
pub fn from_length(length: Int) -> Result(Int32Array, JsError)

/// Creates an `Int32Array` from a list of 32-bit signed integers.
/// Values outside `-2_147_483_648`–`2_147_483_647` are wrapped modulo
/// `4_294_967_296`, matching the JS `Int32Array` constructor.
///
@external(javascript, "./int32_array.ffi.mjs", "from_list")
pub fn from_list(list: List(Int)) -> Int32Array

/// Creates an `Int32Array` view over `buffer`. Returns an error if
/// `buffer.byteLength` is not a multiple of `4` (the element
/// size).
///
@external(javascript, "./int32_array.ffi.mjs", "from_buffer")
pub fn from_buffer(buffer: ArrayBuffer) -> Result(Int32Array, JsError)

@external(javascript, "./int32_array.ffi.mjs", "buffer")
pub fn buffer(of array: Int32Array) -> ArrayBuffer

@external(javascript, "./int32_array.ffi.mjs", "byte_length")
pub fn byte_length(of array: Int32Array) -> Int

@external(javascript, "./int32_array.ffi.mjs", "byte_offset")
pub fn byte_offset(of array: Int32Array) -> Int

@external(javascript, "./int32_array.ffi.mjs", "length")
pub fn length(of array: Int32Array) -> Int

/// Returns the element at `index`, or `Error(Nil)` if the index is
/// out of range. Negative indices count from the end.
///
@external(javascript, "./int32_array.ffi.mjs", "at")
pub fn at(array: Int32Array, index index: Int) -> Result(Int, Nil)

/// Returns a copy of `array` with the value at `index` replaced.
/// Negative indices count from the end. Returns an error if `index`
/// is out of range.
///
@external(javascript, "./int32_array.ffi.mjs", "with_")
pub fn with(
  array: Int32Array,
  at_index index: Int,
  value value: Int,
) -> Result(Int32Array, JsError)

@external(javascript, "./int32_array.ffi.mjs", "includes")
pub fn includes(in array: Int32Array, value value: Int) -> Bool

/// Returns the first index of `value`, or `Error(Nil)` if not present.
///
@external(javascript, "./int32_array.ffi.mjs", "index_of")
pub fn index_of(in array: Int32Array, value value: Int) -> Result(Int, Nil)

/// Returns the last index of `value`, or `Error(Nil)` if not present.
///
@external(javascript, "./int32_array.ffi.mjs", "last_index_of")
pub fn last_index_of(in array: Int32Array, value value: Int) -> Result(Int, Nil)

@external(javascript, "./int32_array.ffi.mjs", "slice")
pub fn slice(array: Int32Array) -> Int32Array

@external(javascript, "./int32_array.ffi.mjs", "slice_range")
pub fn slice_range(
  array: Int32Array,
  from start: Int,
  to end: Int,
) -> Int32Array

@external(javascript, "./int32_array.ffi.mjs", "subarray")
pub fn subarray(array: Int32Array, from begin: Int, to end: Int) -> Int32Array

/// Copies `values` into `array` starting at index `0`. Returns an
/// error if `values` would extend past the end of `array`.
///
@external(javascript, "./int32_array.ffi.mjs", "set")
pub fn set(
  in array: Int32Array,
  values values: Int32Array,
) -> Result(Nil, JsError)

/// Copies `values` into `array` starting at `offset`. Returns an
/// error if `offset` is negative or the copy would extend past the
/// end of `array`.
///
@external(javascript, "./int32_array.ffi.mjs", "set_with_offset")
pub fn set_with_offset(
  in array: Int32Array,
  values values: Int32Array,
  offset offset: Int,
) -> Result(Nil, JsError)

@external(javascript, "./int32_array.ffi.mjs", "fill")
pub fn fill(array: Int32Array, with value: Int) -> Int32Array

@external(javascript, "./int32_array.ffi.mjs", "reverse")
pub fn reverse(array: Int32Array) -> Int32Array

@external(javascript, "./int32_array.ffi.mjs", "to_list")
pub fn to_list(array: Int32Array) -> List(Int)
