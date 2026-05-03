import gossamer/array_buffer.{type ArrayBuffer}
import gossamer/big_int.{type BigInt}
import gossamer/js_error.{type JsError}

/// A low-level view over an `ArrayBuffer` for reading and writing
/// numeric values at byte offsets in either byte order.
///
/// See [DataView](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/DataView) on MDN.
///
@external(javascript, "./data_view.type.ts", "DataView$")
pub type DataView

/// Creates a `DataView` over the entirety of `buffer`. Returns an error
/// if `buffer` is detached.
///
@external(javascript, "./data_view.ffi.mjs", "new_")
pub fn new(buffer: ArrayBuffer) -> Result(DataView, JsError)

/// Creates a `DataView` over a slice of `buffer` starting at
/// `byte_offset` and spanning `byte_length` bytes. Returns an error if
/// `buffer` is detached or the requested range falls outside `buffer`.
///
@external(javascript, "./data_view.ffi.mjs", "new_range")
pub fn new_range(
  buffer: ArrayBuffer,
  byte_offset byte_offset: Int,
  byte_length byte_length: Int,
) -> Result(DataView, JsError)

@external(javascript, "./data_view.ffi.mjs", "buffer")
pub fn buffer(of view: DataView) -> ArrayBuffer

/// The number of bytes covered by the view. Returns an error if the
/// underlying buffer has been detached or resized below the view's
/// range.
///
@external(javascript, "./data_view.ffi.mjs", "byte_length")
pub fn byte_length(of view: DataView) -> Result(Int, JsError)

/// The offset, in bytes, from the start of the underlying buffer.
/// Returns an error if the underlying buffer has been detached or
/// resized below the view's range.
///
@external(javascript, "./data_view.ffi.mjs", "byte_offset")
pub fn byte_offset(of view: DataView) -> Result(Int, JsError)

/// Reads a signed 8-bit integer at `offset`. Returns an error if
/// `offset` is out of bounds.
///
@external(javascript, "./data_view.ffi.mjs", "get_int8")
pub fn get_int8(view: DataView, at_offset offset: Int) -> Result(Int, JsError)

/// Reads an unsigned 8-bit integer at `offset`. Returns an error if
/// `offset` is out of bounds.
///
@external(javascript, "./data_view.ffi.mjs", "get_uint8")
pub fn get_uint8(view: DataView, at_offset offset: Int) -> Result(Int, JsError)

/// Reads a signed 16-bit integer at `offset`. Returns an error if
/// `offset` is out of bounds.
///
@external(javascript, "./data_view.ffi.mjs", "get_int16")
pub fn get_int16(
  view: DataView,
  at_offset offset: Int,
  little_endian little_endian: Bool,
) -> Result(Int, JsError)

/// Reads an unsigned 16-bit integer at `offset`. Returns an error if
/// `offset` is out of bounds.
///
@external(javascript, "./data_view.ffi.mjs", "get_uint16")
pub fn get_uint16(
  view: DataView,
  at_offset offset: Int,
  little_endian little_endian: Bool,
) -> Result(Int, JsError)

/// Reads a signed 32-bit integer at `offset`. Returns an error if
/// `offset` is out of bounds.
///
@external(javascript, "./data_view.ffi.mjs", "get_int32")
pub fn get_int32(
  view: DataView,
  at_offset offset: Int,
  little_endian little_endian: Bool,
) -> Result(Int, JsError)

/// Reads an unsigned 32-bit integer at `offset`. Returns an error if
/// `offset` is out of bounds.
///
@external(javascript, "./data_view.ffi.mjs", "get_uint32")
pub fn get_uint32(
  view: DataView,
  at_offset offset: Int,
  little_endian little_endian: Bool,
) -> Result(Int, JsError)

/// Reads a 16-bit IEEE 754 float at `offset`. Returns an error if
/// `offset` is out of bounds.
///
@external(javascript, "./data_view.ffi.mjs", "get_float16")
pub fn get_float16(
  view: DataView,
  at_offset offset: Int,
  little_endian little_endian: Bool,
) -> Result(Float, JsError)

/// Reads a 32-bit IEEE 754 float at `offset`. Returns an error if
/// `offset` is out of bounds.
///
@external(javascript, "./data_view.ffi.mjs", "get_float32")
pub fn get_float32(
  view: DataView,
  at_offset offset: Int,
  little_endian little_endian: Bool,
) -> Result(Float, JsError)

/// Reads a 64-bit IEEE 754 float at `offset`. Returns an error if
/// `offset` is out of bounds.
///
@external(javascript, "./data_view.ffi.mjs", "get_float64")
pub fn get_float64(
  view: DataView,
  at_offset offset: Int,
  little_endian little_endian: Bool,
) -> Result(Float, JsError)

