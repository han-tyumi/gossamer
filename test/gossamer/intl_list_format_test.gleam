import gleeunit/should
import gossamer/intl
import gossamer/intl/list_format

pub fn build_default_test() {
  list_format.new([]) |> list_format.build |> should.be_ok
}

pub fn build_invalid_locale_test() {
  list_format.new(["not_a_locale!"])
  |> list_format.build
  |> should.be_error
}

pub fn format_conjunction_test() {
  let assert Ok(formatter) = list_format.new(["en-US"]) |> list_format.build
  list_format.format(formatter, ["apple", "banana", "cherry"])
  |> should.equal("apple, banana, and cherry")
}

pub fn format_disjunction_test() {
  let assert Ok(formatter) =
    list_format.new(["en-US"])
    |> list_format.with_kind(list_format.Disjunction)
    |> list_format.build
  list_format.format(formatter, ["apple", "banana", "cherry"])
  |> should.equal("apple, banana, or cherry")
}

pub fn format_unit_test() {
  let assert Ok(formatter) =
    list_format.new(["en-US"])
    |> list_format.with_kind(list_format.Unit)
    |> list_format.build
  list_format.format(formatter, ["5 hours", "10 minutes"])
  |> should.equal("5 hours, 10 minutes")
}

pub fn format_short_style_test() {
  let assert Ok(formatter) =
    list_format.new(["en-US"])
    |> list_format.with_style(intl.Short)
    |> list_format.build
  list_format.format(formatter, ["apple", "banana", "cherry"])
  |> should.equal("apple, banana, & cherry")
}

pub fn format_narrow_style_unit_test() {
  let assert Ok(formatter) =
    list_format.new(["en-US"])
    |> list_format.with_kind(list_format.Unit)
    |> list_format.with_style(intl.Narrow)
    |> list_format.build
  list_format.format(formatter, ["5h", "10m"])
  |> should.equal("5h 10m")
}

pub fn format_empty_list_test() {
  let assert Ok(formatter) = list_format.new(["en-US"]) |> list_format.build
  list_format.format(formatter, []) |> should.equal("")
}

pub fn format_single_element_test() {
  let assert Ok(formatter) = list_format.new(["en-US"]) |> list_format.build
  list_format.format(formatter, ["apple"]) |> should.equal("apple")
}

pub fn format_to_parts_test() {
  let assert Ok(formatter) = list_format.new(["en-US"]) |> list_format.build
  let parts =
    list_format.format_to_parts(formatter, ["apple", "banana", "cherry"])
  case parts {
    [first, ..] -> first.kind |> should.equal(list_format.Element)
    [] -> panic as "expected non-empty parts"
  }
}

pub fn resolved_locale_test() {
  let assert Ok(formatter) = list_format.new(["en-US"]) |> list_format.build
  list_format.resolved_locale(formatter) |> should.equal("en-US")
}

pub fn locale_matcher_lookup_test() {
  let assert Ok(formatter) =
    list_format.new(["en-US"])
    |> list_format.with_locale_matcher(intl.Lookup)
    |> list_format.build
  list_format.format(formatter, ["apple", "banana", "cherry"])
  |> should.equal("apple, banana, and cherry")
}

pub fn locale_matcher_best_fit_test() {
  let assert Ok(formatter) =
    list_format.new(["en-US"])
    |> list_format.with_locale_matcher(intl.BestFit)
    |> list_format.build
  list_format.format(formatter, ["apple", "banana", "cherry"])
  |> should.equal("apple, banana, and cherry")
}

pub fn supported_locales_of_test() {
  list_format.supported_locales_of(["en-US", "zz-INVALID"])
  |> should.equal(["en-US"])
}
