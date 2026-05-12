import gleeunit/should
import gossamer/stream/byte_length_queuing_strategy as bytes_strategy
import gossamer/stream/count_queuing_strategy as count_strategy

pub fn byte_length_new_test() {
  let strategy = bytes_strategy.new(bytes_strategy.Bytes(1024))
  bytes_strategy.high_water_mark(strategy)
  |> should.equal(bytes_strategy.Bytes(1024))
}

pub fn byte_length_zero_test() {
  let strategy = bytes_strategy.new(bytes_strategy.Bytes(0))
  bytes_strategy.high_water_mark(strategy)
  |> should.equal(bytes_strategy.Bytes(0))
}

pub fn byte_length_unlimited_test() {
  let strategy = bytes_strategy.new(bytes_strategy.Unlimited)
  bytes_strategy.high_water_mark(strategy)
  |> should.equal(bytes_strategy.Unlimited)
}

pub fn count_new_test() {
  let strategy = count_strategy.new(count_strategy.Chunks(10))
  count_strategy.high_water_mark(strategy)
  |> should.equal(count_strategy.Chunks(10))
}

pub fn count_zero_test() {
  let strategy = count_strategy.new(count_strategy.Chunks(0))
  count_strategy.high_water_mark(strategy)
  |> should.equal(count_strategy.Chunks(0))
}

pub fn count_unlimited_test() {
  let strategy = count_strategy.new(count_strategy.Unlimited)
  count_strategy.high_water_mark(strategy)
  |> should.equal(count_strategy.Unlimited)
}
