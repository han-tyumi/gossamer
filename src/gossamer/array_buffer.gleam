/// Represents a raw buffer of binary data, which is used to store data for the
/// different typed arrays. ArrayBuffers cannot be read from or written to
/// directly, but can be passed to a typed array or DataView Object to interpret
/// the raw buffer as needed.
///
@external(javascript, "./array_buffer.type.ts", "ArrayBuffer$")
pub type ArrayBuffer

@external(javascript, "./array_buffer.ffi.mjs", "new_")
pub fn new(byte_length: Int) -> ArrayBuffer

/// The length of the ArrayBuffer (in bytes).
///
@external(javascript, "./array_buffer.ffi.mjs", "byte_length")
pub fn byte_length(array_buffer: ArrayBuffer) -> Int

@external(javascript, "./array_buffer.ffi.mjs", "slice")
pub fn slice(array_buffer: ArrayBuffer, begin: Int) -> ArrayBuffer

@external(javascript, "./array_buffer.ffi.mjs", "slice_with_end")
pub fn slice_with_end(
  array_buffer: ArrayBuffer,
  begin: Int,
  end: Int,
) -> ArrayBuffer
