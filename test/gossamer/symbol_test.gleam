import gleeunit/should
import gossamer/symbol

pub fn new_test() {
  let sym = symbol.new()
  symbol.description(sym) |> should.be_error
}

pub fn new_with_test() {
  let sym = symbol.new_with(description: "my-symbol")
  symbol.description(sym) |> should.equal(Ok("my-symbol"))
}

pub fn new_with_empty_description_test() {
  let sym = symbol.new_with(description: "")
  symbol.description(sym) |> should.equal(Ok(""))
}

pub fn to_string_test() {
  let sym = symbol.new_with(description: "test")
  symbol.to_string(sym) |> should.equal("Symbol(test)")
}

pub fn to_string_no_description_test() {
  let sym = symbol.new()
  symbol.to_string(sym) |> should.equal("Symbol()")
}

pub fn for_test() {
  let a = symbol.for("my.key")
  let b = symbol.for("my.key")
  symbol.to_string(a) |> should.equal(symbol.to_string(b))
}

pub fn for_different_keys_test() {
  let a = symbol.for("key.a")
  let b = symbol.for("key.b")
  symbol.to_string(a) |> should.not_equal(symbol.to_string(b))
}

pub fn key_for_registry_symbol_test() {
  let sym = symbol.for("registry.key")
  symbol.key_for(sym) |> should.equal(Ok("registry.key"))
}

pub fn key_for_non_registry_symbol_test() {
  let sym = symbol.new()
  symbol.key_for(sym) |> should.be_error
}
