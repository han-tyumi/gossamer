import gleam/dict
import gleam/list
import gleam/option.{Some}
import gleam/regexp
import gleeunit/should
import gossamer/regexp_extra

pub fn compile_with_flags_test() {
  let assert Ok(re) =
    regexp_extra.compile("abc", with: [
      regexp_extra.Global,
      regexp_extra.Unicode,
      regexp_extra.Sticky,
    ])

  regexp.check(with: re, content: "abc") |> should.be_true
}

pub fn compile_invalid_pattern_test() {
  regexp_extra.compile("[unclosed", with: [regexp_extra.Global])
  |> should.be_error
}

pub fn compile_incompatible_flags_test() {
  regexp_extra.compile("abc", with: [
    regexp_extra.Unicode,
    regexp_extra.UnicodeSets,
  ])
  |> should.be_error
}

pub fn compile_no_flags_test() {
  let assert Ok(re) = regexp_extra.compile("abc", with: [])
  regexp_extra.flags(re) |> should.equal([])
}

pub fn flags_round_trip_test() {
  let inputs = [
    regexp_extra.Global,
    regexp_extra.IgnoreCase,
    regexp_extra.Multiline,
    regexp_extra.DotAll,
    regexp_extra.Unicode,
    regexp_extra.Sticky,
    regexp_extra.HasIndices,
  ]

  let assert Ok(re) = regexp_extra.compile("abc", with: inputs)

  // JS canonicalizes flag order; check membership rather than equality.
  let observed = regexp_extra.flags(re)
  list.length(observed) |> should.equal(list.length(inputs))
  list.each(inputs, fn(flag) { list.contains(observed, flag) |> should.be_true })
}

pub fn flags_on_gleam_regexp_test() {
  // gleam/regexp.from_string always adds Global + Unicode.
  let assert Ok(re) = regexp.from_string("abc")
  regexp_extra.flags(re)
  |> should.equal([regexp_extra.Global, regexp_extra.Unicode])
}

pub fn source_test() {
  let assert Ok(re) = regexp.from_string("abc(\\d+)")
  regexp_extra.source(re) |> should.equal("abc(\\d+)")
}

pub fn escape_meta_chars_test() {
  let escaped = regexp_extra.escape("a.b*c+")
  let assert Ok(re) = regexp.from_string(escaped)
  regexp.check(with: re, content: "a.b*c+") |> should.be_true
  regexp.check(with: re, content: "axbxcx") |> should.be_false
}

pub fn scan_named_groups_test() {
  let assert Ok(re) = regexp.from_string("(?<year>\\d{4})-(?<month>\\d{2})")
  let assert [match] = regexp_extra.scan(with: re, content: "2024-05")
  match.content |> should.equal("2024-05")
  dict.get(match.groups, "year") |> should.equal(Ok("2024"))
  dict.get(match.groups, "month") |> should.equal(Ok("05"))
}

pub fn scan_mixed_groups_test() {
  // The unnamed group is reachable positionally; the named one by name.
  let assert Ok(re) = regexp.from_string("(\\d+)-(?<year>\\d{4})")
  let assert [match] = regexp_extra.scan(with: re, content: "12-2024")
  match.submatches |> should.equal([Some("12"), Some("2024")])
  dict.get(match.groups, "year") |> should.equal(Ok("2024"))
}

pub fn scan_multiple_matches_test() {
  let assert Ok(re) = regexp.from_string("(?<digit>\\d)")
  regexp_extra.scan(with: re, content: "1a2b3")
  |> list.length
  |> should.equal(3)
}

pub fn scan_no_named_groups_test() {
  let assert Ok(re) = regexp.from_string("\\d+")
  let assert [match] = regexp_extra.scan(with: re, content: "42")
  dict.is_empty(match.groups) |> should.be_true
}

pub fn scan_non_participating_group_test() {
  let assert Ok(re) = regexp.from_string("(?<a>x)?(?<b>y)")
  let assert [match] = regexp_extra.scan(with: re, content: "y")
  dict.get(match.groups, "a") |> should.equal(Error(Nil))
  dict.get(match.groups, "b") |> should.equal(Ok("y"))
}

pub fn scan_non_global_regex_test() {
  // regexp_extra.compile without Global still scans every match.
  let assert Ok(re) = regexp_extra.compile("(?<d>\\d)", with: [])
  regexp_extra.scan(with: re, content: "1a2") |> list.length |> should.equal(2)
}
