//// Arbitrary-precision integer arithmetic for values outside Gleam
//// `Int`'s safe-integer range. Construct via [`from_int`](#from_int)
//// for safe-range starting values or [`parse`](#parse) when reading
//// larger literals from text. Mirrors `gleam/int` where the operation
//// carries over.

import gleam/list
import gleam/order.{type Order}

/// A JavaScript `BigInt` — an arbitrary-precision integer. Use when
/// working with values outside the safe-integer range of Gleam `Int`
/// (±2^53−1).
///
/// See [BigInt](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/BigInt) on MDN.
///
@external(javascript, "./big_int.type.ts", "BigInt$")
pub type BigInt

/// Creates a `BigInt` from a Gleam `Int`. Pair with [`parse`](#parse)
/// when the source is a string literal outside the safe-integer range.
///
@external(javascript, "./big_int.ffi.mjs", "from_int")
pub fn from_int(value: Int) -> BigInt

/// Parses an integer string. Accepts decimal (`"42"`), hex (`"0x2a"`),
/// octal (`"0o52"`), and binary (`"0b101010"`) literals with an
/// optional sign and surrounding whitespace. Returns `Error(Nil)` on
/// malformed input — decimal floats like `"1.5"`, scientific notation
/// like `"1e3"`, and the trailing-`n` literal suffix like `"42n"` are
/// all rejected. The empty string parses as `0`.
///
@external(javascript, "./big_int.ffi.mjs", "parse")
pub fn parse(string: String) -> Result(BigInt, Nil)

/// Parses an integer string in the given `base` (`2`–`36`), with an
/// optional sign. Digits above `9` use letters, case-insensitively.
/// Returns `Error(Nil)` if `base` is outside that range or the string
/// isn't a valid integer in that base.
///
@external(javascript, "./big_int.ffi.mjs", "base_parse")
pub fn base_parse(string: String, base: Int) -> Result(BigInt, Nil)

/// Converts a `BigInt` to a Gleam `Int`. Returns `Error(Nil)` if the
/// value is outside the safe-integer range (±2^53−1) and would lose
/// precision when narrowed.
///
@external(javascript, "./big_int.ffi.mjs", "to_int")
pub fn to_int(x: BigInt) -> Result(Int, Nil)

/// Converts a `BigInt` to a `Float`. Values beyond `2^53` lose
/// precision; values too large for a `Float` return `Error(Nil)` rather
/// than a non-finite result.
///
@external(javascript, "./big_int.ffi.mjs", "to_float")
pub fn to_float(x: BigInt) -> Result(Float, Nil)

/// Returns the decimal string representation of `x`.
///
@external(javascript, "./big_int.ffi.mjs", "to_string")
pub fn to_string(x: BigInt) -> String

/// Returns the string representation of `x` in the given `base`
/// (`2`–`36`), with digits above `9` as uppercase letters. Returns
/// `Error(Nil)` if `base` is outside that range.
///
@external(javascript, "./big_int.ffi.mjs", "to_base_string")
pub fn to_base_string(x: BigInt, base: Int) -> Result(String, Nil)

/// Returns the base-2 (binary) string representation of `x`.
///
@external(javascript, "./big_int.ffi.mjs", "to_base2")
pub fn to_base2(x: BigInt) -> String

/// Returns the base-8 (octal) string representation of `x`.
///
@external(javascript, "./big_int.ffi.mjs", "to_base8")
pub fn to_base8(x: BigInt) -> String

/// Returns the base-16 (hexadecimal) string representation of `x`, with
/// uppercase digits.
///
@external(javascript, "./big_int.ffi.mjs", "to_base16")
pub fn to_base16(x: BigInt) -> String

/// Returns the base-36 string representation of `x`, with uppercase
/// digits.
///
@external(javascript, "./big_int.ffi.mjs", "to_base36")
pub fn to_base36(x: BigInt) -> String

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

/// Truncating integer division. Returns `Error(Nil)` if `divisor` is
/// `0`.
///
@external(javascript, "./big_int.ffi.mjs", "divide")
pub fn divide(dividend: BigInt, by divisor: BigInt) -> Result(BigInt, Nil)

/// Returns the remainder of `dividend / divisor`, truncating toward
/// zero — the result takes the sign of `dividend`. Returns `Error(Nil)`
/// if `divisor` is `0`.
///
@external(javascript, "./big_int.ffi.mjs", "remainder")
pub fn remainder(dividend: BigInt, by divisor: BigInt) -> Result(BigInt, Nil)

/// Floored modulo of `dividend` by `divisor` — the result takes the
/// sign of `divisor`. Returns `Error(Nil)` if `divisor` is `0`.
///
@external(javascript, "./big_int.ffi.mjs", "modulo")
pub fn modulo(dividend: BigInt, by divisor: BigInt) -> Result(BigInt, Nil)

