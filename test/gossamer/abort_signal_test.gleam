import gleam/dynamic/decode
import gleeunit/should
import gossamer/abort_controller
import gossamer/abort_signal
import gossamer/promise

pub fn abort_creates_aborted_signal_test() {
  let signal = abort_signal.abort("cancelled")
  abort_signal.is_aborted(signal) |> should.be_true
}

pub fn timeout_creates_unaborted_signal_test() {
  let signal = abort_signal.timeout(10_000)
  abort_signal.is_aborted(signal) |> should.be_false
}

pub fn reason_on_aborted_signal_test() {
  let signal = abort_signal.abort("the reason")
  let assert Ok(reason) = abort_signal.reason(signal)
  let assert Ok(value) = decode.run(reason, decode.string)
  should.equal(value, "the reason")
}

pub fn reason_on_unaborted_signal_test() {
  let signal = abort_signal.timeout(10_000)
  abort_signal.reason(signal) |> should.be_error
}

pub fn throw_if_aborted_on_aborted_test() {
  let signal = abort_signal.abort("stopped")
  abort_signal.throw_if_aborted(signal) |> should.be_error
}

pub fn throw_if_aborted_on_unaborted_test() {
  let signal = abort_signal.timeout(10_000)
  abort_signal.throw_if_aborted(signal) |> should.be_ok
}

pub fn on_abort_test() {
  let controller = abort_controller.new()
  let signal = abort_controller.signal(controller)

  let resolvers = promise.with_resolvers()

  abort_signal.on_abort(signal, fn() {
    resolvers.resolve("aborted")
    Nil
  })

  abort_controller.abort(controller)

  use value <- promise.then(resolvers.promise)
  should.equal(value, Ok("aborted"))
  promise.resolve(Nil)
}

pub fn any_test() {
  let signal1 = abort_signal.abort("first")
  let signal2 = abort_signal.timeout(10_000)
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
