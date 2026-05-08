//// Parent module for the buffer family — `ArrayBuffer`, the typed array
//// views (`Uint8Array`, `Int32Array`, `Float64Array`, etc.), and
//// `DataView`. Hosts `BufferError`, the shared error type returned by
//// buffer-related operations across the family.
////
//// Mirrors the `gleam/http.Method` precedent: a parent module hosting
//// types used by submodules. Sibling submodules under
//// `gossamer/buffer/*` import `BufferError` from here for any operation
//// that can fail due to a detached buffer or out-of-range condition.

/// Errors raised by buffer or buffer-view operations.
pub type BufferError {
  /// The underlying buffer was detached (transferred, freed, or
  /// otherwise invalidated). All views over it become unusable.
  Detached

  /// The requested range falls outside the buffer's current byte length.
  OutOfRange(at: Int, length: Int)
}
