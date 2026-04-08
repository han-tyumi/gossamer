import gleeunit/should
import gossamer/byte_length_queuing_strategy
import gossamer/count_queuing_strategy

pub fn byte_length_new_test() {
  let strategy = byte_length_queuing_strategy.new(1024.0)
  byte_length_queuing_strategy.high_water_mark(strategy)
  |> should.equal(1024.0)
}

pub fn byte_length_zero_test() {
  let strategy = byte_length_queuing_strategy.new(0.0)
  byte_length_queuing_strategy.high_water_mark(strategy)
  |> should.equal(0.0)
}

pub fn count_new_test() {
  let strategy = count_queuing_strategy.new(10.0)
  count_queuing_strategy.high_water_mark(strategy)
  |> should.equal(10.0)
}

pub fn count_zero_test() {
  let strategy = count_queuing_strategy.new(0.0)
  count_queuing_strategy.high_water_mark(strategy)
  |> should.equal(0.0)
}
