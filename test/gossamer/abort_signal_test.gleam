import gleam/dynamic/decode
import gleam/javascript/promise
import gleam/option.{None}
import gleam/time/duration
import gleeunit/should
import gossamer/abort_signal.{type AbortSignal}

@external(javascript, "./abort_signal_test.ffi.mjs", "null_aborted_signal")
fn null_aborted_signal() -> AbortSignal

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

pub fn reason_on_null_aborted_signal_test() {
  let signal = null_aborted_signal()
  abort_signal.is_aborted(signal) |> should.be_true
  let assert Ok(reason) = abort_signal.reason(signal)
  decode.run(reason, decode.optional(decode.string))
  |> should.equal(Ok(None))
}

pub fn on_abort_resolves_when_aborted_test() {
  let #(signal, abort) = abort_signal.new()
  let on_abort = abort_signal.on_abort(signal)
  abort("aborted")
  use reason <- promise.map(on_abort)
  let assert Ok(value) = decode.run(reason, decode.string)
  should.equal(value, "aborted")
}

pub fn on_abort_resolves_immediately_when_already_aborted_test() {
  let signal = abort_signal.abort("already")
  use reason <- promise.map(abort_signal.on_abort(signal))
  let assert Ok(value) = decode.run(reason, decode.string)
  should.equal(value, "already")
}

pub fn any_test() {
  let signal1 = abort_signal.abort("first")
  let signal2 = abort_signal.timeout(duration.seconds(10))
  let combined = abort_signal.any([signal1, signal2])
  abort_signal.is_aborted(combined) |> should.be_true
}

pub fn new_aborts_signal_test() {
  let #(signal, abort) = abort_signal.new()
  abort_signal.is_aborted(signal) |> should.be_false
  abort(Nil)
  abort_signal.is_aborted(signal) |> should.be_true
}

pub fn new_with_reason_test() {
  let #(signal, abort) = abort_signal.new()
  abort("custom reason")
  abort_signal.is_aborted(signal) |> should.be_true
  let assert Ok(reason) = abort_signal.reason(signal)
  let assert Ok(value) = decode.run(reason, decode.string)
  should.equal(value, "custom reason")
}
