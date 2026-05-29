import gleeunit/should
import gossamer/string_extra

pub fn normalize_test() {
  let nfd = "e\u{0301}"
  string_extra.normalize(nfd) |> should.equal("é")
}

pub fn normalize_to_test() {
  let nfc = "é"
  let nfd = "e\u{0301}"
  string_extra.normalize_to(nfd, string_extra.Nfc) |> should.equal(nfc)
  string_extra.normalize_to(nfc, string_extra.Nfd) |> should.equal(nfd)
}

pub fn to_locale_lowercase_default_test() {
  string_extra.to_locale_lowercase("HELLO", [])
  |> should.equal(Ok("hello"))
}

pub fn to_locale_lowercase_turkish_test() {
  // Turkish lowercases "I" to dotless "ı" rather than "i".
  string_extra.to_locale_lowercase("I", ["tr"]) |> should.equal(Ok("ı"))
}

pub fn to_locale_lowercase_invalid_locale_test() {
  string_extra.to_locale_lowercase("HELLO", ["not_a_locale!"])
  |> should.be_error
}

pub fn to_locale_uppercase_default_test() {
  string_extra.to_locale_uppercase("hello", [])
  |> should.equal(Ok("HELLO"))
}

pub fn to_locale_uppercase_turkish_test() {
  // Turkish uppercases "i" to dotted "İ" rather than "I".
  string_extra.to_locale_uppercase("i", ["tr"]) |> should.equal(Ok("İ"))
}

pub fn to_locale_uppercase_invalid_locale_test() {
  string_extra.to_locale_uppercase("hello", ["not_a_locale!"])
  |> should.be_error
}

pub fn is_well_formed_test() {
  string_extra.is_well_formed("hello") |> should.be_true
}

pub fn to_well_formed_test() {
  string_extra.to_well_formed("hello") |> should.equal("hello")
}
