//// JavaScript `Uint8Array` bindings for interop with APIs that
//// specifically require a typed byte array. Treated as a transit type:
//// bridge to `BitArray` via [`to_bit_array`](#to_bit_array) and operate
//// on the canonical Gleam surface for transformations, then
//// [`from_bit_array`](#from_bit_array) back when handing off to
//// JavaScript.

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

/// Creates a `Uint8Array` view over the entirety of `buffer`.
///
@external(javascript, "./uint8_array.ffi.mjs", "from_buffer")
pub fn from_buffer(buffer: ArrayBuffer) -> Uint8Array

/// Creates a `Uint8Array` view over a slice of `buffer` starting at
/// `byte_offset` and spanning `length` bytes. Returns `Error(Nil)`
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

/// Wraps the bytes of `array` as a `BitArray`.
///
@external(javascript, "./uint8_array.ffi.mjs", "to_bit_array")
pub fn to_bit_array(array: Uint8Array) -> BitArray
