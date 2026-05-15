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
  collator.compare(c, "apple", to: "banana") |> should.equal(order.Lt)
}

pub fn compare_gt_test() {
  let assert Ok(c) = collator.new(["en-US"]) |> collator.build
  collator.compare(c, "banana", to: "apple") |> should.equal(order.Gt)
}

pub fn compare_eq_test() {
  let assert Ok(c) = collator.new(["en-US"]) |> collator.build
  collator.compare(c, "apple", to: "apple") |> should.equal(order.Eq)
}

pub fn numeric_sort_test() {
  let assert Ok(c) =
    collator.new(["en-US"])
    |> collator.with_numeric(True)
    |> collator.build
  collator.compare(c, "foo2", to: "foo10") |> should.equal(order.Lt)
}

pub fn case_sensitivity_base_test() {
  let assert Ok(c) =
    collator.new(["en-US"])
    |> collator.with_sensitivity(collator.Base)
    |> collator.build
  collator.compare(c, "apple", to: "APPLE") |> should.equal(order.Eq)
}

pub fn case_first_upper_test() {
  let assert Ok(c) =
    collator.new(["en-US"])
    |> collator.with_case_first(intl.Upper)
    |> collator.build
  collator.compare(c, "Apple", to: "apple") |> should.equal(order.Lt)
}

pub fn case_first_lower_test() {
  let assert Ok(c) =
    collator.new(["en-US"])
    |> collator.with_case_first(intl.Lower)
    |> collator.build
  collator.compare(c, "apple", to: "Apple") |> should.equal(order.Lt)
}

pub fn sort_via_list_test() {
  let assert Ok(c) = collator.new(["en-US"]) |> collator.build
  ["banana", "apple", "cherry"]
  |> list.sort(by: fn(a, b) { collator.compare(c, a, to: b) })
  |> should.equal(["apple", "banana", "cherry"])
}

pub fn resolved_locale_test() {
  let assert Ok(c) = collator.new(["en-US"]) |> collator.build
  collator.resolved_locale(c) |> should.equal("en-US")
}

pub fn supported_locales_of_test() {
  collator.supported_locales_of(["en-US", "zz-INVALID"])
  |> should.equal(["en-US"])
}
