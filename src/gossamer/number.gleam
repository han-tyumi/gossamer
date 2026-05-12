//// JavaScript `Number` constants and formatting not covered by
//// `gleam/int` or `gleam/float`. For parsing and base conversion, use
//// `gleam/int.parse`, `gleam/int.base_parse`, `gleam/int.to_base_string`,
//// and `gleam/float.parse`.

/// Errors raised by numeric formatting bindings.
pub type NumberError {
  /// The supplied integer argument is outside the valid range for the
  /// binding's parameter. The payload carries the offending value.
  OutOfRange(value: Int)
}

/// The maximum safe integer in JavaScript (2^53 - 1).
///
pub const max_safe_integer = 9_007_199_254_740_991

/// The minimum safe integer in JavaScript (-(2^53 - 1)).
///
pub const min_safe_integer = -9_007_199_254_740_991

/// The difference between `1` and the smallest floating-point number greater
/// than 1.
///
@external(javascript, "./number.ffi.mjs", "epsilon")
pub fn epsilon() -> Float

/// The largest positive representable floating-point number.
///
@external(javascript, "./number.ffi.mjs", "max_value")
pub fn max_value() -> Float

/// The smallest positive representable floating-point number.
///
@external(javascript, "./number.ffi.mjs", "min_value")
pub fn min_value() -> Float

/// Formats a number using fixed-point notation with the specified
/// number of decimal places. Returns `OutOfRange` if `digits` is
/// outside `0`–`100`.
///
@external(javascript, "./number.ffi.mjs", "to_fixed_string")
pub fn to_fixed_string(
  value: Float,
  digits digits: Int,
) -> Result(String, NumberError)

/// Formats a number to the specified number of significant digits.
/// Returns `OutOfRange` if `digits` is outside `1`–`100`.
///
@external(javascript, "./number.ffi.mjs", "to_precision_string")
pub fn to_precision_string(
  value: Float,
  digits digits: Int,
) -> Result(String, NumberError)

/// Formats a number in exponential (scientific) notation with the
/// specified number of digits after the decimal point. Returns
/// `OutOfRange` if `digits` is outside `0`–`100`.
///
@external(javascript, "./number.ffi.mjs", "to_exponential_string")
pub fn to_exponential_string(
  value: Float,
  digits digits: Int,
) -> Result(String, NumberError)

/// Returns a locale-sensitive string representation of the number,
/// applying the runtime's locale for thousands separators, decimal
/// marks, and digit shaping (e.g., `1234.5` becomes `"1,234.5"` in
/// `en-US` and `"1 234,5"` in `fr-FR`). For plain formatting, use
/// `gleam/float.to_string` or `gleam/int.to_string`.
///
@external(javascript, "./number.ffi.mjs", "to_locale_string")
pub fn to_locale_string(value: Float) -> String
