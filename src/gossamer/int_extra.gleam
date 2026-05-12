//// Extras for `gleam/int` — JavaScript Number safe-integer bounds,
//// 32-bit integer operations, and locale-aware string formatting that
//// `gleam/int` doesn't cover.

/// The maximum safe integer in JavaScript, `2^53 - 1`. Integers within
/// `min_safe_integer` and `max_safe_integer` round-trip without loss
/// across the FFI boundary.
///
pub const max_safe_integer = 9_007_199_254_740_991

/// The minimum safe integer in JavaScript, `-(2^53 - 1)`.
///
pub const min_safe_integer = -9_007_199_254_740_991

/// Returns the number of leading zero bits in the 32-bit binary
/// representation of an integer.
///
@external(javascript, "./int_extra.ffi.mjs", "clz32")
pub fn clz32(value: Int) -> Int

/// Returns the result of C-like 32-bit integer multiplication of two
/// numbers, wrapping on overflow.
///
@external(javascript, "./int_extra.ffi.mjs", "imul")
pub fn imul(a: Int, b: Int) -> Int

/// Returns a locale-sensitive string representation of the integer,
/// applying the runtime's locale for thousands separators and digit
/// shaping (e.g., `1234` becomes `"1,234"` in `en-US` and `"1 234"`
/// in `fr-FR`). For plain formatting, use `gleam/int.to_string`.
///
@external(javascript, "./int_extra.ffi.mjs", "to_locale_string")
pub fn to_locale_string(value: Int) -> String
