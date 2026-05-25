import gleam/order
import gleeunit/should
import gossamer/big_int

pub fn from_int_test() {
  let value = big_int.from_int(42)
  big_int.to_string(value) |> should.equal("42")
}

pub fn from_int_negative_test() {
  let value = big_int.from_int(-100)
  big_int.to_string(value) |> should.equal("-100")
}

pub fn parse_test() {
  let assert Ok(value) = big_int.parse("12345678901234567890")
  big_int.to_string(value) |> should.equal("12345678901234567890")
}

pub fn parse_negative_test() {
  let assert Ok(value) = big_int.parse("-99")
  big_int.to_string(value) |> should.equal("-99")
}

pub fn parse_invalid_errors_test() {
  let assert Error(_) = big_int.parse("not a number")
}

pub fn parse_decimal_errors_test() {
  // BigInt rejects decimals — only integer literals are valid.
  let assert Error(_) = big_int.parse("1.5")
}

pub fn parse_empty_is_zero_test() {
  // Matches JS `BigInt("")` returning 0n; documented contract.
  let assert Ok(value) = big_int.parse("")
  big_int.to_string(value) |> should.equal("0")
}

pub fn parse_hex_test() {
  let assert Ok(value) = big_int.parse("0x2a")
  big_int.to_int(value) |> should.equal(Ok(42))
}

pub fn parse_octal_test() {
  let assert Ok(value) = big_int.parse("0o52")
  big_int.to_int(value) |> should.equal(Ok(42))
}

pub fn parse_binary_test() {
  let assert Ok(value) = big_int.parse("0b101010")
  big_int.to_int(value) |> should.equal(Ok(42))
}

pub fn parse_scientific_errors_test() {
  // Scientific notation is not a valid integer literal.
  let assert Error(_) = big_int.parse("1e3")
}

pub fn parse_trailing_n_errors_test() {
  // The `n` literal suffix is JS source syntax, not parseable as a
  // string.
  let assert Error(_) = big_int.parse("42n")
}

pub fn to_int_at_max_safe_test() {
  // 2^53 − 1 is exactly Number.MAX_SAFE_INTEGER; converts cleanly.
  let assert Ok(at_max) = big_int.parse("9007199254740991")
  big_int.to_int(at_max) |> should.equal(Ok(9_007_199_254_740_991))
}

pub fn to_int_just_above_max_safe_errors_test() {
  // 2^53 is one above MAX_SAFE — even though representable as a JS
  // Number, we error to guarantee precision-safe narrowing.
  let assert Ok(above) = big_int.parse("9007199254740992")
  let assert Error(_) = big_int.to_int(above)
}

pub fn to_int_at_min_safe_test() {
  let assert Ok(at_min) = big_int.parse("-9007199254740991")
  big_int.to_int(at_min) |> should.equal(Ok(-9_007_199_254_740_991))
}

pub fn to_int_in_range_test() {
  let value = big_int.from_int(42)
  big_int.to_int(value) |> should.equal(Ok(42))
}

pub fn to_int_negative_test() {
  let value = big_int.from_int(-12_345)
  big_int.to_int(value) |> should.equal(Ok(-12_345))
}

pub fn to_int_overflow_errors_test() {
  // 2^53 + 1 is outside the safe-integer range; converting would lose
  // precision, so we error.
  let assert Ok(too_big) = big_int.parse("9007199254740993")
  let assert Error(_) = big_int.to_int(too_big)
}

pub fn add_test() {
  let a = big_int.from_int(100)
  let b = big_int.from_int(250)
  big_int.add(a, b) |> big_int.to_string |> should.equal("350")
}

pub fn subtract_test() {
  let a = big_int.from_int(100)
  let b = big_int.from_int(250)
  big_int.subtract(a, b) |> big_int.to_string |> should.equal("-150")
}

pub fn multiply_large_test() {
  // Multiply two values whose product overflows Gleam Int.
  let assert Ok(a) = big_int.parse("1000000000000")
  let assert Ok(b) = big_int.parse("1000000000000")
  big_int.multiply(a, b)
  |> big_int.to_string
  |> should.equal("1000000000000000000000000")
}

pub fn divide_test() {
  let a = big_int.from_int(100)
  let b = big_int.from_int(7)
  let assert Ok(result) = big_int.divide(a, by: b)
  big_int.to_string(result) |> should.equal("14")
  // Truncating: 100 / 7 = 14 remainder 2.
}

pub fn divide_by_zero_errors_test() {
  let a = big_int.from_int(100)
  let zero = big_int.from_int(0)
  let assert Error(_) = big_int.divide(a, by: zero)
}

