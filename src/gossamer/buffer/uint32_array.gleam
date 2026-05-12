import gossamer/buffer.{type BufferError}
import gossamer/buffer/array_buffer.{type ArrayBuffer}
import gossamer/buffer/uint8_array.{type Uint8Array}

/// A typed array of 32-bit unsigned integers.
///
/// See [Uint32Array](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Uint32Array) on MDN.
///
@external(javascript, "./uint32_array.type.ts", "Uint32Array$")
pub type Uint32Array

@external(javascript, "./uint32_array.ffi.mjs", "new_")
pub fn new() -> Uint32Array

/// Creates a zero-filled `Uint32Array` of the given length. A
/// non-positive `length` returns an empty array.
///
@external(javascript, "./uint32_array.ffi.mjs", "from_length")
pub fn from_length(length: Int) -> Uint32Array

/// Creates a `Uint32Array` from a list of 32-bit unsigned integers.
/// Values outside `0`–`4_294_967_295` are wrapped modulo `4_294_967_296`,
/// matching the JS `Uint32Array` constructor.
///
@external(javascript, "./uint32_array.ffi.mjs", "from_list")
pub fn from_list(list: List(Int)) -> Uint32Array

/// Creates a `Uint32Array` view over `buffer`. Returns
/// `MisalignedOffset` if `buffer.byteLength` is not a multiple of `4`
/// (the element size).
///
@external(javascript, "./uint32_array.ffi.mjs", "from_buffer")
pub fn from_buffer(buffer: ArrayBuffer) -> Result(Uint32Array, BufferError)

/// Creates a `Uint32Array` view over a slice of `buffer` starting at
/// `byte_offset` and spanning `length` elements. Returns
/// `MisalignedOffset` if `byte_offset` is not a multiple of `4`, or
/// `OutOfRange` if the range falls outside `buffer`.
///
@external(javascript, "./uint32_array.ffi.mjs", "from_buffer_range")
pub fn from_buffer_range(
  buffer: ArrayBuffer,
  byte_offset byte_offset: Int,
  length length: Int,
) -> Result(Uint32Array, BufferError)

@external(javascript, "./uint32_array.ffi.mjs", "buffer")
pub fn buffer(array: Uint32Array) -> ArrayBuffer

/// A `Uint8Array` over the same bytes as `array`, sharing memory with
/// the underlying buffer.
///
@external(javascript, "./uint32_array.ffi.mjs", "bytes")
pub fn bytes(array: Uint32Array) -> Uint8Array

@external(javascript, "./uint32_array.ffi.mjs", "byte_length")
pub fn byte_length(array: Uint32Array) -> Int

@external(javascript, "./uint32_array.ffi.mjs", "byte_offset")
pub fn byte_offset(array: Uint32Array) -> Int

@external(javascript, "./uint32_array.ffi.mjs", "length")
pub fn length(array: Uint32Array) -> Int

/// Returns the element at `index`, or `Error(Nil)` if the index is
/// out of range. Negative indices count from the end.
///
@external(javascript, "./uint32_array.ffi.mjs", "at")
pub fn at(array: Uint32Array, index index: Int) -> Result(Int, Nil)

/// Returns a copy of `array` with the value at `index` replaced.
/// Negative indices count from the end. Returns `OutOfRange` if
/// `index` is out of range.
///
@external(javascript, "./uint32_array.ffi.mjs", "with_")
pub fn with(
  array: Uint32Array,
  at_index index: Int,
  value value: Int,
) -> Result(Uint32Array, BufferError)

@external(javascript, "./uint32_array.ffi.mjs", "includes")
pub fn includes(in array: Uint32Array, value value: Int) -> Bool

/// Returns the first index of `value`, or `Error(Nil)` if not present.
///
@external(javascript, "./uint32_array.ffi.mjs", "index_of")
pub fn index_of(in array: Uint32Array, value value: Int) -> Result(Int, Nil)

/// Returns the last index of `value`, or `Error(Nil)` if not present.
///
@external(javascript, "./uint32_array.ffi.mjs", "last_index_of")
pub fn last_index_of(
  in array: Uint32Array,
  value value: Int,
) -> Result(Int, Nil)

@external(javascript, "./uint32_array.ffi.mjs", "slice")
pub fn slice(array: Uint32Array) -> Uint32Array

@external(javascript, "./uint32_array.ffi.mjs", "slice_range")
pub fn slice_range(
  array: Uint32Array,
  from start: Int,
  to end: Int,
) -> Uint32Array

@external(javascript, "./uint32_array.ffi.mjs", "subarray")
pub fn subarray(array: Uint32Array, from begin: Int, to end: Int) -> Uint32Array

/// Copies `values` into `array` starting at index `0`. Returns
/// `OutOfRange` if `values` would extend past the end of `array`.
///
@external(javascript, "./uint32_array.ffi.mjs", "set")
pub fn set(
  in array: Uint32Array,
  values values: Uint32Array,
) -> Result(Nil, BufferError)

/// Copies `values` into `array` starting at `offset`. Returns
/// `OutOfRange` if `offset` is negative or the copy would extend past
/// the end of `array`.
///
@external(javascript, "./uint32_array.ffi.mjs", "set_with_offset")
pub fn set_with_offset(
  in array: Uint32Array,
  values values: Uint32Array,
  offset offset: Int,
) -> Result(Nil, BufferError)

@external(javascript, "./uint32_array.ffi.mjs", "fill")
pub fn fill(array: Uint32Array, with value: Int) -> Uint32Array

@external(javascript, "./uint32_array.ffi.mjs", "reverse")
pub fn reverse(array: Uint32Array) -> Uint32Array

@external(javascript, "./uint32_array.ffi.mjs", "to_list")
pub fn to_list(array: Uint32Array) -> List(Int)
