import gleam/list
import gleeunit/should
import gossamer/intl

pub fn canonical_locales_normalizes_case_test() {
  intl.canonical_locales(["EN-US", "Fr"])
  |> should.equal(Ok(["en-US", "fr"]))
}

pub fn canonical_locales_dedupes_test() {
  intl.canonical_locales(["en-US", "EN-us", "en-US"])
  |> should.equal(Ok(["en-US"]))
}

pub fn canonical_locales_empty_test() {
  intl.canonical_locales([]) |> should.equal(Ok([]))
}

pub fn canonical_locales_invalid_tag_test() {
  intl.canonical_locales(["not_a_locale!"]) |> should.be_error
}

pub fn calendars_test() {
  let supported = intl.calendars()
  list.contains(supported, "gregory") |> should.be_true
  list.contains(supported, "buddhist") |> should.be_true
}

pub fn currencies_test() {
  let supported = intl.currencies()
  list.contains(supported, "USD") |> should.be_true
  list.contains(supported, "EUR") |> should.be_true
}

pub fn numbering_systems_test() {
  let supported = intl.numbering_systems()
  list.contains(supported, "latn") |> should.be_true
}

pub fn time_zones_test() {
  let supported = intl.time_zones()
  list.contains(supported, "America/New_York") |> should.be_true
  list.contains(supported, "Europe/London") |> should.be_true
}

pub fn units_test() {
  let supported = intl.units()
  list.contains(supported, "meter") |> should.be_true
  list.contains(supported, "hour") |> should.be_true
}

pub fn collations_test() {
  let supported = intl.collations()
  list.contains(supported, "compat") |> should.be_true
  list.contains(supported, "phonebk") |> should.be_true
}
