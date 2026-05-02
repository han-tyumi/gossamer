import gossamer/js_error.{type JsError}
import gossamer/uint8_array.{type Uint8Array}

/// Fills `array` with cryptographically strong random values. Returns an
/// error if `array`'s byte length exceeds the implementation's quota
/// (typically 65,536 bytes).
///
@external(javascript, "./crypto.ffi.mjs", "get_random_values")
pub fn get_random_values(array: Uint8Array) -> Result(Uint8Array, JsError)

/// Generates a random UUID (version 4).
///
@external(javascript, "./crypto.ffi.mjs", "random_uuid")
pub fn random_uuid() -> String
