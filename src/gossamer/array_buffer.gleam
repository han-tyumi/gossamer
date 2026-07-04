//// A transit type for JavaScript `ArrayBuffer` interop. For byte data
//// in pure Gleam, prefer `BitArray`; bridge with
//// [`from_bit_array`](#from_bit_array) /
//// [`to_bit_array`](#to_bit_array).

/// A generic raw binary data buffer.
///
/// `ArrayBuffer` is a transit type — it exists for interop with
/// JavaScript APIs that specifically require an `ArrayBuffer`. For
/// byte data in Gleam, prefer `BitArray`. Bridge with `from_bit_array`
/// / `to_bit_array`.
///
/// See [ArrayBuffer](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/ArrayBuffer) on MDN.
///
@external(javascript, "./array_buffer.type.ts", "ArrayBuffer$")
pub type ArrayBuffer

/// Creates a fixed-size `ArrayBuffer` of `byte_length` bytes. A
/// non-positive `byte_length` returns an empty buffer. Panics when
/// `byte_length` exceeds the engine's maximum buffer size.
///
@external(javascript, "./array_buffer.ffi.mjs", "new_")
pub fn new(byte_length: Int) -> ArrayBuffer

/// The size of the buffer in bytes.
///
@external(javascript, "./array_buffer.ffi.mjs", "byte_length")
pub fn byte_length(array_buffer: ArrayBuffer) -> Int

/// Creates an `ArrayBuffer` containing the bytes of `bit_array`.
/// Un-aligned bit arrays are zero-padded to the next byte.
///
@external(javascript, "./array_buffer.ffi.mjs", "from_bit_array")
pub fn from_bit_array(bit_array: BitArray) -> ArrayBuffer

/// Wraps the buffer's bytes as a `BitArray`.
///
@external(javascript, "./array_buffer.ffi.mjs", "to_bit_array")
pub fn to_bit_array(array_buffer: ArrayBuffer) -> BitArray
