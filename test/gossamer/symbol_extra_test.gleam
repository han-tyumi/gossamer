import gleam/javascript/symbol
import gleeunit/should
import gossamer/symbol_extra

pub fn anonymous_no_description_test() {
  symbol_extra.anonymous() |> symbol.description |> should.be_error
}

pub fn key_for_registry_symbol_test() {
  symbol.get_or_create_global("registry.key")
  |> symbol_extra.key_for
  |> should.equal(Ok("registry.key"))
}

pub fn key_for_non_registry_symbol_test() {
  symbol_extra.anonymous() |> symbol_extra.key_for |> should.be_error
}
