@external(javascript, "./array_buffer.type.ts", "ArrayBuffer$")
pub type ArrayBuffer

@external(javascript, "./array_buffer.ffi.mjs", "new_")
pub fn new(byte_length: Int) -> ArrayBuffer

@external(javascript, "./array_buffer.ffi.mjs", "byte_length")
pub fn byte_length(of array_buffer: ArrayBuffer) -> Int

@external(javascript, "./array_buffer.ffi.mjs", "is_view")
pub fn is_view(value: a) -> Bool

@external(javascript, "./array_buffer.ffi.mjs", "is_detached")
pub fn is_detached(array_buffer: ArrayBuffer) -> Bool

@external(javascript, "./array_buffer.ffi.mjs", "transfer")
pub fn transfer(array_buffer: ArrayBuffer) -> ArrayBuffer

@external(javascript, "./array_buffer.ffi.mjs", "slice")
pub fn slice(array_buffer: ArrayBuffer, from begin: Int) -> ArrayBuffer

@external(javascript, "./array_buffer.ffi.mjs", "slice_with_end")
pub fn slice_with_end(
  array_buffer: ArrayBuffer,
  from begin: Int,
  to end: Int,
) -> ArrayBuffer
