import gossamer/array_buffer.{type ArrayBuffer}
import gossamer/data_view.{type DataView}
import gossamer/js_error.{type JsError}
import gossamer/promise.{type Promise}
import gossamer/readable_stream.{type ReadableStream}
import gossamer/typed_array.{type TypedArray}
import gossamer/uint8_array.{type Uint8Array}

/// A file-like object of immutable, raw data. Can be read as text, bytes,
/// or a stream.
///
/// See [Blob](https://developer.mozilla.org/en-US/docs/Web/API/Blob) on MDN.
///
@external(javascript, "./blob.type.ts", "Blob$")
pub type Blob

pub type Fields {
  Fields(size: Int, type_: String)
}

@external(javascript, "./blob.ffi.mjs", "to_fields")
pub fn to_fields(blob: Blob) -> Fields

@external(javascript, "./blob.ffi.mjs", "new_")
pub fn new() -> Blob

@external(javascript, "./blob.ffi.mjs", "from_string")
pub fn from_string(content: String) -> Blob

@external(javascript, "./blob.ffi.mjs", "from_string_with_type")
pub fn from_string_with_type(
  content: String,
  content_type content_type: String,
) -> Blob

@external(javascript, "./blob.ffi.mjs", "from_buffer")
pub fn from_buffer(bytes: ArrayBuffer) -> Blob

@external(javascript, "./blob.ffi.mjs", "from_buffer_with_type")
pub fn from_buffer_with_type(
  bytes: ArrayBuffer,
  content_type content_type: String,
) -> Blob

@external(javascript, "./blob.ffi.mjs", "from_typed_array")
pub fn from_typed_array(bytes: TypedArray) -> Blob

@external(javascript, "./blob.ffi.mjs", "from_typed_array_with_type")
pub fn from_typed_array_with_type(
  bytes: TypedArray,
  content_type content_type: String,
) -> Blob

@external(javascript, "./blob.ffi.mjs", "from_data_view")
pub fn from_data_view(bytes: DataView) -> Blob

@external(javascript, "./blob.ffi.mjs", "from_data_view_with_type")
pub fn from_data_view_with_type(
  bytes: DataView,
  content_type content_type: String,
) -> Blob

@external(javascript, "./blob.ffi.mjs", "size")
pub fn size(of blob: Blob) -> Int

@external(javascript, "./blob.ffi.mjs", "type_")
pub fn type_(of blob: Blob) -> String

/// Reads the blob's contents as an `ArrayBuffer`. Returns an error if
/// the blob cannot be read.
///
@external(javascript, "./blob.ffi.mjs", "array_buffer")
pub fn array_buffer(of blob: Blob) -> Promise(Result(ArrayBuffer, JsError))

/// Reads the blob's contents as a `Uint8Array`. Returns an error if the
/// blob cannot be read.
///
@external(javascript, "./blob.ffi.mjs", "bytes")
pub fn bytes(of blob: Blob) -> Promise(Result(Uint8Array, JsError))

@external(javascript, "./blob.ffi.mjs", "slice")
pub fn slice(blob: Blob, from start: Int, to end: Int) -> Blob

@external(javascript, "./blob.ffi.mjs", "slice_with_type")
pub fn slice_with_type(
  blob: Blob,
  from start: Int,
  to end: Int,
  content_type content_type: String,
) -> Blob

@external(javascript, "./blob.ffi.mjs", "stream")
pub fn stream(of blob: Blob) -> ReadableStream(Uint8Array)

/// Reads the blob's contents as a UTF-8 string. Returns an error if the
/// blob cannot be read.
///
@external(javascript, "./blob.ffi.mjs", "text")
pub fn text(of blob: Blob) -> Promise(Result(String, JsError))
