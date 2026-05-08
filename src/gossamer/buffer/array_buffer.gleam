import gossamer/js_error.{type JsError}

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

/// Creates a resizable `ArrayBuffer` with the given initial and maximum
/// byte lengths. A non-positive `byte_length` returns an empty buffer;
/// `max` is clamped up to `byte_length` if smaller.
///
@external(javascript, "./array_buffer.ffi.mjs", "new_resizable")
pub fn new_resizable(byte_length: Int, max_byte_length max: Int) -> ArrayBuffer

@external(javascript, "./array_buffer.ffi.mjs", "max_byte_length")
pub fn max_byte_length(array_buffer: ArrayBuffer) -> Int

@external(javascript, "./array_buffer.ffi.mjs", "is_resizable")
pub fn is_resizable(array_buffer: ArrayBuffer) -> Bool

@external(javascript, "./array_buffer.ffi.mjs", "is_view")
pub fn is_view(value: a) -> Bool

@external(javascript, "./array_buffer.ffi.mjs", "is_detached")
pub fn is_detached(array_buffer: ArrayBuffer) -> Bool

/// Transfers the buffer's contents to a new `ArrayBuffer`, detaching the
/// original. Returns an error if the buffer is already detached.
///
@external(javascript, "./array_buffer.ffi.mjs", "transfer")
pub fn transfer(array_buffer: ArrayBuffer) -> Result(ArrayBuffer, JsError)

/// Resizes the `ArrayBuffer` to the specified byte length. The buffer must
/// have been created with `new_resizable`. Returns an error if the new length
/// exceeds the maximum byte length.
///
@external(javascript, "./array_buffer.ffi.mjs", "resize")
pub fn resize(
  array_buffer: ArrayBuffer,
  to byte_length: Int,
) -> Result(Nil, JsError)

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
