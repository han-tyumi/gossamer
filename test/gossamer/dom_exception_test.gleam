import gleeunit/should
import gossamer/dom_exception

pub fn new_test() {
  let exception = dom_exception.new("test message", "TestError")
  dom_exception.message(exception) |> should.equal("test message")
  dom_exception.name(exception) |> should.equal("TestError")
}

pub fn code_known_name_test() {
  let exception = dom_exception.new("not found", "NotFoundError")
  dom_exception.code(exception) |> should.equal(8)
}

pub fn code_unknown_name_test() {
  let exception = dom_exception.new("custom", "CustomError")
  dom_exception.code(exception) |> should.equal(0)
}

pub fn abort_error_test() {
  let exception = dom_exception.new("aborted", "AbortError")
  dom_exception.name(exception) |> should.equal("AbortError")
  dom_exception.code(exception) |> should.equal(20)
}
