import gossamer/buffer.{type BufferError}

/// A generic raw binary data buffer.
///
/// See [ArrayBuffer](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/ArrayBuffer) on MDN.
///
@external(javascript, "./array_buffer.type.ts", "ArrayBuffer$")
pub type ArrayBuffer

/// Creates a fixed-size `ArrayBuffer` of `byte_length` bytes. A
/// non-positive `byte_length` returns an empty buffer.
///
@external(javascript, "./array_buffer.ffi.mjs", "new_")
pub fn new(byte_length: Int) -> ArrayBuffer

@external(javascript, "./array_buffer.ffi.mjs", "byte_length")
pub fn byte_length(array_buffer: ArrayBuffer) -> Int

@external(javascript, "./array_buffer.ffi.mjs", "is_view")
pub fn is_view(value: a) -> Bool

@external(javascript, "./array_buffer.ffi.mjs", "slice")
pub fn slice(array_buffer: ArrayBuffer) -> ArrayBuffer

@external(javascript, "./array_buffer.ffi.mjs", "slice_from")
pub fn slice_from(array_buffer: ArrayBuffer, start: Int) -> ArrayBuffer

@external(javascript, "./array_buffer.ffi.mjs", "slice_range")
pub fn slice_range(
  array_buffer: ArrayBuffer,
  from start: Int,
  to end: Int,
) -> ArrayBuffer

/// Wraps the buffer's bytes as a `BitArray`. Returns `Detached` if the
/// buffer is detached.
///
@external(javascript, "./array_buffer.ffi.mjs", "to_bit_array")
pub fn to_bit_array(array_buffer: ArrayBuffer) -> Result(BitArray, BufferError)
