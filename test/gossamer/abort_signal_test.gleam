import gleam/dynamic/decode
import gleam/javascript/promise
import gleam/time/duration
import gleeunit/should
import gossamer/abort_controller
import gossamer/abort_signal

pub fn abort_creates_aborted_signal_test() {
  let signal = abort_signal.abort("cancelled")
  abort_signal.is_aborted(signal) |> should.be_true
}

pub fn timeout_creates_unaborted_signal_test() {
  let signal = abort_signal.timeout(duration.seconds(10))
  abort_signal.is_aborted(signal) |> should.be_false
}

pub fn timeout_negative_clamps_to_zero_test() {
  let signal = abort_signal.timeout(duration.milliseconds(-1))
  abort_signal.is_aborted(signal) |> should.be_false
}

pub fn reason_on_aborted_signal_test() {
  let signal = abort_signal.abort("the reason")
  let assert Ok(reason) = abort_signal.reason(signal)
  let assert Ok(value) = decode.run(reason, decode.string)
  should.equal(value, "the reason")
}

pub fn reason_on_unaborted_signal_test() {
  let signal = abort_signal.timeout(duration.seconds(10))
  abort_signal.reason(signal) |> should.be_error
}

pub fn throw_if_aborted_on_aborted_test() {
  let signal = abort_signal.abort("stopped")
  let assert Error(reason) = abort_signal.throw_if_aborted(signal)
  let assert Ok(value) = decode.run(reason, decode.string)
  should.equal(value, "stopped")
}

pub fn throw_if_aborted_on_unaborted_test() {
  let signal = abort_signal.timeout(duration.seconds(10))
  abort_signal.throw_if_aborted(signal) |> should.be_ok
}

pub fn on_abort_test() {
  let controller = abort_controller.new()
  let signal = abort_controller.signal(controller)

  let #(p, resolve) = promise.start()

  abort_signal.on_abort(signal, fn() {
    resolve("aborted")
    Nil
  })

  abort_controller.abort(controller)

  use value <- promise.map(p)
  should.equal(value, "aborted")
}

pub fn any_test() {
  let signal1 = abort_signal.abort("first")
  let signal2 = abort_signal.timeout(duration.seconds(10))
  let combined = abort_signal.any([signal1, signal2])
  abort_signal.is_aborted(combined) |> should.be_true
}

pub fn controller_abort_test() {
  let controller = abort_controller.new()
  let signal = abort_controller.signal(controller)
  abort_signal.is_aborted(signal) |> should.be_false
  abort_controller.abort(controller)
  abort_signal.is_aborted(signal) |> should.be_true
}

pub fn controller_abort_with_test() {
  let controller = abort_controller.new()
  let signal = abort_controller.signal(controller)
  abort_controller.abort_with(controller, "custom reason")
  abort_signal.is_aborted(signal) |> should.be_true
  let assert Ok(reason) = abort_signal.reason(signal)
  let assert Ok(value) = decode.run(reason, decode.string)
  should.equal(value, "custom reason")
}
