import gleam/javascript/promise.{type Promise}
import gossamer/buffer/array_buffer.{type ArrayBuffer}
import gossamer/fetch_error.{type FetchError}
import gossamer/stream/readable_stream.{type ReadableStream}

/// A file-like object of immutable, raw data. Can be read as text, bytes,
/// or a stream.
///
/// See [Blob](https://developer.mozilla.org/en-US/docs/Web/API/Blob) on MDN.
///
@external(javascript, "./blob.type.ts", "Blob$")
pub type Blob

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

@external(javascript, "./blob.ffi.mjs", "size")
pub fn size(blob: Blob) -> Int

@external(javascript, "./blob.ffi.mjs", "mime_type")
pub fn mime_type(blob: Blob) -> String

/// Reads the blob's contents as an `ArrayBuffer`. Returns
/// `UnableToReadBody` if the blob's source can't be read.
///
@external(javascript, "./blob.ffi.mjs", "array_buffer")
pub fn array_buffer(blob: Blob) -> Promise(Result(ArrayBuffer, FetchError))

/// Reads the blob's contents as a `BitArray`. Returns
/// `UnableToReadBody` if the blob's source can't be read.
///
@external(javascript, "./blob.ffi.mjs", "bytes")
pub fn bytes(blob: Blob) -> Promise(Result(BitArray, FetchError))

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

@external(javascript, "./blob.ffi.mjs", "stream")
pub fn stream(blob: Blob) -> ReadableStream(BitArray)

/// Reads the blob's contents as a UTF-8 string. Returns
/// `UnableToReadBody` if the blob's source can't be read.
///
@external(javascript, "./blob.ffi.mjs", "text")
pub fn text(blob: Blob) -> Promise(Result(String, FetchError))

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
