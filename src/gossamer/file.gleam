import gleam/fetch.{type FetchError}
import gleam/javascript/promise.{type Promise}
import gossamer/blob.{type Blob}
import gossamer/buffer/array_buffer.{type ArrayBuffer}
import gossamer/stream/readable_stream.{type ReadableStream}

/// A `Blob` with a filename and last-modified timestamp.
///
/// See [File](https://developer.mozilla.org/en-US/docs/Web/API/File) on MDN.
///
pub type File {
  File(blob: Blob, name: String, type_: String, last_modified: Int)
}

/// Creates a `File` whose contents are the concatenation of `parts`.
/// `last_modified` is set to the current time.
///
@external(javascript, "./file.ffi.mjs", "from_strings")
pub fn from_strings(parts: List(String), named name: String) -> File

/// Creates a `File` wrapping `blob`. The file's `type_` is taken from
/// `blob.type_`; `last_modified` is set to the current time.
///
@external(javascript, "./file.ffi.mjs", "from_blob")
pub fn from_blob(blob: Blob, named name: String) -> File

/// Sets the MIME type. Returns a new `File` with the given type.
///
pub fn set_type(file: File, value: String) -> File {
  File(..file, type_: value)
}

/// Sets the last-modified timestamp in milliseconds since the Unix
/// epoch. Returns a new `File` with the given timestamp.
///
pub fn set_last_modified(file: File, value: Int) -> File {
  File(..file, last_modified: value)
}

/// The size of the file's contents in bytes.
///
pub fn size(file: File) -> Int {
  blob.size(file.blob)
}

/// Reads the file's contents as an `ArrayBuffer`. Returns
/// `UnableToReadBody` if the file's source can't be read.
///
pub fn array_buffer(file: File) -> Promise(Result(ArrayBuffer, FetchError)) {
  blob.array_buffer(file.blob)
}

/// Reads the file's contents as a `BitArray`. Returns
/// `UnableToReadBody` if the file's source can't be read.
///
pub fn bytes(file: File) -> Promise(Result(BitArray, FetchError)) {
  blob.bytes(file.blob)
}

/// Returns a `Blob` containing the bytes between `start` (inclusive)
/// and `end` (exclusive). Negative offsets count from the end.
///
pub fn slice(file: File, from start: Int, to end: Int) -> Blob {
  blob.slice(file.blob, from: start, to: end)
}

/// Like `slice`, but the returned `Blob` carries the given MIME type.
///
pub fn slice_with_type(
  file: File,
  from start: Int,
  to end: Int,
  content_type content_type: String,
) -> Blob {
  blob.slice_with_type(file.blob, from: start, to: end, content_type:)
}

/// Returns a `ReadableStream` that produces the file's bytes.
///
pub fn stream(file: File) -> ReadableStream(BitArray) {
  blob.stream(file.blob)
}

/// Reads the file's contents as a UTF-8 string. Returns
/// `UnableToReadBody` if the file's source can't be read.
///
pub fn text(file: File) -> Promise(Result(String, FetchError)) {
  blob.text(file.blob)
}
