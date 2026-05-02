import gleam/dynamic/decode
import gleam/option
import gleeunit/should
import gossamer/error_event
import gossamer/event
import gossamer/js_error

pub fn new_test() {
  let ev = error_event.new("error")
  ev |> error_event.to_event |> event.type_ |> should.equal("error")
}

pub fn new_default_fields_test() {
  let ev = error_event.new("error")
  error_event.message(ev) |> should.equal("")
  error_event.filename(ev) |> should.equal("")
  error_event.lineno(ev) |> should.equal(0)
  error_event.colno(ev) |> should.equal(0)
  error_event.error(ev) |> should.be_error()
}

pub fn new_with_message_test() {
  let ev = error_event.new_with("error", [error_event.Message("boom")])
  error_event.message(ev) |> should.equal("boom")
}

pub fn new_with_all_fields_test() {
  let ev =
    error_event.new_with("error", [
      error_event.Message("boom"),
      error_event.Filename("foo.js"),
      error_event.Lineno(10),
      error_event.Colno(5),
    ])
  error_event.message(ev) |> should.equal("boom")
  error_event.filename(ev) |> should.equal("foo.js")
  error_event.lineno(ev) |> should.equal(10)
  error_event.colno(ev) |> should.equal(5)
}

pub fn new_with_error_value_test() {
  let cause = js_error.new("inner")
  let ev = error_event.new_with("error", [error_event.Value(cause)])
  let assert Ok(error_dynamic) = error_event.error(ev)
  let assert Ok(message) =
    decode.run(error_dynamic, decode.at(["message"], decode.string))
  message |> should.equal("inner")
  let assert option.Some(_) = error_event.to_fields(ev).error
}

pub fn new_with_event_init_test() {
  let ev =
    error_event.new_with("error", [
      error_event.Bubbles(True),
      error_event.Cancelable(True),
    ])
  let base = error_event.to_event(ev)
  event.is_bubbles(base) |> should.be_true()
  event.is_cancelable(base) |> should.be_true()
}

pub fn to_fields_test() {
  let ev =
    error_event.new_with("error", [
      error_event.Message("boom"),
      error_event.Filename("foo.js"),
      error_event.Lineno(10),
      error_event.Colno(5),
    ])
  let fields = error_event.to_fields(ev)
  fields.message |> should.equal("boom")
  fields.filename |> should.equal("foo.js")
  fields.lineno |> should.equal(10)
  fields.colno |> should.equal(5)
  fields.error |> should.equal(option.None)
}
