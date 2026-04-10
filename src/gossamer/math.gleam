/// The ratio of a circle's circumference to its diameter.
///
pub const pi = 3.141592653589793

/// Euler's number, the base of natural logarithms.
///
pub const e = 2.718281828459045

/// The natural logarithm of 2.
///
pub const ln2 = 0.6931471805599453

/// The natural logarithm of 10.
///
pub const ln10 = 2.302585092994046

/// The base-2 logarithm of e.
///
pub const log2e = 1.4426950408889634

/// The base-10 logarithm of e.
///
pub const log10e = 0.4342944819032518

/// The square root of 2.
///
pub const sqrt2 = 1.4142135623730951

/// The square root of 1/2.
///
pub const sqrt1_2 = 0.7071067811865476

/// Returns a pseudo-random floating-point number between 0 (inclusive) and
/// 1 (exclusive).
///
@external(javascript, "./math.ffi.mjs", "random")
pub fn random() -> Float

/// Returns the sign of a number: -1.0, 0.0, or 1.0.
///
@external(javascript, "./math.ffi.mjs", "sign")
pub fn sign(value: Float) -> Float

/// Returns the integer part of a number by removing any fractional digits,
/// rounding toward zero.
///
@external(javascript, "./math.ffi.mjs", "trunc")
pub fn trunc(value: Float) -> Float

/// Returns the cube root of a number.
///
@external(javascript, "./math.ffi.mjs", "cbrt")
pub fn cbrt(value: Float) -> Float

/// Returns the square root of the sum of the squares of its arguments
/// (the hypotenuse).
///
@external(javascript, "./math.ffi.mjs", "hypot")
pub fn hypot(x: Float, y: Float) -> Float

/// Returns the natural logarithm (base e) of a number. Returns an error if
/// the value is not positive.
///
@external(javascript, "./math.ffi.mjs", "log")
pub fn log(value: Float) -> Result(Float, Nil)

/// Returns the base-2 logarithm of a number. Returns an error if the value
/// is not positive.
///
@external(javascript, "./math.ffi.mjs", "log2")
pub fn log2(value: Float) -> Result(Float, Nil)

/// Returns the base-10 logarithm of a number. Returns an error if the value
/// is not positive.
///
@external(javascript, "./math.ffi.mjs", "log10")
pub fn log10(value: Float) -> Result(Float, Nil)

/// Returns the natural logarithm of 1 + x, precise for small values of x.
/// Returns an error if x is less than or equal to -1.
///
@external(javascript, "./math.ffi.mjs", "log1p")
pub fn log1p(value: Float) -> Result(Float, Nil)

/// Returns the sine of an angle in radians.
///
@external(javascript, "./math.ffi.mjs", "sin")
pub fn sin(angle: Float) -> Float

/// Returns the cosine of an angle in radians.
///
@external(javascript, "./math.ffi.mjs", "cos")
pub fn cos(angle: Float) -> Float

/// Returns the tangent of an angle in radians.
///
@external(javascript, "./math.ffi.mjs", "tan")
pub fn tan(angle: Float) -> Float

/// Returns the arcsine of a number, in radians. Returns an error if the
/// value is outside the range -1 to 1.
///
@external(javascript, "./math.ffi.mjs", "asin")
pub fn asin(value: Float) -> Result(Float, Nil)

/// Returns the arccosine of a number, in radians. Returns an error if the
/// value is outside the range -1 to 1.
///
@external(javascript, "./math.ffi.mjs", "acos")
pub fn acos(value: Float) -> Result(Float, Nil)

/// Returns the arctangent of a number, in radians.
///
@external(javascript, "./math.ffi.mjs", "atan")
pub fn atan(value: Float) -> Float

/// Returns the angle in radians between the positive x-axis and the point
/// (x, y), with the result in the range -pi to pi.
///
@external(javascript, "./math.ffi.mjs", "atan2")
pub fn atan2(y: Float, x: Float) -> Float

/// Returns the hyperbolic sine of a number.
///
@external(javascript, "./math.ffi.mjs", "sinh")
pub fn sinh(value: Float) -> Float

/// Returns the hyperbolic cosine of a number.
///
@external(javascript, "./math.ffi.mjs", "cosh")
pub fn cosh(value: Float) -> Float

/// Returns the hyperbolic tangent of a number.
///
@external(javascript, "./math.ffi.mjs", "tanh")
pub fn tanh(value: Float) -> Float

/// Returns the inverse hyperbolic sine of a number.
///
@external(javascript, "./math.ffi.mjs", "asinh")
pub fn asinh(value: Float) -> Float

/// Returns the inverse hyperbolic cosine of a number. Returns an error if
/// the value is less than 1.
///
@external(javascript, "./math.ffi.mjs", "acosh")
pub fn acosh(value: Float) -> Result(Float, Nil)

/// Returns the inverse hyperbolic tangent of a number. Returns an error if
/// the absolute value is greater than or equal to 1.
///
@external(javascript, "./math.ffi.mjs", "atanh")
pub fn atanh(value: Float) -> Result(Float, Nil)

/// Returns e raised to the power of a number.
///
@external(javascript, "./math.ffi.mjs", "exp")
pub fn exp(value: Float) -> Float

/// Returns e raised to the power of a number minus 1, precise for small
/// values.
///
@external(javascript, "./math.ffi.mjs", "expm1")
pub fn expm1(value: Float) -> Float

/// Returns the number of leading zero bits in the 32-bit integer
/// representation of a number.
///
@external(javascript, "./math.ffi.mjs", "clz32")
pub fn clz32(value: Int) -> Int

/// Returns the nearest 32-bit single precision float representation of a
/// number.
///
@external(javascript, "./math.ffi.mjs", "fround")
pub fn fround(value: Float) -> Float

/// Returns the result of the C-like 32-bit integer multiplication of two
/// numbers.
///
@external(javascript, "./math.ffi.mjs", "imul")
pub fn imul(a: Int, b: Int) -> Int
