import gossamer/big_int.{type BigInt}
import gossamer/buffer.{type BufferError}
import gossamer/buffer/array_buffer.{type ArrayBuffer}
import gossamer/buffer/uint8_array.{type Uint8Array}

/// A low-level view over an `ArrayBuffer` for reading and writing
/// numeric values at byte offsets in either byte order.
///
/// See [DataView](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/DataView) on MDN.
///
@external(javascript, "./data_view.type.ts", "DataView$")
pub type DataView

/// Creates a `DataView` over the entirety of `buffer`.
///
@external(javascript, "./data_view.ffi.mjs", "new_")
pub fn new(buffer: ArrayBuffer) -> DataView

/// Creates a `DataView` over a slice of `buffer` starting at
/// `byte_offset` and spanning `byte_length` bytes. Returns `OutOfRange`
/// if the requested range falls outside `buffer`.
///
@external(javascript, "./data_view.ffi.mjs", "new_range")
pub fn new_range(
  buffer: ArrayBuffer,
  byte_offset byte_offset: Int,
  byte_length byte_length: Int,
) -> Result(DataView, BufferError)

@external(javascript, "./data_view.ffi.mjs", "buffer")
pub fn buffer(view: DataView) -> ArrayBuffer

/// A `Uint8Array` over the same bytes as `view`, sharing memory with
/// the underlying buffer.
///
@external(javascript, "./data_view.ffi.mjs", "bytes")
pub fn bytes(view: DataView) -> Uint8Array

/// The number of bytes covered by the view.
///
@external(javascript, "./data_view.ffi.mjs", "byte_length")
pub fn byte_length(view: DataView) -> Int

/// The offset, in bytes, from the start of the underlying buffer.
///
@external(javascript, "./data_view.ffi.mjs", "byte_offset")
pub fn byte_offset(view: DataView) -> Int

/// Reads a signed 8-bit integer at `offset`. Returns `OutOfRange`
/// if `offset` is out of bounds.
///
@external(javascript, "./data_view.ffi.mjs", "get_int8")
pub fn get_int8(
  view: DataView,
  at_offset offset: Int,
) -> Result(Int, BufferError)

/// Reads an unsigned 8-bit integer at `offset`. Returns `OutOfRange`
/// if `offset` is out of bounds.
///
@external(javascript, "./data_view.ffi.mjs", "get_uint8")
pub fn get_uint8(
  view: DataView,
  at_offset offset: Int,
) -> Result(Int, BufferError)

/// Reads a signed 16-bit integer at `offset`. Returns `OutOfRange`
/// if `offset` is out of bounds.
///
@external(javascript, "./data_view.ffi.mjs", "get_int16")
pub fn get_int16(
  view: DataView,
  at_offset offset: Int,
  little_endian little_endian: Bool,
) -> Result(Int, BufferError)

/// Reads an unsigned 16-bit integer at `offset`. Returns `OutOfRange`
/// if `offset` is out of bounds.
///
@external(javascript, "./data_view.ffi.mjs", "get_uint16")
pub fn get_uint16(
  view: DataView,
  at_offset offset: Int,
  little_endian little_endian: Bool,
) -> Result(Int, BufferError)

/// Reads a signed 32-bit integer at `offset`. Returns `OutOfRange`
/// if `offset` is out of bounds.
///
@external(javascript, "./data_view.ffi.mjs", "get_int32")
pub fn get_int32(
  view: DataView,
  at_offset offset: Int,
  little_endian little_endian: Bool,
) -> Result(Int, BufferError)

/// Reads an unsigned 32-bit integer at `offset`. Returns `OutOfRange`
/// if `offset` is out of bounds.
///
@external(javascript, "./data_view.ffi.mjs", "get_uint32")
pub fn get_uint32(
  view: DataView,
  at_offset offset: Int,
  little_endian little_endian: Bool,
) -> Result(Int, BufferError)

/// Reads a 16-bit IEEE 754 float at `offset`. Returns `OutOfRange`
/// if `offset` is out of bounds.
///
@external(javascript, "./data_view.ffi.mjs", "get_float16")
pub fn get_float16(
  view: DataView,
  at_offset offset: Int,
  little_endian little_endian: Bool,
) -> Result(Float, BufferError)

/// Reads a 32-bit IEEE 754 float at `offset`. Returns `OutOfRange`
/// if `offset` is out of bounds.
///
@external(javascript, "./data_view.ffi.mjs", "get_float32")
pub fn get_float32(
  view: DataView,
  at_offset offset: Int,
  little_endian little_endian: Bool,
) -> Result(Float, BufferError)

/// Reads a 64-bit IEEE 754 float at `offset`. Returns `OutOfRange`
/// if `offset` is out of bounds.
///
@external(javascript, "./data_view.ffi.mjs", "get_float64")
pub fn get_float64(
  view: DataView,
  at_offset offset: Int,
  little_endian little_endian: Bool,
) -> Result(Float, BufferError)

