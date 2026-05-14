import gleeunit/should
import gossamer/int_extra

pub fn clz32_test() {
  int_extra.clz32(1) |> should.equal(31)
  int_extra.clz32(0) |> should.equal(32)
  int_extra.clz32(1024) |> should.equal(21)
}

pub fn imul_test() {
  int_extra.imul(3, 4) |> should.equal(12)
  int_extra.imul(-5, 12) |> should.equal(-60)
}
