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

pub fn to_locale_string_test() {
  let result = number.to_locale_string(1234.5)
  should.be_true(result != "")
}