/// Reads a signed 64-bit integer at `offset`. Returns `OutOfRange`
/// if `offset` is out of bounds.
///
@external(javascript, "./data_view.ffi.mjs", "get_bigint64")
pub fn get_bigint64(
  view: DataView,
  at_offset offset: Int,
  little_endian little_endian: Bool,
) -> Result(BigInt, BufferError)

/// Reads an unsigned 64-bit integer at `offset`. Returns `OutOfRange`
/// if `offset` is out of bounds.
///
@external(javascript, "./data_view.ffi.mjs", "get_biguint64")
pub fn get_biguint64(
  view: DataView,
  at_offset offset: Int,
  little_endian little_endian: Bool,
) -> Result(BigInt, BufferError)

/// Writes a signed 8-bit integer at `offset`. Returns `OutOfRange`
/// if `offset` is out of bounds.
///
@external(javascript, "./data_view.ffi.mjs", "set_int8")
pub fn set_int8(
  view: DataView,
  at_offset offset: Int,
  value value: Int,
) -> Result(Nil, BufferError)

/// Writes an unsigned 8-bit integer at `offset`. Returns `OutOfRange`
/// if `offset` is out of bounds.
///
@external(javascript, "./data_view.ffi.mjs", "set_uint8")
pub fn set_uint8(
  view: DataView,
  at_offset offset: Int,
  value value: Int,
) -> Result(Nil, BufferError)

/// Writes a signed 16-bit integer at `offset`. Returns `OutOfRange`
/// if `offset` is out of bounds.
///
@external(javascript, "./data_view.ffi.mjs", "set_int16")
pub fn set_int16(
  view: DataView,
  at_offset offset: Int,
  value value: Int,
  little_endian little_endian: Bool,
) -> Result(Nil, BufferError)

/// Writes an unsigned 16-bit integer at `offset`. Returns `OutOfRange`
/// if `offset` is out of bounds.
///
@external(javascript, "./data_view.ffi.mjs", "set_uint16")
pub fn set_uint16(
  view: DataView,
  at_offset offset: Int,
  value value: Int,
  little_endian little_endian: Bool,
) -> Result(Nil, BufferError)

/// Writes a signed 32-bit integer at `offset`. Returns `OutOfRange`
/// if `offset` is out of bounds.
///
@external(javascript, "./data_view.ffi.mjs", "set_int32")
pub fn set_int32(
  view: DataView,
  at_offset offset: Int,
  value value: Int,
  little_endian little_endian: Bool,
) -> Result(Nil, BufferError)

/// Writes an unsigned 32-bit integer at `offset`. Returns `OutOfRange`
/// if `offset` is out of bounds.
///
@external(javascript, "./data_view.ffi.mjs", "set_uint32")
pub fn set_uint32(
  view: DataView,
  at_offset offset: Int,
  value value: Int,
  little_endian little_endian: Bool,
) -> Result(Nil, BufferError)

/// Writes a 16-bit IEEE 754 float at `offset`. Returns `OutOfRange`
/// if `offset` is out of bounds.
///
@external(javascript, "./data_view.ffi.mjs", "set_float16")
pub fn set_float16(
  view: DataView,
  at_offset offset: Int,
  value value: Float,
  little_endian little_endian: Bool,
) -> Result(Nil, BufferError)

/// Writes a 32-bit IEEE 754 float at `offset`. Returns `OutOfRange`
/// if `offset` is out of bounds.
///
@external(javascript, "./data_view.ffi.mjs", "set_float32")
pub fn set_float32(
  view: DataView,
  at_offset offset: Int,
  value value: Float,
  little_endian little_endian: Bool,
) -> Result(Nil, BufferError)

/// Writes a 64-bit IEEE 754 float at `offset`. Returns `OutOfRange`
/// if `offset` is out of bounds.
///
@external(javascript, "./data_view.ffi.mjs", "set_float64")
pub fn set_float64(
  view: DataView,
  at_offset offset: Int,
  value value: Float,
  little_endian little_endian: Bool,
) -> Result(Nil, BufferError)

/// Writes a signed 64-bit integer at `offset`. Returns `OutOfRange`
/// if `offset` is out of bounds.
///
@external(javascript, "./data_view.ffi.mjs", "set_bigint64")
pub fn set_bigint64(
  view: DataView,
  at_offset offset: Int,
  value value: BigInt,
  little_endian little_endian: Bool,
) -> Result(Nil, BufferError)

/// Writes an unsigned 64-bit integer at `offset`. Returns `OutOfRange`
/// if `offset` is out of bounds.
///
@external(javascript, "./data_view.ffi.mjs", "set_biguint64")
pub fn set_biguint64(
  view: DataView,
  at_offset offset: Int,
  value value: BigInt,
  little_endian little_endian: Bool,
) -> Result(Nil, BufferError)