/// Floored integer division — the quotient is rounded toward negative
/// infinity. Returns `Error(Nil)` if `divisor` is `0`.
///
@external(javascript, "./big_int.ffi.mjs", "floor_divide")
pub fn floor_divide(dividend: BigInt, by divisor: BigInt) -> Result(BigInt, Nil)

/// Returns the additive inverse of `x` (i.e., `-x`).
///
@external(javascript, "./big_int.ffi.mjs", "negate")
pub fn negate(x: BigInt) -> BigInt

/// Returns the absolute value of `x`.
///
@external(javascript, "./big_int.ffi.mjs", "absolute_value")
pub fn absolute_value(x: BigInt) -> BigInt

/// Raises `base` to the power of `exponent`. Returns `Error(Nil)` if
/// `exponent` is negative (the result would be fractional).
///
@external(javascript, "./big_int.ffi.mjs", "power")
pub fn power(base: BigInt, of exponent: BigInt) -> Result(BigInt, Nil)

/// Compares `a` and `b`, returning their relative ordering as a
/// [`gleam/order.Order`](https://hexdocs.pm/gleam_stdlib/gleam/order.html#Order).
///
@external(javascript, "./big_int.ffi.mjs", "compare")
pub fn compare(a: BigInt, with b: BigInt) -> Order

/// Returns the smaller of `a` and `b`.
///
@external(javascript, "./big_int.ffi.mjs", "min")
pub fn min(a: BigInt, b: BigInt) -> BigInt

/// Returns the larger of `a` and `b`.
///
@external(javascript, "./big_int.ffi.mjs", "max")
pub fn max(a: BigInt, b: BigInt) -> BigInt

/// Restricts `x` to be within the range `min_bound`–`max_bound`
/// (inclusive).
///
@external(javascript, "./big_int.ffi.mjs", "clamp")
pub fn clamp(x: BigInt, min min_bound: BigInt, max max_bound: BigInt) -> BigInt

/// Sums a list of `BigInt`s. The empty list sums to `0`.
///
pub fn sum(numbers: List(BigInt)) -> BigInt {
  list.fold(numbers, from_int(0), add)
}

/// Multiplies a list of `BigInt`s. The empty list has a product of `1`.
///
pub fn product(numbers: List(BigInt)) -> BigInt {
  list.fold(numbers, from_int(1), multiply)
}

/// Whether `x` is even.
///
@external(javascript, "./big_int.ffi.mjs", "is_even")
pub fn is_even(x: BigInt) -> Bool

/// Whether `x` is odd.
///
@external(javascript, "./big_int.ffi.mjs", "is_odd")
pub fn is_odd(x: BigInt) -> Bool

/// Returns the bitwise AND of `x` and `y`. Operates on the two's
/// complement representation.
///
@external(javascript, "./big_int.ffi.mjs", "bitwise_and")
pub fn bitwise_and(x: BigInt, y: BigInt) -> BigInt

/// Returns the bitwise OR of `x` and `y`. Operates on the two's
/// complement representation.
///
@external(javascript, "./big_int.ffi.mjs", "bitwise_or")
pub fn bitwise_or(x: BigInt, y: BigInt) -> BigInt

/// Returns the bitwise XOR of `x` and `y`. Operates on the two's
/// complement representation.
///
@external(javascript, "./big_int.ffi.mjs", "bitwise_exclusive_or")
pub fn bitwise_exclusive_or(x: BigInt, y: BigInt) -> BigInt

/// Returns the bitwise NOT of `x`. Equivalent to `-x - 1`.
///
@external(javascript, "./big_int.ffi.mjs", "bitwise_not")
pub fn bitwise_not(x: BigInt) -> BigInt

/// Shifts `x` left by `y` bits. Returns `Error(Nil)` if `y` is
/// negative.
///
@external(javascript, "./big_int.ffi.mjs", "bitwise_shift_left")
pub fn bitwise_shift_left(x: BigInt, y: BigInt) -> Result(BigInt, Nil)

/// Shifts `x` right by `y` bits (arithmetic shift — sign-extends).
/// Returns `Error(Nil)` if `y` is negative.
///
@external(javascript, "./big_int.ffi.mjs", "bitwise_shift_right")
pub fn bitwise_shift_right(x: BigInt, y: BigInt) -> Result(BigInt, Nil)

/// Wraps `x` to a `bits`-wide two's-complement signed integer — `x`
/// modulo `2^bits`, interpreted as signed. A `bits` of `0` or less
/// yields `0`. Equivalent to JavaScript's `BigInt.asIntN`.
///
@external(javascript, "./big_int.ffi.mjs", "as_int_n")
pub fn as_int_n(x: BigInt, bits bits: Int) -> BigInt

/// Wraps `x` to a `bits`-wide unsigned integer — `x` modulo `2^bits`. A
/// `bits` of `0` or less yields `0`. Equivalent to JavaScript's
/// `BigInt.asUintN`.
///
@external(javascript, "./big_int.ffi.mjs", "as_uint_n")
pub fn as_uint_n(x: BigInt, bits bits: Int) -> BigInt
