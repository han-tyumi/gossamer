import gossamer/array_buffer.{type ArrayBuffer}
import gossamer/blob.{type Blob}
import gossamer/js_error.{type JsError}
import gossamer/promise.{type Promise}
import gossamer/readable_stream.{type ReadableStream}
import gossamer/uint8_array.{type Uint8Array}

@external(javascript, "./file_ref.type.ts", "FileRef$")
@internal
pub type FileRef

/// A `Blob` with a filename and last-modified timestamp. Commonly obtained
/// from file inputs or drag-and-drop.
///
/// See [File](https://developer.mozilla.org/en-US/docs/Web/API/File) on MDN.
///
pub type File {
  File(
    name: String,
    last_modified: Int,
    size: Int,
    type_: String,
    /// Internal handle to the underlying JS `File`.
    ref: FileRef,
  )
}

pub type FileOption {
  Type(String)
  LastModified(Int)
}

@external(javascript, "./file.ffi.mjs", "from_strings")
pub fn from_strings(parts: List(String), named name: String) -> File

@external(javascript, "./file.ffi.mjs", "from_strings_with")
pub fn from_strings_with(
  parts: List(String),
  named name: String,
  with options: List(FileOption),
) -> File

@external(javascript, "./file.ffi.mjs", "from_blob")
pub fn from_blob(blob: Blob, named name: String) -> File

@external(javascript, "./file.ffi.mjs", "from_blob_with")
pub fn from_blob_with(
  blob: Blob,
  named name: String,
  with options: List(FileOption),
) -> File

@external(javascript, "./file.ffi.mjs", "to_blob")
pub fn to_blob(file: File) -> Blob

/// Reads the file's contents as an `ArrayBuffer`. Returns an error if
/// the file cannot be read.
///
@external(javascript, "./file.ffi.mjs", "array_buffer")
pub fn array_buffer(of file: File) -> Promise(Result(ArrayBuffer, JsError))

/// Reads the file's contents as a `Uint8Array`. Returns an error if the
/// file cannot be read.
///
@external(javascript, "./file.ffi.mjs", "bytes")
pub fn bytes(of file: File) -> Promise(Result(Uint8Array, JsError))

@external(javascript, "./file.ffi.mjs", "slice")
pub fn slice(file: File, from start: Int, to end: Int) -> Blob

@external(javascript, "./file.ffi.mjs", "slice_with_type")
pub fn slice_with_type(
  file: File,
  from start: Int,
  to end: Int,
  content_type content_type: String,
) -> Blob

@external(javascript, "./file.ffi.mjs", "stream")
pub fn stream(of file: File) -> ReadableStream(Uint8Array)

/// Reads the file's contents as a UTF-8 string. Returns an error if the
/// file cannot be read.
///
@external(javascript, "./file.ffi.mjs", "text")
pub fn text(of file: File) -> Promise(Result(String, JsError))