pub fn remainder_test() {
  let a = big_int.from_int(100)
  let b = big_int.from_int(7)
  let assert Ok(result) = big_int.remainder(a, by: b)
  big_int.to_string(result) |> should.equal("2")
}

pub fn remainder_by_zero_errors_test() {
  let a = big_int.from_int(100)
  let zero = big_int.from_int(0)
  let assert Error(_) = big_int.remainder(a, by: zero)
}

pub fn negate_test() {
  big_int.from_int(42)
  |> big_int.negate
  |> big_int.to_string
  |> should.equal("-42")
  big_int.from_int(-42)
  |> big_int.negate
  |> big_int.to_string
  |> should.equal("42")
}

pub fn absolute_value_test() {
  big_int.from_int(42)
  |> big_int.absolute_value
  |> big_int.to_string
  |> should.equal("42")
  big_int.from_int(-42)
  |> big_int.absolute_value
  |> big_int.to_string
  |> should.equal("42")
}

pub fn compare_lt_test() {
  big_int.compare(big_int.from_int(10), with: big_int.from_int(20))
  |> should.equal(order.Lt)
}

pub fn compare_gt_test() {
  big_int.compare(big_int.from_int(20), with: big_int.from_int(10))
  |> should.equal(order.Gt)
}

pub fn compare_eq_test() {
  big_int.compare(big_int.from_int(42), with: big_int.from_int(42))
  |> should.equal(order.Eq)
}

pub fn compare_large_values_test() {
  let assert Ok(a) = big_int.parse("99999999999999999999")
  let assert Ok(b) = big_int.parse("99999999999999999998")
  big_int.compare(a, with: b) |> should.equal(order.Gt)
}

pub fn power_test() {
  let base = big_int.from_int(2)
  let exponent = big_int.from_int(10)
  let assert Ok(result) = big_int.power(base, of: exponent)
  big_int.to_string(result) |> should.equal("1024")
}

pub fn power_large_test() {
  // 2^100 is well outside Int's safe range.
  let base = big_int.from_int(2)
  let exponent = big_int.from_int(100)
  let assert Ok(result) = big_int.power(base, of: exponent)
  big_int.to_string(result)
  |> should.equal("1267650600228229401496703205376")
}

pub fn power_negative_exponent_errors_test() {
  let base = big_int.from_int(2)
  let exponent = big_int.from_int(-1)
  let assert Error(_) = big_int.power(base, of: exponent)
}

pub fn bitwise_and_test() {
  big_int.bitwise_and(big_int.from_int(0b1100), big_int.from_int(0b1010))
  |> big_int.to_int
  |> should.equal(Ok(0b1000))
}

pub fn bitwise_or_test() {
  big_int.bitwise_or(big_int.from_int(0b1100), big_int.from_int(0b1010))
  |> big_int.to_int
  |> should.equal(Ok(0b1110))
}

pub fn bitwise_exclusive_or_test() {
  big_int.bitwise_exclusive_or(
    big_int.from_int(0b1100),
    big_int.from_int(0b1010),
  )
  |> big_int.to_int
  |> should.equal(Ok(0b0110))
}

pub fn bitwise_not_test() {
  // ~5 in two's complement is -6.
  big_int.bitwise_not(big_int.from_int(5))
  |> big_int.to_int
  |> should.equal(Ok(-6))
}

pub fn bitwise_shift_left_test() {
  let value = big_int.from_int(1)
  let by = big_int.from_int(8)
  let assert Ok(result) = big_int.bitwise_shift_left(value, by)
  big_int.to_int(result) |> should.equal(Ok(256))
}

pub fn bitwise_shift_left_negative_errors_test() {
  let value = big_int.from_int(1)
  let by = big_int.from_int(-1)
  let assert Error(_) = big_int.bitwise_shift_left(value, by)
}

pub fn bitwise_shift_right_test() {
  let value = big_int.from_int(256)
  let by = big_int.from_int(4)
  let assert Ok(result) = big_int.bitwise_shift_right(value, by)
  big_int.to_int(result) |> should.equal(Ok(16))
}

pub fn bitwise_shift_right_negative_errors_test() {
  let value = big_int.from_int(256)
  let by = big_int.from_int(-1)
  let assert Error(_) = big_int.bitwise_shift_right(value, by)
}

pub fn modulo_test() {
  let a = big_int.from_int(100)
  let b = big_int.from_int(7)
  let assert Ok(result) = big_int.modulo(a, by: b)
  big_int.to_string(result) |> should.equal("2")
}

pub fn modulo_negative_takes_divisor_sign_test() {
  let a = big_int.from_int(-100)
  let b = big_int.from_int(7)
  let assert Ok(result) = big_int.modulo(a, by: b)
  // Floored: -100 mod 7 = 5 (sign of divisor), where remainder is -2.
  big_int.to_string(result) |> should.equal("5")
}

