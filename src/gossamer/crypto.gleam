/// Generates `length` cryptographically strong random bytes. A
/// non-positive `length` returns an empty `BitArray`.
///
@external(javascript, "./crypto.ffi.mjs", "random_bytes")
pub fn random_bytes(length: Int) -> BitArray

/// Generates a random UUID (version 4).
///
@external(javascript, "./crypto.ffi.mjs", "random_uuid")
pub fn random_uuid() -> String
