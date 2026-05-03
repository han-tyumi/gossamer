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

pub fn from_string_test() {
  let assert Ok(value) = big_int.from_string("12345678901234567890")
  big_int.to_string(value) |> should.equal("12345678901234567890")
}

pub fn from_string_negative_test() {
  let assert Ok(value) = big_int.from_string("-99")
  big_int.to_string(value) |> should.equal("-99")
}

pub fn from_string_invalid_errors_test() {
  let assert Error(_) = big_int.from_string("not a number")
}

pub fn from_string_decimal_errors_test() {
  // BigInt rejects decimals — only integer literals are valid.
  let assert Error(_) = big_int.from_string("1.5")
}

pub fn from_string_empty_is_zero_test() {
  // Matches JS `BigInt("")` returning 0n; documented contract.
  let assert Ok(value) = big_int.from_string("")
  big_int.to_string(value) |> should.equal("0")
}

pub fn from_string_hex_test() {
  let assert Ok(value) = big_int.from_string("0x2a")
  big_int.to_int(value) |> should.equal(Ok(42))
}

pub fn from_string_octal_test() {
  let assert Ok(value) = big_int.from_string("0o52")
  big_int.to_int(value) |> should.equal(Ok(42))
}

pub fn from_string_binary_test() {
  let assert Ok(value) = big_int.from_string("0b101010")
  big_int.to_int(value) |> should.equal(Ok(42))
}

pub fn from_string_scientific_errors_test() {
  // Scientific notation is not a valid integer literal.
  let assert Error(_) = big_int.from_string("1e3")
}

pub fn from_string_trailing_n_errors_test() {
  // The `n` literal suffix is JS source syntax, not parseable as a
  // string.
  let assert Error(_) = big_int.from_string("42n")
}

pub fn to_int_at_max_safe_test() {
  // 2^53 − 1 is exactly Number.MAX_SAFE_INTEGER; converts cleanly.
  let assert Ok(at_max) = big_int.from_string("9007199254740991")
  big_int.to_int(at_max) |> should.equal(Ok(9_007_199_254_740_991))
}

pub fn to_int_just_above_max_safe_errors_test() {
  // 2^53 is one above MAX_SAFE — even though representable as a JS
  // Number, we error to guarantee precision-safe narrowing.
  let assert Ok(above) = big_int.from_string("9007199254740992")
  let assert Error(_) = big_int.to_int(above)
}

pub fn to_int_at_min_safe_test() {
  let assert Ok(at_min) = big_int.from_string("-9007199254740991")
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
  let assert Ok(too_big) = big_int.from_string("9007199254740993")
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
  let assert Ok(a) = big_int.from_string("1000000000000")
  let assert Ok(b) = big_int.from_string("1000000000000")
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
  big_int.compare(big_int.from_int(10), big_int.from_int(20))
  |> should.equal(order.Lt)
}

pub fn compare_gt_test() {
  big_int.compare(big_int.from_int(20), big_int.from_int(10))
  |> should.equal(order.Gt)
}

pub fn compare_eq_test() {
  big_int.compare(big_int.from_int(42), big_int.from_int(42))
  |> should.equal(order.Eq)
}

pub fn compare_large_values_test() {
  let assert Ok(a) = big_int.from_string("99999999999999999999")
  let assert Ok(b) = big_int.from_string("99999999999999999998")
  big_int.compare(a, b) |> should.equal(order.Gt)
}
