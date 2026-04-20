import gleam/dynamic/decode
import gleeunit/should
import gossamer/error

pub fn new_test() {
  let err = error.new("something went wrong")
  error.name(err) |> should.equal("Error")
  error.message(err) |> should.equal("something went wrong")
}

pub fn type_error_test() {
  let err = error.type_error("invalid type")
  error.name(err) |> should.equal("TypeError")
  error.message(err) |> should.equal("invalid type")
}

pub fn range_error_test() {
  let err = error.range_error("out of range")
  error.name(err) |> should.equal("RangeError")
  error.message(err) |> should.equal("out of range")
}

pub fn reference_error_test() {
  let err = error.reference_error("not defined")
  error.name(err) |> should.equal("ReferenceError")
  error.message(err) |> should.equal("not defined")
}

pub fn syntax_error_test() {
  let err = error.syntax_error("unexpected token")
  error.name(err) |> should.equal("SyntaxError")
  error.message(err) |> should.equal("unexpected token")
}

pub fn uri_error_test() {
  let err = error.uri_error("malformed URI")
  error.name(err) |> should.equal("URIError")
  error.message(err) |> should.equal("malformed URI")
}

pub fn eval_error_test() {
  let err = error.eval_error("eval failed")
  error.name(err) |> should.equal("EvalError")
  error.message(err) |> should.equal("eval failed")
}

pub fn stack_test() {
  let err = error.new("stack test")
  error.stack(err) |> should.be_ok
}

pub fn cause_no_cause_test() {
  let err = error.new("no cause")
  error.cause(err) |> should.be_error
}

pub fn new_with_cause_test() {
  let err = error.new_with_cause("wrapped", cause: "root reason")
  error.message(err) |> should.equal("wrapped")
  let assert Ok(cause) = error.cause(err)
  let assert Ok(value) = decode.run(cause, decode.string)
  should.equal(value, "root reason")
}

pub fn type_error_with_cause_test() {
  let err = error.type_error_with_cause("bad type", cause: 42)
  error.name(err) |> should.equal("TypeError")
  let assert Ok(cause) = error.cause(err)
  let assert Ok(value) = decode.run(cause, decode.int)
  should.equal(value, 42)
}

pub fn range_error_with_cause_test() {
  let err = error.range_error_with_cause("out of range", cause: "too big")
  error.name(err) |> should.equal("RangeError")
  error.cause(err) |> should.be_ok
}

pub fn reference_error_with_cause_test() {
  let err = error.reference_error_with_cause("not defined", cause: "scope")
  error.name(err) |> should.equal("ReferenceError")
  error.cause(err) |> should.be_ok
}

pub fn syntax_error_with_cause_test() {
  let err = error.syntax_error_with_cause("unexpected", cause: "at line 5")
  error.name(err) |> should.equal("SyntaxError")
  error.cause(err) |> should.be_ok
}

pub fn uri_error_with_cause_test() {
  let err = error.uri_error_with_cause("malformed", cause: "missing scheme")
  error.name(err) |> should.equal("URIError")
  error.cause(err) |> should.be_ok
}

pub fn eval_error_with_cause_test() {
  let err = error.eval_error_with_cause("eval failed", cause: "sandboxed")
  error.name(err) |> should.equal("EvalError")
  error.cause(err) |> should.be_ok
}
