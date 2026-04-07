import gossamer/uint8_array.{type Uint8Array}

/// Mutates the provided typed array with cryptographically secure random
/// values.
///
/// Returns the same typed array, now populated with random values.
///
@external(javascript, "./crypto.ffi.mjs", "get_random_values")
pub fn get_random_values(array: Uint8Array) -> Uint8Array

/// Generates a random RFC 4122 version 4 UUID using a cryptographically
/// secure random number generator.
///
/// Returns a randomly generated, 36-character long v4 UUID.
///
@external(javascript, "./crypto.ffi.mjs", "random_uuid")
pub fn random_uuid() -> String
