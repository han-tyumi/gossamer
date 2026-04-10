import gleeunit/should
import gossamer/number

pub fn epsilon_test() {
  let ep = number.epsilon()
  should.be_true(ep >. 0.0)
  should.be_true(ep <. 0.001)
}

pub fn max_value_test() {
  let max = number.max_value()
  should.be_true(max >. 0.0)
}

pub fn min_value_test() {
  let min = number.min_value()
  should.be_true(min >. 0.0)
  should.be_true(min <. number.epsilon())
}

pub fn is_nan_test() {
  number.is_nan(0.0) |> should.be_false()
  number.is_nan(1.0) |> should.be_false()
}

pub fn is_finite_test() {
  number.is_finite(1.0) |> should.be_true()
  number.is_finite(0.0) |> should.be_true()
}

pub fn is_integer_test() {
  number.is_integer(1.0) |> should.be_true()
  number.is_integer(1.5) |> should.be_false()
  number.is_integer(0.0) |> should.be_true()
}

pub fn is_safe_integer_test() {
  number.is_safe_integer(1.0) |> should.be_true()
  number.is_safe_integer(1.5) |> should.be_false()
}

pub fn to_fixed_test() {
  number.to_fixed(3.14159, digits: 2) |> should.equal(Ok("3.14"))
  number.to_fixed(1.0, digits: 0) |> should.equal(Ok("1"))
  number.to_fixed(1.005, digits: 2) |> should.equal(Ok("1.00"))
}

pub fn to_fixed_out_of_range_test() {
  number.to_fixed(1.0, digits: -1) |> should.be_error()
  number.to_fixed(1.0, digits: 101) |> should.be_error()
}

pub fn to_precision_test() {
  number.to_precision(123.456, digits: 4) |> should.equal(Ok("123.5"))
  number.to_precision(0.00123, digits: 2) |> should.equal(Ok("0.0012"))
}

pub fn to_precision_out_of_range_test() {
  number.to_precision(1.0, digits: 0) |> should.be_error()
  number.to_precision(1.0, digits: 101) |> should.be_error()
}

pub fn to_exponential_test() {
  number.to_exponential(123_456.0, digits: 2) |> should.equal(Ok("1.23e+5"))
  number.to_exponential(0.0, digits: 0) |> should.equal(Ok("0e+0"))
}

pub fn to_exponential_out_of_range_test() {
  number.to_exponential(1.0, digits: -1) |> should.be_error()
  number.to_exponential(1.0, digits: 101) |> should.be_error()
}

pub fn to_string_with_radix_test() {
  number.to_string_with_radix(255, radix: 16) |> should.equal(Ok("ff"))
  number.to_string_with_radix(10, radix: 2) |> should.equal(Ok("1010"))
  number.to_string_with_radix(8, radix: 8) |> should.equal(Ok("10"))
}

pub fn to_string_with_radix_out_of_range_test() {
  number.to_string_with_radix(10, radix: 1) |> should.be_error()
  number.to_string_with_radix(10, radix: 37) |> should.be_error()
}

pub fn to_locale_string_test() {
  let result = number.to_locale_string(1234.5)
  should.be_true(result != "")
}

pub fn parse_int_test() {
  number.parse_int("ff", radix: 16) |> should.equal(Ok(255))
  number.parse_int("1010", radix: 2) |> should.equal(Ok(10))
  number.parse_int("10", radix: 8) |> should.equal(Ok(8))
  number.parse_int("42", radix: 10) |> should.equal(Ok(42))
}

pub fn parse_int_invalid_test() {
  number.parse_int("xyz", radix: 10) |> should.be_error()
  number.parse_int("", radix: 10) |> should.be_error()
}

pub fn parse_float_test() {
  number.parse_float("3.14") |> should.equal(Ok(3.14))
  number.parse_float("42") |> should.equal(Ok(42.0))
  number.parse_float(".5") |> should.equal(Ok(0.5))
}

pub fn parse_float_invalid_test() {
  number.parse_float("abc") |> should.be_error()
  number.parse_float("") |> should.be_error()
}
