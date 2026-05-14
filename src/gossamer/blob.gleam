//// Immutable binary containers with an associated MIME type — used to
//// assemble payloads for upload, slice large data, or stream bytes
//// through transforms. Construct with [`from_bytes`](#from_bytes) or
//// [`from_string`](#from_string).

import gleam/javascript/promise.{type Promise}
import gossamer/array_buffer.{type ArrayBuffer}
import gossamer/stream/readable_stream.{type ReadableStream}

/// A file-like object of immutable, raw data. Can be read as text, bytes,
/// or a stream.
///
/// See [Blob](https://developer.mozilla.org/en-US/docs/Web/API/Blob) on MDN.
///
@external(javascript, "./blob.type.ts", "Blob$")
pub type Blob

/// Creates an empty `Blob` with no MIME type. Use
/// [`from_bytes`](#from_bytes) or [`from_string`](#from_string) to
/// construct one with contents.
///
@external(javascript, "./blob.ffi.mjs", "new_")
pub fn new() -> Blob

/// Creates a `Blob` wrapping the given bytes. Pass `""` for
/// `content_type` to leave the MIME type unset.
///
@external(javascript, "./blob.ffi.mjs", "from_bytes")
pub fn from_bytes(bytes: BitArray, content_type content_type: String) -> Blob

/// Creates a `Blob` wrapping the given string. Pass `""` for
/// `content_type` to leave the MIME type unset.
///
@external(javascript, "./blob.ffi.mjs", "from_string")
pub fn from_string(content: String, content_type content_type: String) -> Blob

/// The size of the blob's contents in bytes.
///
@external(javascript, "./blob.ffi.mjs", "size")
pub fn size(blob: Blob) -> Int

/// The MIME type associated with the blob, or `""` if no type was set
/// at construction. Equivalent to JavaScript's `Blob.type`.
///
@external(javascript, "./blob.ffi.mjs", "mime_type")
pub fn mime_type(blob: Blob) -> String

/// Reads the blob's contents as an `ArrayBuffer`. Returns an error if
/// the blob's source can't be read.
///
@external(javascript, "./blob.ffi.mjs", "array_buffer")
pub fn array_buffer(blob: Blob) -> Promise(Result(ArrayBuffer, Nil))

/// Reads the blob's contents as a `BitArray`. Returns an error if the
/// blob's source can't be read.
///
@external(javascript, "./blob.ffi.mjs", "bytes")
pub fn bytes(blob: Blob) -> Promise(Result(BitArray, Nil))

/// Returns a `Blob` containing the bytes between `start` (inclusive)
/// and `end` (exclusive). Negative offsets count from the end. Pass `""`
/// for `content_type` to leave the MIME type unset (the source blob's
/// type is never inherited).
///
@external(javascript, "./blob.ffi.mjs", "slice")
pub fn slice(
  blob: Blob,
  from start: Int,
  to end: Int,
  content_type content_type: String,
) -> Blob

/// Returns a `ReadableStream` that produces the blob's bytes in
/// chunks. Suitable for piping into a compression or upload stream.
///
@external(javascript, "./blob.ffi.mjs", "stream")
pub fn stream(blob: Blob) -> ReadableStream(BitArray)

/// Reads the blob's contents as a UTF-8 string. Returns an error if the
/// blob's source can't be read.
///
@external(javascript, "./blob.ffi.mjs", "text")
pub fn text(blob: Blob) -> Promise(Result(String, Nil))

/// Creates a string containing a URL representing the blob. The URL
/// lifetime is tied to the document or worker that created it; release
/// it with [`revoke_object_url`](#revoke_object_url). Equivalent to
/// JavaScript's `URL.createObjectURL`.
///
@external(javascript, "./blob.ffi.mjs", "to_object_url")
pub fn to_object_url(blob: Blob) -> String

/// Revokes an object URL previously created with
/// [`to_object_url`](#to_object_url). Call this to release the
/// reference once the URL is no longer needed. Equivalent to
/// JavaScript's `URL.revokeObjectURL`.
///
@external(javascript, "./blob.ffi.mjs", "revoke_object_url")
pub fn revoke_object_url(url: String) -> Nil