pub fn modulo_by_zero_errors_test() {
  let a = big_int.from_int(100)
  let zero = big_int.from_int(0)
  let assert Error(_) = big_int.modulo(a, by: zero)
}

pub fn to_base_string_hex_test() {
  big_int.from_int(255) |> big_int.to_base_string(16) |> should.equal(Ok("FF"))
}

pub fn to_base_shortcuts_test() {
  let value = big_int.from_int(255)
  big_int.to_base2(value) |> should.equal("11111111")
  big_int.to_base8(value) |> should.equal("377")
  big_int.to_base16(value) |> should.equal("FF")
  big_int.to_base36(value) |> should.equal("73")
}

pub fn to_base_string_invalid_base_errors_test() {
  big_int.from_int(255) |> big_int.to_base_string(37) |> should.be_error
}

pub fn as_int_n_wraps_signed_test() {
  let assert Ok(value) = big_int.parse("255")
  // 8-bit signed: 255 wraps to -1.
  big_int.as_int_n(value, bits: 8) |> big_int.to_string |> should.equal("-1")
}

pub fn as_int_n_zero_bits_test() {
  big_int.from_int(255)
  |> big_int.as_int_n(bits: 0)
  |> big_int.to_string
  |> should.equal("0")
}

pub fn as_uint_n_wraps_unsigned_test() {
  // 8-bit unsigned: 257 wraps to 1.
  big_int.from_int(257)
  |> big_int.as_uint_n(bits: 8)
  |> big_int.to_string
  |> should.equal("1")
}

pub fn base_parse_hex_test() {
  let assert Ok(value) = big_int.base_parse("FF", 16)
  big_int.to_int(value) |> should.equal(Ok(255))
}

pub fn base_parse_base36_test() {
  let assert Ok(value) = big_int.base_parse("zz", 36)
  big_int.to_int(value) |> should.equal(Ok(1295))
}

pub fn base_parse_invalid_digit_errors_test() {
  let assert Error(_) = big_int.base_parse("12", 2)
}

pub fn base_parse_invalid_base_errors_test() {
  let assert Error(_) = big_int.base_parse("10", 37)
}

pub fn to_float_test() {
  big_int.from_int(42) |> big_int.to_float |> should.equal(Ok(42.0))
}

pub fn to_float_overflow_errors_test() {
  let assert Ok(huge) =
    big_int.power(big_int.from_int(10), of: big_int.from_int(400))
  let assert Error(_) = big_int.to_float(huge)
}

pub fn floor_divide_test() {
  let a = big_int.from_int(-7)
  let b = big_int.from_int(2)
  let assert Ok(result) = big_int.floor_divide(a, by: b)
  // Floored: -7 / 2 = -4 (rounds toward negative infinity), vs -3 truncating.
  big_int.to_string(result) |> should.equal("-4")
}

pub fn floor_divide_by_zero_errors_test() {
  let assert Error(_) =
    big_int.floor_divide(big_int.from_int(1), by: big_int.from_int(0))
}

pub fn min_max_test() {
  let a = big_int.from_int(10)
  let b = big_int.from_int(20)
  big_int.min(a, b) |> big_int.to_int |> should.equal(Ok(10))
  big_int.max(a, b) |> big_int.to_int |> should.equal(Ok(20))
}

pub fn clamp_test() {
  let lo = big_int.from_int(0)
  let hi = big_int.from_int(10)
  big_int.clamp(big_int.from_int(20), min: lo, max: hi)
  |> big_int.to_int
  |> should.equal(Ok(10))
  big_int.clamp(big_int.from_int(-5), min: lo, max: hi)
  |> big_int.to_int
  |> should.equal(Ok(0))
}

pub fn sum_test() {
  [big_int.from_int(1), big_int.from_int(2), big_int.from_int(3)]
  |> big_int.sum
  |> big_int.to_int
  |> should.equal(Ok(6))
}

pub fn sum_empty_test() {
  big_int.sum([]) |> big_int.to_int |> should.equal(Ok(0))
}

pub fn product_test() {
  [big_int.from_int(2), big_int.from_int(3), big_int.from_int(4)]
  |> big_int.product
  |> big_int.to_int
  |> should.equal(Ok(24))
}

pub fn product_empty_test() {
  big_int.product([]) |> big_int.to_int |> should.equal(Ok(1))
}

pub fn is_even_test() {
  big_int.is_even(big_int.from_int(4)) |> should.be_true
  big_int.is_even(big_int.from_int(5)) |> should.be_false
}

pub fn is_odd_test() {
  big_int.is_odd(big_int.from_int(5)) |> should.be_true
  big_int.is_odd(big_int.from_int(4)) |> should.be_false
}
