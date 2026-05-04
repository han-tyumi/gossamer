import gossamer/array_buffer.{type ArrayBuffer}
import gossamer/js_error.{type JsError}

/// A typed array of 8-bit unsigned integers, clamped to `0`–`255` on
/// write (rather than wrapped). Useful for image pixel data where
/// values should saturate at the boundaries.
///
/// See [Uint8ClampedArray](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Uint8ClampedArray) on MDN.
///
@external(javascript, "./uint8_clamped_array.type.ts", "Uint8ClampedArray$")
pub type Uint8ClampedArray

@external(javascript, "./uint8_clamped_array.ffi.mjs", "new_")
pub fn new() -> Uint8ClampedArray

/// Creates a zero-filled `Uint8ClampedArray` of the given length.
/// Returns an error if `length` is negative or exceeds the maximum
/// allocatable size.
///
@external(javascript, "./uint8_clamped_array.ffi.mjs", "from_length")
pub fn from_length(length: Int) -> Result(Uint8ClampedArray, JsError)

/// Creates a `Uint8ClampedArray` from a list of byte values. Values
/// outside `0`–`255` are *clamped* to that range (negative values
/// become `0`, values above `255` become `255`), unlike `Uint8Array`
/// which wraps modulo `256`.
///
@external(javascript, "./uint8_clamped_array.ffi.mjs", "from_list")
pub fn from_list(list: List(Int)) -> Uint8ClampedArray

@external(javascript, "./uint8_clamped_array.ffi.mjs", "from_buffer")
pub fn from_buffer(buffer: ArrayBuffer) -> Uint8ClampedArray

/// Creates a `Uint8ClampedArray` view over a slice of `buffer` starting
/// at `byte_offset` and spanning `length` elements. Returns an error if
/// the range is out of bounds or `buffer` is detached.
///
@external(javascript, "./uint8_clamped_array.ffi.mjs", "from_buffer_range")
pub fn from_buffer_range(
  buffer: ArrayBuffer,
  byte_offset byte_offset: Int,
  length length: Int,
) -> Result(Uint8ClampedArray, JsError)

@external(javascript, "./uint8_clamped_array.ffi.mjs", "buffer")
pub fn buffer(of array: Uint8ClampedArray) -> ArrayBuffer

@external(javascript, "./uint8_clamped_array.ffi.mjs", "byte_length")
pub fn byte_length(of array: Uint8ClampedArray) -> Int

@external(javascript, "./uint8_clamped_array.ffi.mjs", "byte_offset")
pub fn byte_offset(of array: Uint8ClampedArray) -> Int

@external(javascript, "./uint8_clamped_array.ffi.mjs", "length")
pub fn length(of array: Uint8ClampedArray) -> Int

/// Returns the element at `index`, or `Error(Nil)` if the index is
/// out of range. Negative indices count from the end.
///
@external(javascript, "./uint8_clamped_array.ffi.mjs", "at")
pub fn at(array: Uint8ClampedArray, index index: Int) -> Result(Int, Nil)

/// Returns a copy of `array` with the value at `index` replaced.
/// Negative indices count from the end. Returns an error if `index`
/// is out of range.
///
@external(javascript, "./uint8_clamped_array.ffi.mjs", "with_")
pub fn with(
  array: Uint8ClampedArray,
  at_index index: Int,
  value value: Int,
) -> Result(Uint8ClampedArray, JsError)

@external(javascript, "./uint8_clamped_array.ffi.mjs", "includes")
pub fn includes(in array: Uint8ClampedArray, value value: Int) -> Bool

/// Returns the first index of `value`, or `Error(Nil)` if not present.
///
@external(javascript, "./uint8_clamped_array.ffi.mjs", "index_of")
pub fn index_of(
  in array: Uint8ClampedArray,
  value value: Int,
) -> Result(Int, Nil)

/// Returns the last index of `value`, or `Error(Nil)` if not present.
///
@external(javascript, "./uint8_clamped_array.ffi.mjs", "last_index_of")
pub fn last_index_of(
  in array: Uint8ClampedArray,
  value value: Int,
) -> Result(Int, Nil)

@external(javascript, "./uint8_clamped_array.ffi.mjs", "slice")
pub fn slice(array: Uint8ClampedArray) -> Uint8ClampedArray

@external(javascript, "./uint8_clamped_array.ffi.mjs", "slice_range")
pub fn slice_range(
  array: Uint8ClampedArray,
  from start: Int,
  to end: Int,
) -> Uint8ClampedArray

@external(javascript, "./uint8_clamped_array.ffi.mjs", "subarray")
pub fn subarray(
  array: Uint8ClampedArray,
  from begin: Int,
  to end: Int,
) -> Uint8ClampedArray

/// Copies `values` into `array` starting at index `0`. Returns an
/// error if `values` would extend past the end of `array`.
///
@external(javascript, "./uint8_clamped_array.ffi.mjs", "set")
pub fn set(
  in array: Uint8ClampedArray,
  values values: Uint8ClampedArray,
) -> Result(Nil, JsError)

/// Copies `values` into `array` starting at `offset`. Returns an
/// error if `offset` is negative or the copy would extend past the
/// end of `array`.
///
@external(javascript, "./uint8_clamped_array.ffi.mjs", "set_with_offset")
pub fn set_with_offset(
  in array: Uint8ClampedArray,
  values values: Uint8ClampedArray,
  offset offset: Int,
) -> Result(Nil, JsError)

@external(javascript, "./uint8_clamped_array.ffi.mjs", "fill")
pub fn fill(array: Uint8ClampedArray, with value: Int) -> Uint8ClampedArray

@external(javascript, "./uint8_clamped_array.ffi.mjs", "reverse")
pub fn reverse(array: Uint8ClampedArray) -> Uint8ClampedArray

@external(javascript, "./uint8_clamped_array.ffi.mjs", "to_list")
pub fn to_list(array: Uint8ClampedArray) -> List(Int)
