import gleam/dict
import gleam/option
import gleeunit/should
import gossamer/regexp
import gossamer/regexp_flag

pub fn new_test() {
  let assert Ok(r) = regexp.new("foo")
  regexp.source(r) |> should.equal("foo")
  regexp.flags(r) |> should.equal([])
}

pub fn new_invalid_pattern_errors_test() {
  let assert Error(_) = regexp.new("[")
}

pub fn new_with_flags_test() {
  let assert Ok(r) =
    regexp.new_with("foo", [regexp_flag.Global, regexp_flag.IgnoreCase])
  regexp.is_global(r) |> should.be_true()
  regexp.is_ignore_case(r) |> should.be_true()
  regexp.is_multiline(r) |> should.be_false()
}

pub fn new_with_incompatible_flags_errors_test() {
  let assert Error(_) =
    regexp.new_with("foo", [regexp_flag.Unicode, regexp_flag.UnicodeSets])
}

pub fn flags_round_trip_test() {
  let assert Ok(r) =
    regexp.new_with("foo", [
      regexp_flag.IgnoreCase,
      regexp_flag.Global,
      regexp_flag.HasIndices,
    ])
  let f = regexp.flags(r)

  // Returned in canonical (alphabetical) order.
  f
  |> should.equal([
    regexp_flag.HasIndices,
    regexp_flag.Global,
    regexp_flag.IgnoreCase,
  ])
}

pub fn escape_test() {
  let escaped = regexp.escape("a.b*c")
  let assert Ok(r) = regexp.new(escaped)
  regexp.test_(r, against: "a.b*c") |> should.be_true()
  regexp.test_(r, against: "axbxc") |> should.be_false()
}

pub fn test_match_test() {
  let assert Ok(r) = regexp.new("foo")
  regexp.test_(r, against: "barfoo") |> should.be_true()
  regexp.test_(r, against: "barbaz") |> should.be_false()
}

pub fn exec_no_match_test() {
  let assert Ok(r) = regexp.new("foo")
  regexp.exec(r, against: "bar") |> should.be_error()
}

pub fn exec_with_captures_test() {
  let assert Ok(r) = regexp.new_with("(\\d+)-(\\w+)", [])
  let assert Ok(m) = regexp.exec(r, against: "12-foo 34-bar")
  m.value |> should.equal("12-foo")
  m.captures
  |> should.equal([option.Some("12"), option.Some("foo")])
  m.index |> should.equal(0)
}

pub fn exec_with_named_captures_test() {
  let assert Ok(r) = regexp.new("(?<year>\\d{4})-(?<month>\\d{2})")
  let assert Ok(m) = regexp.exec(r, against: "2024-01")
  m.named_captures |> dict.get("year") |> should.equal(Ok("2024"))
  m.named_captures |> dict.get("month") |> should.equal(Ok("01"))
}

pub fn exec_omits_unmatched_named_captures_test() {
  let assert Ok(r) = regexp.new("(?<digits>\\d+)|(?<letters>[a-z]+)")
  let assert Ok(m) = regexp.exec(r, against: "123")
  m.named_captures |> dict.get("digits") |> should.equal(Ok("123"))
  m.named_captures |> dict.get("letters") |> should.be_error()
}

pub fn exec_advances_last_index_with_global_test() {
  let assert Ok(r) = regexp.new_with("\\d+", [regexp_flag.Global])
  regexp.last_index(r) |> should.equal(0)
  let assert Ok(_) = regexp.exec(r, against: "12 34 56")
  regexp.last_index(r) |> should.equal(2)
}

pub fn set_last_index_test() {
  let assert Ok(r) = regexp.new_with("\\d+", [regexp_flag.Global])
  let r = regexp.set_last_index(r, to: 5)
  regexp.last_index(r) |> should.equal(5)
}

pub fn flag_getters_test() {
  let assert Ok(r) =
    regexp.new_with("foo", [
      regexp_flag.Global,
      regexp_flag.IgnoreCase,
      regexp_flag.Multiline,
      regexp_flag.DotAll,
      regexp_flag.Sticky,
      regexp_flag.HasIndices,
    ])
  regexp.is_global(r) |> should.be_true()
  regexp.is_ignore_case(r) |> should.be_true()
  regexp.is_multiline(r) |> should.be_true()
  regexp.is_dot_all(r) |> should.be_true()
  regexp.is_sticky(r) |> should.be_true()
  regexp.has_indices(r) |> should.be_true()
  regexp.is_unicode(r) |> should.be_false()
  regexp.is_unicode_sets(r) |> should.be_false()
}
