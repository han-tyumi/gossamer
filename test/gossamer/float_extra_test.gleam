import gleeunit/should
import gossamer/float_extra

pub fn cbrt_test() {
  float_extra.cbrt(27.0) |> should.equal(3.0)
  float_extra.cbrt(8.0) |> should.equal(2.0)
}

pub fn hypot_test() {
  float_extra.hypot([3.0, 4.0]) |> should.equal(5.0)
}

pub fn hypot_three_test() {
  float_extra.hypot([1.0, 2.0, 2.0]) |> should.equal(3.0)
}

pub fn hypot_empty_test() {
  float_extra.hypot([]) |> should.equal(0.0)
}

pub fn fround_test() {
  let value = float_extra.fround(1.337)
  should.be_true(value >. 1.336 && value <. 1.338)
}

pub fn log2_test() {
  float_extra.log2(8.0) |> should.equal(Ok(3.0))
  float_extra.log2(1.0) |> should.equal(Ok(0.0))
}

pub fn log2_zero_test() {
  float_extra.log2(0.0) |> should.be_error()
}

pub fn log2_negative_test() {
  float_extra.log2(-1.0) |> should.be_error()
}

pub fn log10_test() {
  float_extra.log10(1000.0) |> should.equal(Ok(3.0))
  float_extra.log10(1.0) |> should.equal(Ok(0.0))
}

pub fn log10_zero_test() {
  float_extra.log10(0.0) |> should.be_error()
}

pub fn log10_negative_test() {
  float_extra.log10(-1.0) |> should.be_error()
}

pub fn log1p_test() {
  float_extra.log1p(0.0) |> should.equal(Ok(0.0))
}

pub fn log1p_boundary_test() {
  float_extra.log1p(-1.0) |> should.be_error()
}

pub fn log1p_out_of_range_test() {
  float_extra.log1p(-2.0) |> should.be_error()
}

pub fn sin_test() {
  float_extra.sin(0.0) |> should.equal(0.0)
  let sin_half_pi = float_extra.sin(float_extra.pi /. 2.0)
  should.be_true(sin_half_pi >. 0.9999 && sin_half_pi <. 1.0001)
}

pub fn cos_test() {
  float_extra.cos(0.0) |> should.equal(1.0)
  let cos_pi = float_extra.cos(float_extra.pi)
  should.be_true(cos_pi >. -1.0001 && cos_pi <. -0.9999)
}

pub fn tan_test() {
  float_extra.tan(0.0) |> should.equal(0.0)
}

pub fn asin_test() {
  float_extra.asin(0.0) |> should.equal(Ok(0.0))
  let assert Ok(asin_1) = float_extra.asin(1.0)
  let half_pi = float_extra.pi /. 2.0
  should.be_true(asin_1 >. half_pi -. 0.0001 && asin_1 <. half_pi +. 0.0001)
}

pub fn asin_out_of_range_test() {
  float_extra.asin(2.0) |> should.be_error()
}

pub fn acos_test() {
  let assert Ok(acos_1) = float_extra.acos(1.0)
  should.be_true(acos_1 >=. 0.0 && acos_1 <. 0.0001)
}

pub fn acos_out_of_range_test() {
  float_extra.acos(2.0) |> should.be_error()
}

pub fn atan_test() {
  float_extra.atan(0.0) |> should.equal(0.0)
}

pub fn atan2_test() {
  let result = float_extra.atan2(1.0, 1.0)
  let quarter_pi = float_extra.pi /. 4.0
  should.be_true(
    result >. quarter_pi -. 0.0001 && result <. quarter_pi +. 0.0001,
  )
}

pub fn sinh_test() {
  float_extra.sinh(0.0) |> should.equal(0.0)
}

pub fn cosh_test() {
  float_extra.cosh(0.0) |> should.equal(1.0)
}

pub fn tanh_test() {
  float_extra.tanh(0.0) |> should.equal(0.0)
}

pub fn asinh_test() {
  float_extra.asinh(0.0) |> should.equal(0.0)
}

pub fn acosh_test() {
  float_extra.acosh(1.0) |> should.equal(Ok(0.0))
}

pub fn acosh_out_of_range_test() {
  float_extra.acosh(0.5) |> should.be_error()
}

pub fn atanh_test() {
  float_extra.atanh(0.0) |> should.equal(Ok(0.0))
}

pub fn atanh_out_of_range_test() {
  float_extra.atanh(1.0) |> should.be_error()
}

pub fn expm1_test() {
  float_extra.expm1(0.0) |> should.equal(0.0)
}

pub fn to_fixed_string_test() {
  float_extra.to_fixed_string(3.14159, 2) |> should.equal(Ok("3.14"))
  float_extra.to_fixed_string(1.0, 0) |> should.equal(Ok("1"))
  float_extra.to_fixed_string(1.005, 2) |> should.equal(Ok("1.00"))
}

pub fn to_fixed_string_out_of_range_test() {
  float_extra.to_fixed_string(1.0, -1) |> should.be_error()
  float_extra.to_fixed_string(1.0, 101) |> should.be_error()
}

pub fn to_precision_string_test() {
  float_extra.to_precision_string(123.456, 4)
  |> should.equal(Ok("123.5"))
  float_extra.to_precision_string(0.00123, 2)
  |> should.equal(Ok("0.0012"))
}

pub fn to_precision_string_out_of_range_test() {
  float_extra.to_precision_string(1.0, 0) |> should.be_error()
  float_extra.to_precision_string(1.0, 101) |> should.be_error()
}

pub fn to_exponential_string_test() {
  float_extra.to_exponential_string(123_456.0, 2)
  |> should.equal(Ok("1.23e+5"))
  float_extra.to_exponential_string(0.0, 0)
  |> should.equal(Ok("0e+0"))
}

pub fn to_exponential_string_out_of_range_test() {
  float_extra.to_exponential_string(1.0, -1) |> should.be_error()
  float_extra.to_exponential_string(1.0, 101) |> should.be_error()
}
