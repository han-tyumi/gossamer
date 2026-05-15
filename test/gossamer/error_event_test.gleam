import gleam/option.{Some}
import gleeunit/should
import gossamer/error_event.{type ErrorEvent}

@external(javascript, "./error_event_test.ffi.mjs", "make_full")
fn make_full() -> ErrorEvent

@external(javascript, "./error_event_test.ffi.mjs", "make_empty")
fn make_empty() -> ErrorEvent

pub fn info_full_test() {
  let info = error_event.info(make_full())
  info.message |> should.equal("boom")
  info.filename |> should.equal("test.js")
  info.lineno |> should.equal(42)
  info.colno |> should.equal(7)
  let assert Some(_) = info.error
}

pub fn info_empty_test() {
  let info = error_event.info(make_empty())
  info.message |> should.equal("")
  info.filename |> should.equal("")
  info.lineno |> should.equal(0)
  info.colno |> should.equal(0)
  info.error |> should.be_none
}
