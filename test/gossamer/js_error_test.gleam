import gleam/dynamic/decode
import gleeunit/should
import gossamer
import gossamer/js_error
import gossamer/js_error/kind
import gossamer/promise

pub fn new_test() {
  let err = js_error.new("something went wrong")
  js_error.name(err) |> should.equal("Error")
  js_error.message(err) |> should.equal("something went wrong")
}

pub fn type_error_test() {
  let err = js_error.type_error("invalid type")
  js_error.name(err) |> should.equal("TypeError")
  js_error.message(err) |> should.equal("invalid type")
}

pub fn range_error_test() {
  let err = js_error.range_error("out of range")
  js_error.name(err) |> should.equal("RangeError")
  js_error.message(err) |> should.equal("out of range")
}

pub fn reference_error_test() {
  let err = js_error.reference_error("not defined")
  js_error.name(err) |> should.equal("ReferenceError")
  js_error.message(err) |> should.equal("not defined")
}

pub fn syntax_error_test() {
  let err = js_error.syntax_error("unexpected token")
  js_error.name(err) |> should.equal("SyntaxError")
  js_error.message(err) |> should.equal("unexpected token")
}

pub fn uri_error_test() {
  let err = js_error.uri_error("malformed URI")
  js_error.name(err) |> should.equal("URIError")
  js_error.message(err) |> should.equal("malformed URI")
}

pub fn eval_error_test() {
  let err = js_error.eval_error("eval failed")
  js_error.name(err) |> should.equal("EvalError")
  js_error.message(err) |> should.equal("eval failed")
}

pub fn stack_test() {
  let err = js_error.new("stack test")
  js_error.stack(err) |> should.be_ok
}

pub fn cause_no_cause_test() {
  let err = js_error.new("no cause")
  js_error.cause(err) |> should.be_error
}

pub fn new_with_cause_test() {
  let err = js_error.new_with_cause("wrapped", cause: "root reason")
  js_error.message(err) |> should.equal("wrapped")
  let assert Ok(cause) = js_error.cause(err)
  let assert Ok(value) = decode.run(cause, decode.string)
  should.equal(value, "root reason")
}

pub fn type_error_with_cause_test() {
  let err = js_error.type_error_with_cause("bad type", cause: 42)
  js_error.name(err) |> should.equal("TypeError")
  let assert Ok(cause) = js_error.cause(err)
  let assert Ok(value) = decode.run(cause, decode.int)
  should.equal(value, 42)
}

pub fn range_error_with_cause_test() {
  let err = js_error.range_error_with_cause("out of range", cause: "too big")
  js_error.name(err) |> should.equal("RangeError")
  js_error.cause(err) |> should.be_ok
}

pub fn reference_error_with_cause_test() {
  let err = js_error.reference_error_with_cause("not defined", cause: "scope")
  js_error.name(err) |> should.equal("ReferenceError")
  js_error.cause(err) |> should.be_ok
}

pub fn syntax_error_with_cause_test() {
  let err = js_error.syntax_error_with_cause("unexpected", cause: "at line 5")
  js_error.name(err) |> should.equal("SyntaxError")
  js_error.cause(err) |> should.be_ok
}

pub fn uri_error_with_cause_test() {
  let err = js_error.uri_error_with_cause("malformed", cause: "missing scheme")
  js_error.name(err) |> should.equal("URIError")
  js_error.cause(err) |> should.be_ok
}

pub fn eval_error_with_cause_test() {
  let err = js_error.eval_error_with_cause("eval failed", cause: "sandboxed")
  js_error.name(err) |> should.equal("EvalError")
  js_error.cause(err) |> should.be_ok
}

pub fn kind_type_error_test() {
  js_error.type_error("bad")
  |> js_error.kind
  |> should.equal(kind.TypeError)
}

pub fn kind_range_error_test() {
  js_error.range_error("oob")
  |> js_error.kind
  |> should.equal(kind.RangeError)
}

pub fn kind_reference_error_test() {
  js_error.reference_error("undef")
  |> js_error.kind
  |> should.equal(kind.ReferenceError)
}

pub fn kind_syntax_error_test() {
  js_error.syntax_error("oops")
  |> js_error.kind
  |> should.equal(kind.SyntaxError)
}

pub fn kind_uri_error_test() {
  js_error.uri_error("bad uri")
  |> js_error.kind
  |> should.equal(kind.UriError)
}

pub fn kind_eval_error_test() {
  js_error.eval_error("nope")
  |> js_error.kind
  |> should.equal(kind.EvalError)
}

pub fn kind_other_for_plain_error_test() {
  js_error.new("generic")
  |> js_error.kind
  |> should.equal(kind.Other(name: "Error"))
}

pub fn kind_dom_exception_test() {
  let assert Error(err) = gossamer.atob("not valid base64!")
  js_error.kind(err)
  |> should.equal(kind.DomException(name: "InvalidCharacterError"))
}

pub fn kind_aggregate_error_test() {
  // promise.any rejects with an AggregateError when every input rejects.
  use result <- promise.then(
    promise.any([promise.reject("err1"), promise.reject("err2")]),
  )
  let assert Error(err) = result
  js_error.kind(err) |> should.equal(kind.AggregateError)
  promise.resolve(Nil)
}

pub fn non_error_throw_preserves_original_via_cause_test() {
  // When JS code throws a non-Error value, the FFI wraps it in an Error
  // whose message is the stringified value and whose cause carries the
  // original, so inspecting `cause` retrieves the original.
  use result <- promise.then(
    promise.new(fn(_resolve, reject) { reject("plain string") }),
  )
  let assert Error(err) = result
  js_error.message(err) |> should.equal("plain string")
  let assert Ok(cause) = js_error.cause(err)
  let assert Ok(value) = decode.run(cause, decode.string)
  should.equal(value, "plain string")
  promise.resolve(Nil)
}
