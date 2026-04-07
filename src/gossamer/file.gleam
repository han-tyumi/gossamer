import gossamer/array_buffer.{type ArrayBuffer}
import gossamer/blob.{type Blob}
import gossamer/file_option.{type FileOption}
import gossamer/promise.{type Promise}
import gossamer/readable_stream.{type ReadableStream}
import gossamer/uint8_array.{type Uint8Array}

@external(javascript, "./file.type.ts", "File$")
pub type File

@external(javascript, "./file.ffi.mjs", "from_strings")
pub fn from_strings(parts: List(String), name: String) -> File

@external(javascript, "./file.ffi.mjs", "from_strings_with")
pub fn from_strings_with(
  parts: List(String),
  name: String,
  options: List(FileOption),
) -> File

@external(javascript, "./file.ffi.mjs", "from_blob")
pub fn from_blob(blob: Blob, name: String) -> File

@external(javascript, "./file.ffi.mjs", "from_blob_with")
pub fn from_blob_with(
  blob: Blob,
  name: String,
  options: List(FileOption),
) -> File

@external(javascript, "./file.ffi.mjs", "name")
pub fn name(file: File) -> String

@external(javascript, "./file.ffi.mjs", "last_modified")
pub fn last_modified(file: File) -> Int

@external(javascript, "./file.ffi.mjs", "to_blob")
pub fn to_blob(file: File) -> Blob

@external(javascript, "./file.ffi.mjs", "size")
pub fn size(file: File) -> Int

@external(javascript, "./file.ffi.mjs", "type_")
pub fn type_(file: File) -> String

@external(javascript, "./file.ffi.mjs", "array_buffer")
pub fn array_buffer(file: File) -> Promise(Result(ArrayBuffer, String))

@external(javascript, "./file.ffi.mjs", "bytes")
pub fn bytes(file: File) -> Promise(Result(Uint8Array, String))

@external(javascript, "./file.ffi.mjs", "slice")
pub fn slice(file: File, start: Int, end: Int) -> Blob

@external(javascript, "./file.ffi.mjs", "slice_with_type")
pub fn slice_with_type(
  file: File,
  start: Int,
  end: Int,
  content_type: String,
) -> Blob

@external(javascript, "./file.ffi.mjs", "stream")
pub fn stream(file: File) -> ReadableStream(Uint8Array)

@external(javascript, "./file.ffi.mjs", "text")
pub fn text(file: File) -> Promise(Result(String, String))
