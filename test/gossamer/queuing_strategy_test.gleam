import gleam/javascript/promise
import gleeunit/should
import gossamer/stream
import gossamer/stream/readable_stream
import gossamer/stream/readable_stream/default_controller as readable_controller
import gossamer/stream/transform_stream
import gossamer/stream/writable_stream

pub fn readable_with_unlimited_strategy_test() {
  let assert Ok(_stream) =
    readable_stream.new()
    |> readable_stream.with_queuing_strategy(stream.Unlimited)
    |> readable_stream.build
}

pub fn readable_with_count_strategy_test() {
  let assert Ok(_stream) =
    readable_stream.new()
    |> readable_stream.with_queuing_strategy(stream.ByCount(5))
    |> readable_stream.build
}

pub fn readable_with_byte_length_strategy_test() {
  let assert Ok(_stream) =
    readable_stream.new()
    |> readable_stream.with_queuing_strategy(stream.ByByteLength(1024))
    |> readable_stream.build
}

pub fn readable_strategy_applied_to_desired_size_test() {
  let #(p, resolve) = promise.start()
  let assert Ok(_stream) =
    readable_stream.new()
    |> readable_stream.with_queuing_strategy(stream.ByCount(5))
    |> readable_stream.with_start(fn(controller) {
      let assert Ok(size) = readable_controller.desired_size(controller)
      resolve(size)
    })
    |> readable_stream.build
  use size <- promise.map(p)
  should.equal(size, 5.0)
}

pub fn writable_with_count_strategy_test() {
  let assert Ok(_stream) =
    writable_stream.new()
    |> writable_stream.with_queuing_strategy(stream.ByCount(3))
    |> writable_stream.build
}

pub fn writable_with_unlimited_strategy_test() {
  let assert Ok(_stream) =
    writable_stream.new()
    |> writable_stream.with_queuing_strategy(stream.Unlimited)
    |> writable_stream.build
}

pub fn transform_with_both_strategies_test() {
  let assert Ok(_stream) =
    transform_stream.new()
    |> transform_stream.with_writable_strategy(stream.ByCount(2))
    |> transform_stream.with_readable_strategy(stream.ByByteLength(512))
    |> transform_stream.build
}

pub fn transform_with_only_writable_strategy_test() {
  let assert Ok(_stream) =
    transform_stream.new()
    |> transform_stream.with_writable_strategy(stream.Unlimited)
    |> transform_stream.build
}
