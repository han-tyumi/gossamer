//// Extras for `gleam/float` — JavaScript Number representation
//// constants, mathematical constants and operations, and number
//// formatting that `gleam/float` doesn't cover.

/// The difference between `1.0` and the smallest representable
/// floating-point value greater than `1.0`.
///
pub const epsilon = 2.220446049250313e-16

/// The largest positive representable floating-point value.
///
pub const max_value = 1.7976931348623157e308

/// The smallest positive representable floating-point value.
///
pub const min_value = 5.0e-324

/// The ratio of a circle's circumference to its diameter.
///
pub const pi = 3.141592653589793

/// Euler's number, the base of the natural logarithm.
///
pub const e = 2.718281828459045

/// The natural logarithm of `2`.
///
pub const ln2 = 0.6931471805599453

/// The natural logarithm of `10`.
///
pub const ln10 = 2.302585092994046

/// The base-2 logarithm of `e`.
///
pub const log2e = 1.4426950408889634

/// The base-10 logarithm of `e`.
///
pub const log10e = 0.4342944819032518

/// The square root of `2`.
///
pub const sqrt2 = 1.4142135623730951

/// The square root of `1/2`.
///
pub const sqrt1_2 = 0.7071067811865476

/// Returns the cube root of a number.
///
@external(javascript, "./float_extra.ffi.mjs", "cbrt")
pub fn cbrt(value: Float) -> Float

/// Returns the square root of the sum of the squares of its values.
/// The two-dimensional case is the hypotenuse `sqrt(x*x + y*y)`; the
/// general case is the Euclidean norm of a vector. An empty list
/// returns `0.0`.
///
/// ## Examples
///
/// ```gleam
/// float_extra.hypot([3.0, 4.0])
/// // -> 5.0
/// ```
///
/// ```gleam
/// float_extra.hypot([1.0, 2.0, 2.0])
/// // -> 3.0
/// ```
///
@external(javascript, "./float_extra.ffi.mjs", "hypot")
pub fn hypot(values: List(Float)) -> Float

/// Returns the nearest 32-bit single-precision float representation of
/// a number.
///
@external(javascript, "./float_extra.ffi.mjs", "fround")
pub fn fround(value: Float) -> Float

/// Returns the sine of an angle in radians.
///
@external(javascript, "./float_extra.ffi.mjs", "sin")
pub fn sin(angle: Float) -> Float

/// Returns the cosine of an angle in radians.
///
@external(javascript, "./float_extra.ffi.mjs", "cos")
pub fn cos(angle: Float) -> Float

/// Returns the tangent of an angle in radians.
///
@external(javascript, "./float_extra.ffi.mjs", "tan")
pub fn tan(angle: Float) -> Float

/// Returns the arcsine of a number, in radians. Returns an error if
/// the value is outside the range `-1.0` to `1.0`.
///
@external(javascript, "./float_extra.ffi.mjs", "asin")
pub fn asin(value: Float) -> Result(Float, Nil)

/// Returns the arccosine of a number, in radians. Returns an error if
/// the value is outside the range `-1.0` to `1.0`.
///
@external(javascript, "./float_extra.ffi.mjs", "acos")
pub fn acos(value: Float) -> Result(Float, Nil)

/// Returns the arctangent of a number, in radians.
///
@external(javascript, "./float_extra.ffi.mjs", "atan")
pub fn atan(value: Float) -> Float

/// Returns the angle in radians between the positive x-axis and the
/// point `(x, y)`, with the result in the range `-pi` to `pi`.
///
@external(javascript, "./float_extra.ffi.mjs", "atan2")
pub fn atan2(y: Float, x: Float) -> Float

/// Returns the hyperbolic sine of a number.
///
@external(javascript, "./float_extra.ffi.mjs", "sinh")
pub fn sinh(value: Float) -> Float

/// Returns the hyperbolic cosine of a number.
///
@external(javascript, "./float_extra.ffi.mjs", "cosh")
pub fn cosh(value: Float) -> Float

/// Returns the hyperbolic tangent of a number.
///
@external(javascript, "./float_extra.ffi.mjs", "tanh")
pub fn tanh(value: Float) -> Float

/// Returns the inverse hyperbolic sine of a number.
///
@external(javascript, "./float_extra.ffi.mjs", "asinh")
pub fn asinh(value: Float) -> Float

/// Returns the inverse hyperbolic cosine of a number. Returns an error
/// if the value is less than `1.0`.
///
@external(javascript, "./float_extra.ffi.mjs", "acosh")
pub fn acosh(value: Float) -> Result(Float, Nil)

/// Returns the inverse hyperbolic tangent of a number. Returns an
/// error if the absolute value is greater than or equal to `1.0`.
///
@external(javascript, "./float_extra.ffi.mjs", "atanh")
pub fn atanh(value: Float) -> Result(Float, Nil)

/// Returns the base-2 logarithm of a number. Returns an error if the
/// value is not positive.
///
@external(javascript, "./float_extra.ffi.mjs", "log2")
pub fn log2(value: Float) -> Result(Float, Nil)

/// Returns the base-10 logarithm of a number. Returns an error if the
/// value is not positive.
///
@external(javascript, "./float_extra.ffi.mjs", "log10")
pub fn log10(value: Float) -> Result(Float, Nil)

/// Returns the natural logarithm of `1 + value`, precise for small
/// values. Returns an error if `value` is less than or equal to `-1.0`.
///
@external(javascript, "./float_extra.ffi.mjs", "log1p")
pub fn log1p(value: Float) -> Result(Float, Nil)

/// Returns `e` raised to the power of a number minus `1`, precise for
/// small values.
///
@external(javascript, "./float_extra.ffi.mjs", "expm1")
pub fn expm1(value: Float) -> Float

/// Formats a number using fixed-point notation with the specified
/// number of decimal places. Returns an error if `digits` is outside
/// `0`–`100`. Equivalent to JavaScript's `Number.prototype.toFixed`.
///
@external(javascript, "./float_extra.ffi.mjs", "to_fixed_string")
pub fn to_fixed_string(value: Float, digits digits: Int) -> Result(String, Nil)

/// Formats a number to the specified number of significant digits.
/// Returns an error if `digits` is outside `1`–`100`. Equivalent to
/// JavaScript's `Number.prototype.toPrecision`.
///
@external(javascript, "./float_extra.ffi.mjs", "to_precision_string")
pub fn to_precision_string(
  value: Float,
  digits digits: Int,
) -> Result(String, Nil)

/// Formats a number in exponential (scientific) notation with the
/// specified number of digits after the decimal point. Returns an
/// error if `digits` is outside `0`–`100`. Equivalent to JavaScript's
/// `Number.prototype.toExponential`.
///
@external(javascript, "./float_extra.ffi.mjs", "to_exponential_string")
pub fn to_exponential_string(
  value: Float,
  digits digits: Int,
) -> Result(String, Nil)

/// Returns a locale-sensitive string representation of the number,
/// applying the runtime's locale for thousands separators, decimal
/// marks, and digit shaping (e.g., `1234.5` becomes `"1,234.5"` in
/// `en-US` and `"1 234,5"` in `fr-FR`). For plain formatting, use
/// `gleam/float.to_string`.
///
@external(javascript, "./float_extra.ffi.mjs", "to_locale_string")
pub fn to_locale_string(value: Float) -> String
