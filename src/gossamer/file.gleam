//// `Blob`s annotated with a filename and last-modified timestamp.
//// Typical use is form uploads — pair with
//// [`gleam/fetch/form_data.append_file`](https://hexdocs.pm/gleam_fetch/gleam/fetch/form_data.html#append_file).
//// Construct with [`from_strings`](#from_strings) for text content or
//// [`from_blob`](#from_blob) to wrap existing bytes.

import gleam/javascript/promise.{type Promise}
import gleam/time/timestamp.{type Timestamp}
import gossamer/array_buffer.{type ArrayBuffer}
import gossamer/blob.{type Blob}
import gossamer/stream/readable_stream.{type ReadableStream}

/// A `Blob` with a filename and last-modified timestamp.
///
/// See [File](https://developer.mozilla.org/en-US/docs/Web/API/File) on MDN.
///
pub type File {
  File(blob: Blob, name: String, mime_type: String, last_modified: Timestamp)
}

/// Creates a `File` whose contents are the concatenation of `parts`.
/// `last_modified` is set to the current time.
///
@external(javascript, "./file.ffi.mjs", "from_strings")
pub fn from_strings(parts: List(String), named name: String) -> File

/// Creates a `File` wrapping `blob`. The file's `mime_type` is taken
/// from `blob.mime_type`; `last_modified` is set to the current time.
///
@external(javascript, "./file.ffi.mjs", "from_blob")
pub fn from_blob(blob: Blob, named name: String) -> File

/// Sets the underlying `Blob`. The file's existing `mime_type` is kept;
/// pass through [`set_mime_type`](#set_mime_type) to adopt the blob's
/// type instead.
///
pub fn set_blob(file: File, value: Blob) -> File {
  File(..file, blob: value)
}

/// Sets the filename used by `gleam/fetch/form_data.append_file`'s
/// multipart `Content-Disposition` header.
///
pub fn set_name(file: File, value: String) -> File {
  File(..file, name: value)
}

/// Sets the MIME type.
///
pub fn set_mime_type(file: File, value: String) -> File {
  File(..file, mime_type: value)
}

/// Sets the last-modified timestamp.
///
pub fn set_last_modified(file: File, value: Timestamp) -> File {
  File(..file, last_modified: value)
}

/// The size of the file's contents in bytes.
///
pub fn size(file: File) -> Int {
  blob.size(file.blob)
}

/// Reads the file's contents as an `ArrayBuffer`. Returns an error if
/// the file's source can't be read.
///
pub fn array_buffer(file: File) -> Promise(Result(ArrayBuffer, Nil)) {
  blob.array_buffer(file.blob)
}

/// Reads the file's contents as a `BitArray`. Returns an error if the
/// file's source can't be read.
///
pub fn bytes(file: File) -> Promise(Result(BitArray, Nil)) {
  blob.bytes(file.blob)
}

/// Returns a `Blob` containing the bytes between `start` (inclusive)
/// and `end` (exclusive). Negative offsets count from the end. Pass `""`
/// for `content_type` to leave the MIME type unset (the file's type is
/// never inherited).
///
pub fn slice(
  file: File,
  from start: Int,
  to end: Int,
  content_type content_type: String,
) -> Blob {
  blob.slice(file.blob, from: start, to: end, content_type:)
}

/// Returns a `ReadableStream` that produces the file's bytes.
///
pub fn stream(file: File) -> ReadableStream(BitArray) {
  blob.stream(file.blob)
}

/// Reads the file's contents as a UTF-8 string. Returns an error if
/// the file's source can't be read.
///
pub fn text(file: File) -> Promise(Result(String, Nil)) {
  blob.text(file.blob)
}
