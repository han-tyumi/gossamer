import gleam/list
import gleeunit/should
import gossamer/intl

pub fn canonical_locales_normalizes_case_test() {
  intl.get_canonical_locales(["EN-US", "Fr"])
  |> should.equal(Ok(["en-US", "fr"]))
}

pub fn canonical_locales_dedupes_test() {
  intl.get_canonical_locales(["en-US", "EN-us", "en-US"])
  |> should.equal(Ok(["en-US"]))
}

pub fn canonical_locales_empty_test() {
  intl.get_canonical_locales([]) |> should.equal(Ok([]))
}

pub fn canonical_locales_invalid_tag_test() {
  intl.get_canonical_locales(["not_a_locale!"]) |> should.be_error
}

pub fn supported_values_of_calendar_test() {
  let calendars = intl.supported_values_of(intl.Calendar)
  list.contains(calendars, "gregory") |> should.be_true
  list.contains(calendars, "buddhist") |> should.be_true
}

pub fn supported_values_of_currency_test() {
  let currencies = intl.supported_values_of(intl.Currency)
  list.contains(currencies, "USD") |> should.be_true
  list.contains(currencies, "EUR") |> should.be_true
}

pub fn supported_values_of_numbering_system_test() {
  let systems = intl.supported_values_of(intl.NumberingSystem)
  list.contains(systems, "latn") |> should.be_true
}

pub fn supported_values_of_time_zone_test() {
  let zones = intl.supported_values_of(intl.TimeZone)
  list.contains(zones, "America/New_York") |> should.be_true
  list.contains(zones, "Europe/London") |> should.be_true
}

pub fn supported_values_of_unit_test() {
  let units = intl.supported_values_of(intl.Unit)
  list.contains(units, "meter") |> should.be_true
  list.contains(units, "hour") |> should.be_true
}

pub fn supported_values_of_collation_test() {
  let collations = intl.supported_values_of(intl.Collation)
  list.contains(collations, "compat") |> should.be_true
  list.contains(collations, "phonebk") |> should.be_true
}
