import gleam/dynamic
import gleam/dynamic/decode
import gleam/javascript/promise
import gleam/option.{None}
import gleam/time/duration
import gleeunit/should
import gossamer/abort_signal.{type AbortSignal, Default, Reason, Timeout}
import runtime

@external(javascript, "./abort_signal_test.ffi.mjs", "null_aborted_signal")
fn null_aborted_signal() -> AbortSignal

pub fn abort_creates_aborted_signal_test() {
  let signal = abort_signal.abort(Reason(dynamic.string("cancelled")))
  abort_signal.is_aborted(signal) |> should.be_true
}

pub fn abort_default_creates_aborted_signal_test() {
  let signal = abort_signal.abort(Default)
  abort_signal.is_aborted(signal) |> should.be_true
  let assert Ok(reason) = abort_signal.reason(signal)
  should.equal(reason, Default)
}

pub fn timeout_creates_unaborted_signal_test() {
  let signal = abort_signal.timeout(duration.seconds(10))
  abort_signal.is_aborted(signal) |> should.be_false
}

pub fn timeout_negative_clamps_to_zero_test() {
  let signal = abort_signal.timeout(duration.milliseconds(-1))
  abort_signal.is_aborted(signal) |> should.be_false
}

pub fn timeout_above_u32_max_test() {
  use <- runtime.skip_on(runtime.Node)
  let signal = abort_signal.timeout(duration.milliseconds(4_294_967_296))
  abort_signal.is_aborted(signal) |> should.be_false
}

/// Node rejects `AbortSignal.timeout` delays above the unsigned 32-bit
/// millisecond bound where Deno and Bun accept values up to
/// `9_007_199_254_740_991`.
pub fn timeout_above_u32_max_node_divergence_test() {
  use <- runtime.only_on(runtime.Node)
  runtime.catch_panic(fn() {
    abort_signal.timeout(duration.milliseconds(4_294_967_296))
  })
  |> should.be_error
}

pub fn reason_on_aborted_signal_test() {
  let signal = abort_signal.abort(Reason(dynamic.string("the reason")))
  let assert Ok(Reason(value)) = abort_signal.reason(signal)
  let assert Ok(message) = decode.run(value, decode.string)
  should.equal(message, "the reason")
}

pub fn reason_on_unaborted_signal_test() {
  let signal = abort_signal.timeout(duration.seconds(10))
  abort_signal.reason(signal) |> should.be_error
}

pub fn reason_on_null_aborted_signal_test() {
  let signal = null_aborted_signal()
  abort_signal.is_aborted(signal) |> should.be_true
  let assert Ok(Reason(value)) = abort_signal.reason(signal)
  decode.run(value, decode.optional(decode.string))
  |> should.equal(Ok(None))
}

pub fn on_abort_resolves_when_aborted_test() {
  let #(signal, abort) = abort_signal.new()
  let on_abort = abort_signal.on_abort(signal)
  abort(Reason(dynamic.string("aborted")))
  use reason <- promise.map(on_abort)
  let assert Reason(value) = reason
  let assert Ok(message) = decode.run(value, decode.string)
  should.equal(message, "aborted")
}

pub fn on_abort_resolves_immediately_when_already_aborted_test() {
  let signal = abort_signal.abort(Reason(dynamic.string("already")))
  use reason <- promise.map(abort_signal.on_abort(signal))
  let assert Reason(value) = reason
  let assert Ok(message) = decode.run(value, decode.string)
  should.equal(message, "already")
}

pub fn any_test() {
  let signal1 = abort_signal.abort(Reason(dynamic.string("first")))
  let signal2 = abort_signal.timeout(duration.seconds(10))
  let combined = abort_signal.any([signal1, signal2])
  abort_signal.is_aborted(combined) |> should.be_true
  let assert Ok(Reason(value)) = abort_signal.reason(combined)
  let assert Ok(message) = decode.run(value, decode.string)
  should.equal(message, "first")
}

pub fn any_timeout_classifies_as_timeout_test() {
  let signal1 = abort_signal.timeout(duration.milliseconds(0))
  let signal2 = abort_signal.timeout(duration.seconds(10))
  let combined = abort_signal.any([signal1, signal2])
  use reason <- promise.map(abort_signal.on_abort(combined))
  should.equal(reason, Timeout)
}

pub fn new_aborts_signal_with_default_test() {
  let #(signal, abort) = abort_signal.new()
  abort_signal.is_aborted(signal) |> should.be_false
  abort(Default)
  abort_signal.is_aborted(signal) |> should.be_true
  let assert Ok(reason) = abort_signal.reason(signal)
  should.equal(reason, Default)
}

pub fn new_with_reason_test() {
  let #(signal, abort) = abort_signal.new()
  abort(Reason(dynamic.string("custom reason")))
  abort_signal.is_aborted(signal) |> should.be_true
  let assert Ok(Reason(value)) = abort_signal.reason(signal)
  let assert Ok(message) = decode.run(value, decode.string)
  should.equal(message, "custom reason")
}

pub fn propagation_test() {
  let #(parent, abort_parent) = abort_signal.new()
  let #(child, abort_child) = abort_signal.new()

  abort_parent(Reason(dynamic.string("parent done")))

  use parent_reason <- promise.map(abort_signal.on_abort(parent))
  abort_child(parent_reason)
  let assert Ok(child_reason) = abort_signal.reason(child)
  should.equal(child_reason, parent_reason)
}
