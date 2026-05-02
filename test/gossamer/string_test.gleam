import gleam/order
import gleeunit/should
import gossamer/string
import gossamer/string/normalization_form

pub fn from_char_code_test() {
  string.from_char_code(65) |> should.equal("A")
}

pub fn from_char_codes_test() {
  string.from_char_codes([72, 101, 108, 108, 111]) |> should.equal("Hello")
}

pub fn from_code_point_test() {
  string.from_code_point(9731) |> should.equal(Ok("☃"))
}

pub fn from_code_point_invalid_test() {
  string.from_code_point(-1) |> should.be_error
}

pub fn from_code_points_test() {
  string.from_code_points([72, 101, 108, 108, 111])
  |> should.equal(Ok("Hello"))
}

pub fn from_code_points_invalid_test() {
  string.from_code_points([72, -1]) |> should.be_error
}

pub fn at_test() {
  string.at("hello", index: 0) |> should.equal(Ok("h"))
  string.at("hello", index: -1) |> should.equal(Ok("o"))
  string.at("hello", index: 99) |> should.be_error
}

pub fn char_code_at_test() {
  string.char_code_at("A", index: 0) |> should.equal(Ok(65))
  string.char_code_at("", index: 0) |> should.be_error
}

pub fn code_point_at_test() {
  string.code_point_at("☃", index: 0) |> should.equal(Ok(9731))
  string.code_point_at("", index: 0) |> should.be_error
}

pub fn normalize_test() {
  let composed = "é"
  let decomposed = "é"
  string.normalize(composed)
  |> should.equal(string.normalize(decomposed))
}

pub fn normalize_with_test() {
  let text = "é"
  let nfd = string.normalize_with(text, form: normalization_form.Nfd)
  let nfc = string.normalize_with(nfd, form: normalization_form.Nfc)
  nfc |> should.equal(string.normalize(text))
}

pub fn locale_compare_test() {
  string.locale_compare("a", to: "b") |> should.equal(order.Lt)
  string.locale_compare("b", to: "a") |> should.equal(order.Gt)
  string.locale_compare("a", to: "a") |> should.equal(order.Eq)
}

pub fn to_locale_lower_case_test() {
  string.to_locale_lower_case("HELLO") |> should.equal("hello")
}

pub fn to_locale_upper_case_test() {
  string.to_locale_upper_case("hello") |> should.equal("HELLO")
}

pub fn is_well_formed_test() {
  string.is_well_formed("hello") |> should.be_true
}

pub fn to_well_formed_test() {
  string.to_well_formed("hello") |> should.equal("hello")
}

pub fn index_of_test() {
  string.index_of("hello world", search: "world") |> should.equal(Ok(6))
  string.index_of("hello", search: "xyz") |> should.be_error
}

pub fn index_of_from_test() {
  string.index_of_from("abcabc", search: "abc", from: 1)
  |> should.equal(Ok(3))
}

pub fn last_index_of_test() {
  string.last_index_of("abcabc", search: "abc") |> should.equal(Ok(3))
}

pub fn last_index_of_from_test() {
  string.last_index_of_from("abcabc", search: "abc", from: 2)
  |> should.equal(Ok(0))
}

pub fn slice_test() {
  string.slice("hello world", from: 0, to: 5) |> should.equal("hello")
  string.slice("hello world", from: 6, to: 11) |> should.equal("world")
  string.slice("hello", from: -3, to: -1) |> should.equal("ll")
}

pub fn length_test() {
  string.length("hello") |> should.equal(5)
}

pub fn length_emoji_test() {
  string.length("👨‍👩‍👧‍👦") |> should.equal(11)
}

pub fn concat_test() {
  string.concat("hello", " world") |> should.equal("hello world")
}

pub fn includes_test() {
  string.includes("hello world", search: "world") |> should.be_true
  string.includes("hello", search: "xyz") |> should.be_false
}

pub fn includes_from_test() {
  string.includes_from("abcabc", search: "abc", from: 1) |> should.be_true
  string.includes_from("abcabc", search: "abc", from: 4) |> should.be_false
}

pub fn starts_with_test() {
  string.starts_with("hello", prefix: "hel") |> should.be_true
  string.starts_with("hello", prefix: "xyz") |> should.be_false
}

pub fn starts_with_from_test() {
  string.starts_with_from("hello world", prefix: "world", from: 6)
  |> should.be_true
}

pub fn ends_with_test() {
  string.ends_with("hello", suffix: "llo") |> should.be_true
  string.ends_with("hello", suffix: "xyz") |> should.be_false
}

pub fn ends_with_within_test() {
  string.ends_with_within("hello world", suffix: "hello", within: 5)
  |> should.be_true
}

pub fn replace_first_only_test() {
  string.replace("aaa", pattern: "a", with: "b")
  |> should.equal("baa")
}

pub fn replace_all_test() {
  string.replace_all("aaa", pattern: "a", with: "b")
  |> should.equal("bbb")
}

pub fn split_test() {
  string.split("a,b,c", on: ",") |> should.equal(["a", "b", "c"])
}

pub fn split_with_limit_test() {
  string.split_with_limit("a,b,c,d", on: ",", limit: 2)
  |> should.equal(["a", "b"])
}

pub fn to_lower_case_test() {
  string.to_lower_case("HELLO") |> should.equal("hello")
}

pub fn to_upper_case_test() {
  string.to_upper_case("hello") |> should.equal("HELLO")
}

pub fn trim_test() {
  string.trim("  hello  ") |> should.equal("hello")
}

pub fn trim_start_test() {
  string.trim_start("  hello  ") |> should.equal("hello  ")
}

pub fn trim_end_test() {
  string.trim_end("  hello  ") |> should.equal("  hello")
}

pub fn repeat_test() {
  string.repeat("ab", times: 3) |> should.equal(Ok("ababab"))
}

pub fn pad_start_test() {
  string.pad_start("5", to: 3, with: "0") |> should.equal(Ok("005"))
}

pub fn pad_end_test() {
  string.pad_end("5", to: 3, with: "0") |> should.equal(Ok("500"))
}

pub fn substring_test() {
  string.substring("hello world", from: 0, to: 5) |> should.equal("hello")
}
