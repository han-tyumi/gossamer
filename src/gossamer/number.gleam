/// The maximum safe integer in JavaScript (2^53 - 1).
///
pub const max_safe_integer = 9_007_199_254_740_991

/// The minimum safe integer in JavaScript (-(2^53 - 1)).
///
pub const min_safe_integer = -9_007_199_254_740_991

/// The difference between 1 and the smallest floating-point number greater
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

/// Returns whether the value is NaN (not a number).
///
@external(javascript, "./number.ffi.mjs", "is_nan")
pub fn is_nan(value: Float) -> Bool

/// Returns whether the value is a finite number (not NaN or Infinity).
///
@external(javascript, "./number.ffi.mjs", "is_finite")
pub fn is_finite(value: Float) -> Bool

/// Returns whether the value is an integer (has no fractional part).
///
@external(javascript, "./number.ffi.mjs", "is_integer")
pub fn is_integer(value: Float) -> Bool

/// Returns whether the value is a safe integer — an integer that can be
/// exactly represented as an IEEE 754 double and has no other integer that
/// rounds to the same representation.
///
@external(javascript, "./number.ffi.mjs", "is_safe_integer")
pub fn is_safe_integer(value: Float) -> Bool

/// Formats a number using fixed-point notation with the specified number of
/// decimal places. Returns an error if the digits are out of range (0–100).
///
@external(javascript, "./number.ffi.mjs", "to_fixed")
pub fn to_fixed(value: Float, digits digits: Int) -> Result(String, String)

/// Formats a number to the specified number of significant digits. Returns
/// an error if the precision is out of range (1–100).
///
@external(javascript, "./number.ffi.mjs", "to_precision")
pub fn to_precision(value: Float, digits digits: Int) -> Result(String, String)

/// Formats a number in exponential (scientific) notation with the specified
/// number of digits after the decimal point. Returns an error if the digits
/// are out of range (0–100).
///
@external(javascript, "./number.ffi.mjs", "to_exponential")
pub fn to_exponential(
  value: Float,
  digits digits: Int,
) -> Result(String, String)

/// Converts an integer to a string in the specified radix (base 2–36).
/// Returns an error if the radix is out of range.
///
@external(javascript, "./number.ffi.mjs", "to_string_with_radix")
pub fn to_string_with_radix(
  value: Int,
  radix radix: Int,
) -> Result(String, String)

/// Returns a locale-sensitive string representation of the number.
///
@external(javascript, "./number.ffi.mjs", "to_locale_string")
pub fn to_locale_string(value: Float) -> String

/// Parses a string as an integer in the specified radix (base 2–36). Returns
/// an error if the string cannot be parsed.
///
@external(javascript, "./number.ffi.mjs", "parse_int")
pub fn parse_int(string: String, radix radix: Int) -> Result(Int, Nil)

/// Parses a string as a floating-point number. Returns an error if the
/// string cannot be parsed.
///
@external(javascript, "./number.ffi.mjs", "parse_float")
pub fn parse_float(string: String) -> Result(Float, Nil)
