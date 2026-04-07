import gossamer/array_buffer.{type ArrayBuffer}
import gossamer/promise.{type Promise}
import gossamer/readable_stream.{type ReadableStream}
import gossamer/uint8_array.{type Uint8Array}

/// A file-like object of immutable, raw data. Blobs represent data that
/// isn't necessarily in a JavaScript-native format. The File interface is
/// based on Blob, inheriting blob functionality and expanding it to
/// support files on the user's system.
///
@external(javascript, "./blob.ffi.ts", "Blob$")
pub type Blob

/// Creates a new `Blob` with no content.
///
@external(javascript, "./blob.ffi.mjs", "new_")
pub fn new() -> Blob

/// Creates a new `Blob` from a string.
///
@external(javascript, "./blob.ffi.mjs", "from_string")
pub fn from_string(content: String) -> Blob

/// Creates a new `Blob` from a string with a MIME type.
///
@external(javascript, "./blob.ffi.mjs", "from_string_with_type")
pub fn from_string_with_type(content: String, mime_type: String) -> Blob

/// Creates a new `Blob` from a `Uint8Array`.
///
@external(javascript, "./blob.ffi.mjs", "from_bytes")
pub fn from_bytes(bytes: Uint8Array) -> Blob

/// Creates a new `Blob` from a `Uint8Array` with a MIME type.
///
@external(javascript, "./blob.ffi.mjs", "from_bytes_with_type")
pub fn from_bytes_with_type(bytes: Uint8Array, mime_type: String) -> Blob

@external(javascript, "./blob.ffi.mjs", "size")
pub fn size(blob: Blob) -> Int

@external(javascript, "./blob.ffi.mjs", "type_")
pub fn type_(blob: Blob) -> String

@external(javascript, "./blob.ffi.mjs", "array_buffer")
pub fn array_buffer(blob: Blob) -> Promise(ArrayBuffer)

@external(javascript, "./blob.ffi.mjs", "bytes")
pub fn bytes(blob: Blob) -> Promise(Uint8Array)

@external(javascript, "./blob.ffi.mjs", "slice")
pub fn slice(blob: Blob, start: Int, end: Int) -> Blob

@external(javascript, "./blob.ffi.mjs", "slice_with_type")
pub fn slice_with_type(
  blob: Blob,
  start: Int,
  end: Int,
  content_type: String,
) -> Blob

@external(javascript, "./blob.ffi.mjs", "stream")
pub fn stream(blob: Blob) -> ReadableStream(Uint8Array)

@external(javascript, "./blob.ffi.mjs", "text")
pub fn text(blob: Blob) -> Promise(String)
