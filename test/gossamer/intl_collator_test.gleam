import gleam/list
import gleam/order
import gleeunit/should
import gossamer/intl
import gossamer/intl/collator

pub fn build_default_test() {
  collator.new([]) |> collator.build |> should.be_ok
}

pub fn build_single_locale_test() {
  collator.new(["en-US"]) |> collator.build |> should.be_ok
}

pub fn build_locale_fallback_chain_test() {
  collator.new(["zz-INVALID", "en-US"]) |> collator.build |> should.be_ok
}

pub fn build_invalid_locale_test() {
  collator.new(["not_a_locale!"]) |> collator.build |> should.be_error
}

pub fn compare_lt_test() {
  let assert Ok(c) = collator.new(["en-US"]) |> collator.build
  collator.compare(c, "apple", "banana") |> should.equal(order.Lt)
}

pub fn compare_gt_test() {
  let assert Ok(c) = collator.new(["en-US"]) |> collator.build
  collator.compare(c, "banana", "apple") |> should.equal(order.Gt)
}

pub fn compare_eq_test() {
  let assert Ok(c) = collator.new(["en-US"]) |> collator.build
  collator.compare(c, "apple", "apple") |> should.equal(order.Eq)
}

pub fn numeric_sort_test() {
  let assert Ok(c) =
    collator.new(["en-US"])
    |> collator.with_numeric(True)
    |> collator.build
  collator.compare(c, "foo2", "foo10") |> should.equal(order.Lt)
}

pub fn case_sensitivity_base_test() {
  let assert Ok(c) =
    collator.new(["en-US"])
    |> collator.with_sensitivity(collator.Base)
    |> collator.build
  collator.compare(c, "apple", "APPLE") |> should.equal(order.Eq)
}

pub fn case_first_upper_test() {
  let assert Ok(c) =
    collator.new(["en-US"])
    |> collator.with_case_first(intl.Upper)
    |> collator.build
  collator.compare(c, "Apple", "apple") |> should.equal(order.Lt)
}

pub fn case_first_lower_test() {
  let assert Ok(c) =
    collator.new(["en-US"])
    |> collator.with_case_first(intl.Lower)
    |> collator.build
  collator.compare(c, "apple", "Apple") |> should.equal(order.Lt)
}

pub fn sort_via_list_test() {
  let assert Ok(c) = collator.new(["en-US"]) |> collator.build
  ["banana", "apple", "cherry"]
  |> list.sort(by: fn(a, b) { collator.compare(c, a, b) })
  |> should.equal(["apple", "banana", "cherry"])
}

pub fn resolved_options_test() {
  let assert Ok(c) =
    collator.new(["en-US"])
    |> collator.with_usage(collator.Search)
    |> collator.with_sensitivity(collator.Base)
    |> collator.with_numeric(True)
    |> collator.build
  let options = collator.resolved_options(c)
  options.locale |> should.equal("en-US")
  options.usage |> should.equal(collator.Search)
  options.sensitivity |> should.equal(collator.Base)
  options.numeric |> should.equal(True)
}

pub fn supported_locales_of_test() {
  collator.supported_locales_of(["en-US", "zz-INVALID"])
  |> should.equal(Ok(["en-US"]))
}

pub fn supported_locales_of_malformed_tag_test() {
  collator.supported_locales_of(["not_a_locale!"])
  |> should.be_error
}
