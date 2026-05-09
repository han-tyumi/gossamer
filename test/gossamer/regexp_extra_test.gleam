import gleam/list
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
