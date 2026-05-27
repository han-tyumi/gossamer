import gleam/list
import gleeunit/should
import gossamer/intl
import gossamer/intl/plural_rules

pub fn build_default_test() {
  plural_rules.new([]) |> plural_rules.build |> should.be_ok
}

pub fn build_single_locale_test() {
  plural_rules.new(["en-US"]) |> plural_rules.build |> should.be_ok
}

pub fn build_invalid_locale_test() {
  plural_rules.new(["not_a_locale!"])
  |> plural_rules.build
  |> should.be_error
}

pub fn build_invalid_rounding_increment_test() {
  plural_rules.new(["en-US"])
  |> plural_rules.with_rounding_increment(3)
  |> plural_rules.build
  |> should.be_error
}

pub fn build_ordinal_test() {
  plural_rules.new(["en-US"])
  |> plural_rules.with_kind(plural_rules.Ordinal)
  |> plural_rules.build
  |> should.be_ok
}

pub fn select_one_test() {
  let assert Ok(rules) = plural_rules.new(["en-US"]) |> plural_rules.build
  plural_rules.select_int(rules, 1) |> should.equal(plural_rules.One)
}

pub fn select_other_test() {
  let assert Ok(rules) = plural_rules.new(["en-US"]) |> plural_rules.build
  plural_rules.select_int(rules, 5) |> should.equal(plural_rules.Other)
}

pub fn select_float_test() {
  let assert Ok(rules) = plural_rules.new(["en-US"]) |> plural_rules.build
  // Fractional cardinals are always Other in English.
  plural_rules.select_float(rules, 1.5)
  |> should.equal(plural_rules.Other)
}

pub fn select_ordinal_test() {
  let assert Ok(rules) =
    plural_rules.new(["en-US"])
    |> plural_rules.with_kind(plural_rules.Ordinal)
    |> plural_rules.build
  // English ordinals: 1st (one), 2nd (two), 3rd (few), 4th (other).
  plural_rules.select_int(rules, 1) |> should.equal(plural_rules.One)
  plural_rules.select_int(rules, 2) |> should.equal(plural_rules.Two)
  plural_rules.select_int(rules, 3) |> should.equal(plural_rules.Few)
  plural_rules.select_int(rules, 4) |> should.equal(plural_rules.Other)
}

pub fn select_arabic_test() {
  let assert Ok(rules) = plural_rules.new(["ar"]) |> plural_rules.build
  // Arabic uses Zero, One, Two, Few, Many, Other.
  plural_rules.select_int(rules, 0) |> should.equal(plural_rules.Zero)
  plural_rules.select_int(rules, 1) |> should.equal(plural_rules.One)
  plural_rules.select_int(rules, 2) |> should.equal(plural_rules.Two)
}

pub fn select_with_min_fraction_digits_test() {
  let assert Ok(rules) =
    plural_rules.new(["en-US"])
    |> plural_rules.with_minimum_fraction_digits(1)
    |> plural_rules.build
  // 1.0 with minFraction=1 displays as "1.0", which is Other in English.
  plural_rules.select_int(rules, 1) |> should.equal(plural_rules.Other)
}

pub fn select_with_rounding_mode_test() {
  let assert Ok(rules) =
    plural_rules.new(["en-US"])
    |> plural_rules.with_maximum_fraction_digits(0)
    |> plural_rules.with_rounding_mode(intl.RoundingModeFloor)
    |> plural_rules.build
  // 1.9 with floor rounding becomes 1 (One in English).
  plural_rules.select_float(rules, 1.9) |> should.equal(plural_rules.One)
}

pub fn select_range_test() {
  let assert Ok(rules) = plural_rules.new(["en-US"]) |> plural_rules.build
  plural_rules.select_int_range(rules, from: 1, to: 5)
  |> should.equal(plural_rules.Other)
}

pub fn resolved_options_test() {
  let assert Ok(rules) =
    plural_rules.new(["en"])
    |> plural_rules.with_kind(plural_rules.Ordinal)
    |> plural_rules.build
  let options = plural_rules.resolved_options(rules)
  options.locale |> should.equal("en")
  options.kind |> should.equal(plural_rules.Ordinal)
  options.minimum_integer_digits |> should.equal(1)
  list.contains(options.plural_categories, plural_rules.Other) |> should.be_true
}

pub fn supported_locales_of_test() {
  plural_rules.supported_locales_of(["en-US", "zz-INVALID"])
  |> should.equal(["en-US"])
}
