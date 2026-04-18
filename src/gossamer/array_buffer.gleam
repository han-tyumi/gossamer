@external(javascript, "./array_buffer.type.ts", "ArrayBuffer$")
pub type ArrayBuffer

pub type ArrayBufferView {
  ArrayBufferView(buffer: ArrayBuffer, byte_length: Int, byte_offset: Int)
}

@external(javascript, "./array_buffer.ffi.mjs", "new_")
pub fn new(byte_length: Int) -> ArrayBuffer

@external(javascript, "./array_buffer.ffi.mjs", "byte_length")
pub fn byte_length(of array_buffer: ArrayBuffer) -> Int

/// Creates a resizable `ArrayBuffer` with the given initial byte length and
/// maximum byte length.
///
@external(javascript, "./array_buffer.ffi.mjs", "new_resizable")
pub fn new_resizable(byte_length: Int, max_byte_length max: Int) -> ArrayBuffer

@external(javascript, "./array_buffer.ffi.mjs", "max_byte_length")
pub fn max_byte_length(of array_buffer: ArrayBuffer) -> Int

@external(javascript, "./array_buffer.ffi.mjs", "is_resizable")
pub fn is_resizable(array_buffer: ArrayBuffer) -> Bool

@external(javascript, "./array_buffer.ffi.mjs", "is_view")
pub fn is_view(value: a) -> Bool

@external(javascript, "./array_buffer.ffi.mjs", "is_detached")
pub fn is_detached(array_buffer: ArrayBuffer) -> Bool

@external(javascript, "./array_buffer.ffi.mjs", "transfer")
pub fn transfer(array_buffer: ArrayBuffer) -> ArrayBuffer

/// Resizes the `ArrayBuffer` to the specified byte length. The buffer must
/// have been created with `new_resizable`. Returns an error if the new length
/// exceeds the maximum byte length.
///
@external(javascript, "./array_buffer.ffi.mjs", "resize")
pub fn resize(
  array_buffer: ArrayBuffer,
  to byte_length: Int,
) -> Result(Nil, String)

@external(javascript, "./array_buffer.ffi.mjs", "slice")
pub fn slice(array_buffer: ArrayBuffer, from begin: Int) -> ArrayBuffer

@external(javascript, "./array_buffer.ffi.mjs", "slice_with_end")
pub fn slice_with_end(
  array_buffer: ArrayBuffer,
  from begin: Int,
  to end: Int,
) -> ArrayBuffer
