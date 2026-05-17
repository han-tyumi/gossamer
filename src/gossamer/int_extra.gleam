//// Extras for `gleam/int` — JavaScript Number safe-integer bounds and
//// 32-bit integer operations that `gleam/int` doesn't cover.
////
//// For locale-aware number formatting, use
//// [`gossamer/intl/number_format`](./intl/number_format.html).

/// The maximum safe integer in JavaScript, `2^53 - 1`. Gleam `Int`
/// values between `min_safe_integer` and `max_safe_integer` are
/// represented exactly; values outside this range lose precision.
/// Equivalent to JavaScript's `Number.MAX_SAFE_INTEGER`.
///
pub const max_safe_integer = 9_007_199_254_740_991

/// The minimum safe integer in JavaScript, `-(2^53 - 1)`. Equivalent
/// to JavaScript's `Number.MIN_SAFE_INTEGER`.
///
pub const min_safe_integer = -9_007_199_254_740_991

/// Returns the number of leading zero bits in the 32-bit binary
/// representation of an integer. Equivalent to JavaScript's
/// `Math.clz32`.
///
@external(javascript, "./int_extra.ffi.mjs", "clz32")
pub fn clz32(value: Int) -> Int

/// Returns the result of C-like 32-bit integer multiplication of two
/// numbers, wrapping on overflow. Equivalent to JavaScript's
/// `Math.imul`.
///
@external(javascript, "./int_extra.ffi.mjs", "imul")
pub fn imul(a: Int, b: Int) -> Int
