import gossamer/buffer/array_buffer.{type ArrayBuffer}

/// A typed array of 8-bit unsigned integers (bytes).
///
/// `Uint8Array` is a transit type — it exists for interop with
/// JavaScript APIs that specifically require a `Uint8Array`. For byte
/// data in Gleam, prefer `BitArray`. Bridge with `from_bit_array` /
/// `to_bit_array`.
///
/// See [Uint8Array](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Uint8Array) on MDN.
///
@external(javascript, "./uint8_array.type.ts", "Uint8Array$")
pub type Uint8Array

/// Creates an empty `Uint8Array`.
///
@external(javascript, "./uint8_array.ffi.mjs", "new_")
pub fn new() -> Uint8Array

/// Creates a `Uint8Array` from a list of byte values. Values outside
/// `0`–`255` are wrapped modulo `256`, matching the JavaScript
/// `Uint8Array` constructor — `from_list([257])` yields a one-byte
/// array containing `1`.
///
@external(javascript, "./uint8_array.ffi.mjs", "from_list")
pub fn from_list(list: List(Int)) -> Uint8Array

/// Creates a `Uint8Array` view over the entirety of `buffer`.
///
@external(javascript, "./uint8_array.ffi.mjs", "from_buffer")
pub fn from_buffer(buffer: ArrayBuffer) -> Uint8Array

/// Creates a `Uint8Array` view over a slice of `buffer` starting at
/// `byte_offset` and spanning `length` elements. Returns `Error(Nil)`
/// if the range falls outside `buffer`.
///
@external(javascript, "./uint8_array.ffi.mjs", "from_buffer_range")
pub fn from_buffer_range(
  buffer: ArrayBuffer,
  byte_offset byte_offset: Int,
  length length: Int,
) -> Result(Uint8Array, Nil)

/// Creates a `Uint8Array` from a `BitArray`. Un-aligned bit arrays are
/// zero-padded to the next byte.
///
@external(javascript, "./uint8_array.ffi.mjs", "from_bit_array")
pub fn from_bit_array(bit_array: BitArray) -> Uint8Array

/// The underlying `ArrayBuffer` of `array`.
///
@external(javascript, "./uint8_array.ffi.mjs", "buffer")
pub fn buffer(array: Uint8Array) -> ArrayBuffer

/// The number of bytes in the array.
///
@external(javascript, "./uint8_array.ffi.mjs", "length")
pub fn length(array: Uint8Array) -> Int

/// Returns the byte at `index`, or `Error(Nil)` if the index is out of
/// bounds. Negative indices count from the end.
///
@external(javascript, "./uint8_array.ffi.mjs", "at")
pub fn at(array: Uint8Array, index index: Int) -> Result(Int, Nil)

/// Returns the bytes of `array` as a Gleam list.
///
@external(javascript, "./uint8_array.ffi.mjs", "to_list")
pub fn to_list(array: Uint8Array) -> List(Int)

/// Wraps the bytes of `array` as a `BitArray`.
///
@external(javascript, "./uint8_array.ffi.mjs", "to_bit_array")
pub fn to_bit_array(array: Uint8Array) -> BitArray
