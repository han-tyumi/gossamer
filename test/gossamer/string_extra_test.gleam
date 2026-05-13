import gleam/order
import gleeunit/should
import gossamer/string_extra

pub fn normalize_test() {
  let nfd = "e\u{0301}"
  string_extra.normalize(nfd) |> should.equal("é")
}

pub fn normalize_to_test() {
  let nfc = "é"
  let nfd = "e\u{0301}"
  string_extra.normalize_to(nfd, form: string_extra.Nfc) |> should.equal(nfc)
  string_extra.normalize_to(nfc, form: string_extra.Nfd) |> should.equal(nfd)
}

pub fn locale_compare_test() {
  string_extra.locale_compare("apple", "banana") |> should.equal(order.Lt)
  string_extra.locale_compare("banana", "apple") |> should.equal(order.Gt)
  string_extra.locale_compare("apple", "apple") |> should.equal(order.Eq)
}

pub fn to_locale_lower_case_test() {
  string_extra.to_locale_lower_case("HELLO") |> should.equal("hello")
}

pub fn to_locale_upper_case_test() {
  string_extra.to_locale_upper_case("hello") |> should.equal("HELLO")
}

pub fn is_well_formed_test() {
  string_extra.is_well_formed("hello") |> should.be_true
}

pub fn to_well_formed_test() {
  string_extra.to_well_formed("hello") |> should.equal("hello")
}
