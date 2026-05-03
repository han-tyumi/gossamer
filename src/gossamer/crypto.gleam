import gossamer/int_typed_array.{type IntTypedArray}
import gossamer/js_error.{type JsError}

/// Fills `array` with cryptographically strong random values. Returns an
/// error if `array`'s byte length exceeds the implementation's quota
/// (typically `65_536` bytes).
///
@external(javascript, "./crypto.ffi.mjs", "get_random_values")
pub fn get_random_values(array: IntTypedArray) -> Result(IntTypedArray, JsError)

/// Generates a random UUID (version 4).
///
@external(javascript, "./crypto.ffi.mjs", "random_uuid")
pub fn random_uuid() -> String
