//// Arbitrary-precision integer arithmetic for values outside Gleam
//// `Int`'s safe-integer range. Construct via [`from_int`](#from_int)
//// for safe-range starting values or [`from_string`](#from_string)
//// when parsing larger literals from text.

import gleam/order.{type Order}

/// A JavaScript `BigInt` — an arbitrary-precision integer. Use when
/// working with values outside the safe-integer range of Gleam `Int`
/// (±2^53−1).
///
/// See [BigInt](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/BigInt) on MDN.
///
@external(javascript, "./big_int.type.ts", "BigInt$")
pub type BigInt

/// Errors raised by `BigInt` bindings.
///
pub type BigIntError {
  /// The input string could not be parsed as an integer.
  InvalidInteger

  /// The divisor was zero.
  DivisionByZero
}

/// Creates a `BigInt` from a Gleam `Int`. Pair with
/// [`from_string`](#from_string) when the source is a string literal
/// outside the safe-integer range.
///
@external(javascript, "./big_int.ffi.mjs", "from_int")
pub fn from_int(value: Int) -> BigInt

/// Parses an integer string. Accepts decimal (`"42"`), hex
/// (`"0x2a"`), octal (`"0o52"`), and binary (`"0b101010"`) literals
/// with an optional sign and surrounding whitespace. Returns
/// `Error(InvalidInteger)` on malformed input — decimal floats like
/// `"1.5"`, scientific notation like `"1e3"`, and the trailing-`n`
/// literal suffix like `"42n"` are all rejected. The empty string
/// parses as `0`.
///
@external(javascript, "./big_int.ffi.mjs", "from_string")
pub fn from_string(string: String) -> Result(BigInt, BigIntError)

/// Converts a `BigInt` to a Gleam `Int`. Returns an error if the
/// value is outside the safe-integer range (±2^53−1) and would lose
/// precision when narrowed.
///
@external(javascript, "./big_int.ffi.mjs", "to_int")
pub fn to_int(value: BigInt) -> Result(Int, Nil)

/// Returns the decimal string representation of `value`.
///
@external(javascript, "./big_int.ffi.mjs", "to_string")
pub fn to_string(value: BigInt) -> String

/// Returns the sum of `a` and `b`.
///
@external(javascript, "./big_int.ffi.mjs", "add")
pub fn add(a: BigInt, b: BigInt) -> BigInt

/// Returns the difference of `a` and `b`.
///
@external(javascript, "./big_int.ffi.mjs", "subtract")
pub fn subtract(a: BigInt, b: BigInt) -> BigInt

/// Returns the product of `a` and `b`.
///
@external(javascript, "./big_int.ffi.mjs", "multiply")
pub fn multiply(a: BigInt, b: BigInt) -> BigInt

/// Truncating integer division. Returns `Error(DivisionByZero)` if
/// `divisor` is `0`.
///
@external(javascript, "./big_int.ffi.mjs", "divide")
pub fn divide(a: BigInt, by divisor: BigInt) -> Result(BigInt, BigIntError)

/// Returns the remainder of `a / divisor`. Returns
/// `Error(DivisionByZero)` if `divisor` is `0`.
///
@external(javascript, "./big_int.ffi.mjs", "remainder")
pub fn remainder(a: BigInt, by divisor: BigInt) -> Result(BigInt, BigIntError)

/// Returns the additive inverse of `value` (i.e., `-value`).
///
@external(javascript, "./big_int.ffi.mjs", "negate")
pub fn negate(value: BigInt) -> BigInt

/// Returns the absolute value of `value`.
///
@external(javascript, "./big_int.ffi.mjs", "absolute_value")
pub fn absolute_value(value: BigInt) -> BigInt

/// Compares `a` and `b`, returning their relative ordering as a
/// [`gleam/order.Order`](https://hexdocs.pm/gleam_stdlib/gleam/order.html#Order).
///
@external(javascript, "./big_int.ffi.mjs", "compare")
pub fn compare(a: BigInt, b: BigInt) -> Order
