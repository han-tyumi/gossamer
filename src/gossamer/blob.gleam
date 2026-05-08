import gossamer/buffer/array_buffer.{type ArrayBuffer}
import gossamer/js_error.{type JsError}
import gossamer/promise.{type Promise}
import gossamer/readable_stream.{type ReadableStream}

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

@external(javascript, "./blob.ffi.mjs", "from_bytes")
pub fn from_bytes(bytes: BitArray) -> Blob

@external(javascript, "./blob.ffi.mjs", "from_bytes_with_type")
pub fn from_bytes_with_type(
  bytes: BitArray,
  content_type content_type: String,
) -> Blob

@external(javascript, "./blob.ffi.mjs", "from_string")
pub fn from_string(content: String) -> Blob

@external(javascript, "./blob.ffi.mjs", "from_string_with_type")
pub fn from_string_with_type(
  content: String,
  content_type content_type: String,
) -> Blob

@external(javascript, "./blob.ffi.mjs", "size")
pub fn size(blob: Blob) -> Int

@external(javascript, "./blob.ffi.mjs", "type_")
pub fn type_(blob: Blob) -> String

/// Reads the blob's contents as an `ArrayBuffer`. Returns an error if
/// the blob cannot be read.
///
@external(javascript, "./blob.ffi.mjs", "array_buffer")
pub fn array_buffer(blob: Blob) -> Promise(Result(ArrayBuffer, JsError))

/// Reads the blob's contents as a `BitArray`. Returns an error if the
/// blob cannot be read.
///
@external(javascript, "./blob.ffi.mjs", "bytes")
pub fn bytes(blob: Blob) -> Promise(Result(BitArray, JsError))

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
pub fn stream(blob: Blob) -> ReadableStream(BitArray)

/// Reads the blob's contents as a UTF-8 string. Returns an error if the
/// blob cannot be read.
///
@external(javascript, "./blob.ffi.mjs", "text")
pub fn text(blob: Blob) -> Promise(Result(String, JsError))

/// Creates a string containing a URL representing the blob. The URL
/// lifetime is tied to the document or worker that created it; release
/// it with `revoke_object_url`.
///
@external(javascript, "./blob.ffi.mjs", "to_object_url")
pub fn to_object_url(blob: Blob) -> String

/// Revokes an object URL previously created with `to_object_url`. Call
/// this to release the reference once the URL is no longer needed.
///
@external(javascript, "./blob.ffi.mjs", "revoke_object_url")
pub fn revoke_object_url(url: String) -> Nil