/// Reads a signed 64-bit integer at `offset`. Returns an error if
/// `offset` is out of bounds.
///
@external(javascript, "./data_view.ffi.mjs", "get_bigint64")
pub fn get_bigint64(
  view: DataView,
  at_offset offset: Int,
  little_endian little_endian: Bool,
) -> Result(BigInt, JsError)

/// Reads an unsigned 64-bit integer at `offset`. Returns an error if
/// `offset` is out of bounds.
///
@external(javascript, "./data_view.ffi.mjs", "get_biguint64")
pub fn get_biguint64(
  view: DataView,
  at_offset offset: Int,
  little_endian little_endian: Bool,
) -> Result(BigInt, JsError)

/// Writes a signed 8-bit integer at `offset`. Returns an error if
/// `offset` is out of bounds.
///
@external(javascript, "./data_view.ffi.mjs", "set_int8")
pub fn set_int8(
  view: DataView,
  at_offset offset: Int,
  value value: Int,
) -> Result(Nil, JsError)

/// Writes an unsigned 8-bit integer at `offset`. Returns an error if
/// `offset` is out of bounds.
///
@external(javascript, "./data_view.ffi.mjs", "set_uint8")
pub fn set_uint8(
  view: DataView,
  at_offset offset: Int,
  value value: Int,
) -> Result(Nil, JsError)

/// Writes a signed 16-bit integer at `offset`. Returns an error if
/// `offset` is out of bounds.
///
@external(javascript, "./data_view.ffi.mjs", "set_int16")
pub fn set_int16(
  view: DataView,
  at_offset offset: Int,
  value value: Int,
  little_endian little_endian: Bool,
) -> Result(Nil, JsError)

/// Writes an unsigned 16-bit integer at `offset`. Returns an error if
/// `offset` is out of bounds.
///
@external(javascript, "./data_view.ffi.mjs", "set_uint16")
pub fn set_uint16(
  view: DataView,
  at_offset offset: Int,
  value value: Int,
  little_endian little_endian: Bool,
) -> Result(Nil, JsError)

/// Writes a signed 32-bit integer at `offset`. Returns an error if
/// `offset` is out of bounds.
///
@external(javascript, "./data_view.ffi.mjs", "set_int32")
pub fn set_int32(
  view: DataView,
  at_offset offset: Int,
  value value: Int,
  little_endian little_endian: Bool,
) -> Result(Nil, JsError)

/// Writes an unsigned 32-bit integer at `offset`. Returns an error if
/// `offset` is out of bounds.
///
@external(javascript, "./data_view.ffi.mjs", "set_uint32")
pub fn set_uint32(
  view: DataView,
  at_offset offset: Int,
  value value: Int,
  little_endian little_endian: Bool,
) -> Result(Nil, JsError)

/// Writes a 16-bit IEEE 754 float at `offset`. Returns an error if
/// `offset` is out of bounds.
///
@external(javascript, "./data_view.ffi.mjs", "set_float16")
pub fn set_float16(
  view: DataView,
  at_offset offset: Int,
  value value: Float,
  little_endian little_endian: Bool,
) -> Result(Nil, JsError)

/// Writes a 32-bit IEEE 754 float at `offset`. Returns an error if
/// `offset` is out of bounds.
///
@external(javascript, "./data_view.ffi.mjs", "set_float32")
pub fn set_float32(
  view: DataView,
  at_offset offset: Int,
  value value: Float,
  little_endian little_endian: Bool,
) -> Result(Nil, JsError)

/// Writes a 64-bit IEEE 754 float at `offset`. Returns an error if
/// `offset` is out of bounds.
///
@external(javascript, "./data_view.ffi.mjs", "set_float64")
pub fn set_float64(
  view: DataView,
  at_offset offset: Int,
  value value: Float,
  little_endian little_endian: Bool,
) -> Result(Nil, JsError)

/// Writes a signed 64-bit integer at `offset`. Returns an error if
/// `offset` is out of bounds.
///
@external(javascript, "./data_view.ffi.mjs", "set_bigint64")
pub fn set_bigint64(
  view: DataView,
  at_offset offset: Int,
  value value: BigInt,
  little_endian little_endian: Bool,
) -> Result(Nil, JsError)

/// Writes an unsigned 64-bit integer at `offset`. Returns an error if
/// `offset` is out of bounds.
///
@external(javascript, "./data_view.ffi.mjs", "set_biguint64")
pub fn set_biguint64(
  view: DataView,
  at_offset offset: Int,
  value value: BigInt,
  little_endian little_endian: Bool,
) -> Result(Nil, JsError)
