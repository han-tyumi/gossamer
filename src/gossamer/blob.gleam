import gossamer/array_buffer.{type ArrayBuffer}
import gossamer/promise.{type Promise}
import gossamer/readable_stream.{type ReadableStream}
import gossamer/uint8_array.{type Uint8Array}

@external(javascript, "./blob.type.ts", "Blob$")
pub type Blob

@external(javascript, "./blob.ffi.mjs", "new_")
pub fn new() -> Blob

@external(javascript, "./blob.ffi.mjs", "from_string")
pub fn from_string(content: String) -> Blob

@external(javascript, "./blob.ffi.mjs", "from_string_with_type")
pub fn from_string_with_type(content: String, mime_type: String) -> Blob

@external(javascript, "./blob.ffi.mjs", "from_bytes")
pub fn from_bytes(bytes: Uint8Array) -> Blob

@external(javascript, "./blob.ffi.mjs", "from_bytes_with_type")
pub fn from_bytes_with_type(bytes: Uint8Array, mime_type: String) -> Blob

@external(javascript, "./blob.ffi.mjs", "size")
pub fn size(blob: Blob) -> Int

@external(javascript, "./blob.ffi.mjs", "type_")
pub fn type_(blob: Blob) -> String

@external(javascript, "./blob.ffi.mjs", "array_buffer")
pub fn array_buffer(blob: Blob) -> Promise(Result(ArrayBuffer, String))

@external(javascript, "./blob.ffi.mjs", "bytes")
pub fn bytes(blob: Blob) -> Promise(Result(Uint8Array, String))

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
pub fn text(blob: Blob) -> Promise(Result(String, String))
