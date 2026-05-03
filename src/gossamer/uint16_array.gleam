import gossamer/array_buffer.{type ArrayBuffer}
import gossamer/js_error.{type JsError}

/// A typed array of 16-bit unsigned integers.
///
/// See [Uint16Array](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Uint16Array) on MDN.
///
@external(javascript, "./uint16_array.type.ts", "Uint16Array$")
pub type Uint16Array

@external(javascript, "./uint16_array.ffi.mjs", "new_")
pub fn new() -> Uint16Array

/// Creates a zero-filled `Uint16Array` of the given length. Returns
/// an error if `length` is negative or exceeds the maximum
/// allocatable size.
///
@external(javascript, "./uint16_array.ffi.mjs", "from_length")
pub fn from_length(length: Int) -> Result(Uint16Array, JsError)

/// Creates a `Uint16Array` from a list of 16-bit unsigned integers.
/// Values outside `0`–`65_535` are wrapped modulo `65_536`,
/// matching the JS `Uint16Array` constructor.
///
@external(javascript, "./uint16_array.ffi.mjs", "from_list")
pub fn from_list(list: List(Int)) -> Uint16Array

/// Creates a `Uint16Array` view over `buffer`. Returns an error if
/// `buffer.byteLength` is not a multiple of `2` (the element
/// size).
///
@external(javascript, "./uint16_array.ffi.mjs", "from_buffer")
pub fn from_buffer(buffer: ArrayBuffer) -> Result(Uint16Array, JsError)

@external(javascript, "./uint16_array.ffi.mjs", "buffer")
pub fn buffer(of array: Uint16Array) -> ArrayBuffer

@external(javascript, "./uint16_array.ffi.mjs", "byte_length")
pub fn byte_length(of array: Uint16Array) -> Int

@external(javascript, "./uint16_array.ffi.mjs", "byte_offset")
pub fn byte_offset(of array: Uint16Array) -> Int

@external(javascript, "./uint16_array.ffi.mjs", "length")
pub fn length(of array: Uint16Array) -> Int

/// Returns the element at `index`, or `Error(Nil)` if the index is
/// out of range. Negative indices count from the end.
///
@external(javascript, "./uint16_array.ffi.mjs", "at")
pub fn at(array: Uint16Array, index index: Int) -> Result(Int, Nil)

/// Returns a copy of `array` with the value at `index` replaced.
/// Negative indices count from the end. Returns an error if `index`
/// is out of range.
///
@external(javascript, "./uint16_array.ffi.mjs", "with_")
pub fn with(
  array: Uint16Array,
  at_index index: Int,
  value value: Int,
) -> Result(Uint16Array, JsError)

@external(javascript, "./uint16_array.ffi.mjs", "includes")
pub fn includes(in array: Uint16Array, value value: Int) -> Bool

/// Returns the first index of `value`, or `Error(Nil)` if not present.
///
@external(javascript, "./uint16_array.ffi.mjs", "index_of")
pub fn index_of(in array: Uint16Array, value value: Int) -> Result(Int, Nil)

/// Returns the last index of `value`, or `Error(Nil)` if not present.
///
@external(javascript, "./uint16_array.ffi.mjs", "last_index_of")
pub fn last_index_of(
  in array: Uint16Array,
  value value: Int,
) -> Result(Int, Nil)

@external(javascript, "./uint16_array.ffi.mjs", "slice")
pub fn slice(array: Uint16Array) -> Uint16Array

@external(javascript, "./uint16_array.ffi.mjs", "slice_range")
pub fn slice_range(
  array: Uint16Array,
  from start: Int,
  to end: Int,
) -> Uint16Array

@external(javascript, "./uint16_array.ffi.mjs", "subarray")
pub fn subarray(array: Uint16Array, from begin: Int, to end: Int) -> Uint16Array

/// Copies `values` into `array` starting at index `0`. Returns an
/// error if `values` would extend past the end of `array`.
///
@external(javascript, "./uint16_array.ffi.mjs", "set")
pub fn set(
  in array: Uint16Array,
  values values: Uint16Array,
) -> Result(Nil, JsError)

/// Copies `values` into `array` starting at `offset`. Returns an
/// error if `offset` is negative or the copy would extend past the
/// end of `array`.
///
@external(javascript, "./uint16_array.ffi.mjs", "set_with_offset")
pub fn set_with_offset(
  in array: Uint16Array,
  values values: Uint16Array,
  offset offset: Int,
) -> Result(Nil, JsError)

@external(javascript, "./uint16_array.ffi.mjs", "fill")
pub fn fill(array: Uint16Array, with value: Int) -> Uint16Array

@external(javascript, "./uint16_array.ffi.mjs", "reverse")
pub fn reverse(array: Uint16Array) -> Uint16Array

@external(javascript, "./uint16_array.ffi.mjs", "to_list")
pub fn to_list(array: Uint16Array) -> List(Int)
