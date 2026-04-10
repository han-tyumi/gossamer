import gleeunit/should
import gossamer/math

pub fn random_test() {
  let value = math.random()
  should.be_true(value >=. 0.0 && value <. 1.0)
}

pub fn sign_test() {
  math.sign(-5.0) |> should.equal(-1.0)
  math.sign(0.0) |> should.equal(0.0)
  math.sign(5.0) |> should.equal(1.0)
}

pub fn trunc_test() {
  math.trunc(3.7) |> should.equal(3.0)
  math.trunc(-3.7) |> should.equal(-3.0)
  math.trunc(0.5) |> should.equal(0.0)
}

pub fn cbrt_test() {
  math.cbrt(27.0) |> should.equal(3.0)
  math.cbrt(8.0) |> should.equal(2.0)
}

pub fn hypot_test() {
  math.hypot(3.0, 4.0) |> should.equal(5.0)
}

pub fn log_test() {
  math.log(1.0) |> should.equal(Ok(0.0))
  let assert Ok(log_e) = math.log(math.e)
  should.be_true(log_e >. 0.9999 && log_e <. 1.0001)
}

pub fn log_negative_test() {
  math.log(-1.0) |> should.be_error()
}

pub fn log_zero_test() {
  math.log(0.0) |> should.be_error()
}

pub fn log2_test() {
  math.log2(8.0) |> should.equal(Ok(3.0))
  math.log2(1.0) |> should.equal(Ok(0.0))
}

pub fn log2_zero_test() {
  math.log2(0.0) |> should.be_error()
}

pub fn log2_negative_test() {
  math.log2(-1.0) |> should.be_error()
}

pub fn log10_test() {
  math.log10(1000.0) |> should.equal(Ok(3.0))
  math.log10(1.0) |> should.equal(Ok(0.0))
}

pub fn log10_zero_test() {
  math.log10(0.0) |> should.be_error()
}

pub fn log10_negative_test() {
  math.log10(-1.0) |> should.be_error()
}

pub fn log1p_test() {
  math.log1p(0.0) |> should.equal(Ok(0.0))
}

pub fn log1p_boundary_test() {
  math.log1p(-1.0) |> should.be_error()
}

pub fn log1p_out_of_range_test() {
  math.log1p(-2.0) |> should.be_error()
}

pub fn sin_test() {
  math.sin(0.0) |> should.equal(0.0)
  let sin_half_pi = math.sin(math.pi /. 2.0)
  should.be_true(sin_half_pi >. 0.9999 && sin_half_pi <. 1.0001)
}

pub fn cos_test() {
  math.cos(0.0) |> should.equal(1.0)
  let cos_pi = math.cos(math.pi)
  should.be_true(cos_pi >. -1.0001 && cos_pi <. -0.9999)
}

pub fn tan_test() {
  math.tan(0.0) |> should.equal(0.0)
}

pub fn asin_test() {
  math.asin(0.0) |> should.equal(Ok(0.0))
  let assert Ok(asin_1) = math.asin(1.0)
  let half_pi = math.pi /. 2.0
  should.be_true(asin_1 >. half_pi -. 0.0001 && asin_1 <. half_pi +. 0.0001)
}

pub fn asin_out_of_range_test() {
  math.asin(2.0) |> should.be_error()
}

pub fn acos_test() {
  let assert Ok(acos_1) = math.acos(1.0)
  should.be_true(acos_1 >=. 0.0 && acos_1 <. 0.0001)
}

pub fn acos_out_of_range_test() {
  math.acos(2.0) |> should.be_error()
}

pub fn atan_test() {
  math.atan(0.0) |> should.equal(0.0)
}

pub fn atan2_test() {
  let result = math.atan2(1.0, 1.0)
  let quarter_pi = math.pi /. 4.0
  should.be_true(
    result >. quarter_pi -. 0.0001 && result <. quarter_pi +. 0.0001,
  )
}

pub fn sinh_test() {
  math.sinh(0.0) |> should.equal(0.0)
}

pub fn cosh_test() {
  math.cosh(0.0) |> should.equal(1.0)
}

pub fn tanh_test() {
  math.tanh(0.0) |> should.equal(0.0)
}

pub fn asinh_test() {
  math.asinh(0.0) |> should.equal(0.0)
}

pub fn acosh_test() {
  math.acosh(1.0) |> should.equal(Ok(0.0))
}

pub fn acosh_out_of_range_test() {
  math.acosh(0.5) |> should.be_error()
}

pub fn atanh_test() {
  math.atanh(0.0) |> should.equal(Ok(0.0))
}

pub fn atanh_out_of_range_test() {
  math.atanh(1.0) |> should.be_error()
}

pub fn exp_test() {
  math.exp(0.0) |> should.equal(1.0)
  let exp_1 = math.exp(1.0)
  should.be_true(exp_1 >. math.e -. 0.0001 && exp_1 <. math.e +. 0.0001)
}

pub fn expm1_test() {
  math.expm1(0.0) |> should.equal(0.0)
}

pub fn clz32_test() {
  math.clz32(1) |> should.equal(31)
  math.clz32(0) |> should.equal(32)
  math.clz32(1024) |> should.equal(21)
}

pub fn fround_test() {
  let value = math.fround(1.337)
  should.be_true(value >. 1.336 && value <. 1.338)
}

pub fn imul_test() {
  math.imul(3, 4) |> should.equal(12)
  math.imul(-5, 12) |> should.equal(-60)
}
