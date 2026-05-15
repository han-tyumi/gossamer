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

pub fn to_locale_lower_case_default_test() {
  string_extra.to_locale_lower_case("HELLO", in: [])
  |> should.equal(Ok("hello"))
}

pub fn to_locale_lower_case_turkish_test() {
  // Turkish lowercases "I" to dotless "ı" rather than "i".
  string_extra.to_locale_lower_case("I", in: ["tr"]) |> should.equal(Ok("ı"))
}

pub fn to_locale_lower_case_invalid_locale_test() {
  string_extra.to_locale_lower_case("HELLO", in: ["not_a_locale!"])
  |> should.be_error
}

pub fn to_locale_upper_case_default_test() {
  string_extra.to_locale_upper_case("hello", in: [])
  |> should.equal(Ok("HELLO"))
}

pub fn to_locale_upper_case_turkish_test() {
  // Turkish uppercases "i" to dotted "İ" rather than "I".
  string_extra.to_locale_upper_case("i", in: ["tr"]) |> should.equal(Ok("İ"))
}

pub fn to_locale_upper_case_invalid_locale_test() {
  string_extra.to_locale_upper_case("hello", in: ["not_a_locale!"])
  |> should.be_error
}

pub fn is_well_formed_test() {
  string_extra.is_well_formed("hello") |> should.be_true
}

pub fn to_well_formed_test() {
  string_extra.to_well_formed("hello") |> should.equal("hello")
}
