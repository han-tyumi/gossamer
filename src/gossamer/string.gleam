//// Extensions to `gleam/string` for JS-specific operations — Unicode
//// normalization, locale-aware comparison and case conversion, code
//// point manipulation, and the JS string methods not covered by Gleam's
//// standard library.

import gleam/order.{type Order}
import gossamer/js_error.{type JsError}
import gossamer/string/normalization_form.{type NormalizationForm}

@external(javascript, "./string.ffi.mjs", "from_char_code")
pub fn from_char_code(code: Int) -> String

@external(javascript, "./string.ffi.mjs", "from_char_codes")
pub fn from_char_codes(codes: List(Int)) -> String

/// Returns an error if the code point is invalid.
///
@external(javascript, "./string.ffi.mjs", "from_code_point")
pub fn from_code_point(code: Int) -> Result(String, JsError)

/// Returns an error if any code point is invalid.
///
@external(javascript, "./string.ffi.mjs", "from_code_points")
pub fn from_code_points(codes: List(Int)) -> Result(String, JsError)

/// Returns the UTF-16 code unit at `index` as a single-character string,
/// or `Error(Nil)` if the index is out of range. Negative indices count
/// from the end.
///
@external(javascript, "./string.ffi.mjs", "at")
pub fn at(string: String, index index: Int) -> Result(String, Nil)

/// Returns the UTF-16 code unit at `index`, or `Error(Nil)` if the index
/// is out of range.
///
@external(javascript, "./string.ffi.mjs", "char_code_at")
pub fn char_code_at(string: String, index index: Int) -> Result(Int, Nil)

/// Returns the Unicode code point at `index`, or `Error(Nil)` if the index
/// is out of range.
///
@external(javascript, "./string.ffi.mjs", "code_point_at")
pub fn code_point_at(string: String, index index: Int) -> Result(Int, Nil)

/// Returns the NFC-normalized form of the string.
///
@external(javascript, "./string.ffi.mjs", "normalize")
pub fn normalize(string: String) -> String

@external(javascript, "./string.ffi.mjs", "normalize_with")
pub fn normalize_with(string: String, form form: NormalizationForm) -> String

@external(javascript, "./string.ffi.mjs", "locale_compare")
pub fn locale_compare(string: String, to other: String) -> Order

@external(javascript, "./string.ffi.mjs", "to_locale_lower_case")
pub fn to_locale_lower_case(string: String) -> String

@external(javascript, "./string.ffi.mjs", "to_locale_upper_case")
pub fn to_locale_upper_case(string: String) -> String

@external(javascript, "./string.ffi.mjs", "is_well_formed")
pub fn is_well_formed(string: String) -> Bool

@external(javascript, "./string.ffi.mjs", "to_well_formed")
pub fn to_well_formed(string: String) -> String

/// Returns the first index of `search` in the string, or `Error(Nil)` if
/// not found.
///
@external(javascript, "./string.ffi.mjs", "index_of")
pub fn index_of(in string: String, search search: String) -> Result(Int, Nil)

/// Like `index_of`, but starts searching from `position`.
///
@external(javascript, "./string.ffi.mjs", "index_of_from")
pub fn index_of_from(
  in string: String,
  search search: String,
  from position: Int,
) -> Result(Int, Nil)

/// Returns the last index of `search` in the string, or `Error(Nil)` if
/// not found.
///
@external(javascript, "./string.ffi.mjs", "last_index_of")
pub fn last_index_of(
  in string: String,
  search search: String,
) -> Result(Int, Nil)

/// Like `last_index_of`, but searches backwards from `position`.
///
@external(javascript, "./string.ffi.mjs", "last_index_of_from")
pub fn last_index_of_from(
  in string: String,
  search search: String,
  from position: Int,
) -> Result(Int, Nil)

/// Extracts a section of the string between `start` and `end`. Indices are
/// UTF-16 code units — this differs from `gleam/string.slice` which counts
/// grapheme clusters.
///
@external(javascript, "./string.ffi.mjs", "slice")
pub fn slice(string: String, from start: Int, to end: Int) -> String

/// Returns the number of UTF-16 code units. This differs from
/// `gleam/string.length` which counts grapheme clusters.
///
@external(javascript, "./string.ffi.mjs", "length")
pub fn length(of string: String) -> Int

@external(javascript, "./string.ffi.mjs", "concat")
pub fn concat(string: String, and other: String) -> String

@external(javascript, "./string.ffi.mjs", "includes")
pub fn includes(in string: String, search search: String) -> Bool

@external(javascript, "./string.ffi.mjs", "includes_from")
pub fn includes_from(
  in string: String,
  search search: String,
  from position: Int,
) -> Bool

@external(javascript, "./string.ffi.mjs", "starts_with")
pub fn starts_with(string: String, prefix prefix: String) -> Bool

@external(javascript, "./string.ffi.mjs", "starts_with_from")
pub fn starts_with_from(
  string: String,
  prefix prefix: String,
  from position: Int,
) -> Bool

@external(javascript, "./string.ffi.mjs", "ends_with")
pub fn ends_with(string: String, suffix suffix: String) -> Bool

@external(javascript, "./string.ffi.mjs", "ends_with_within")
pub fn ends_with_within(
  string: String,
  suffix suffix: String,
  within length: Int,
) -> Bool

/// Replaces the first occurrence only. Use `replace_all` to replace every
/// occurrence.
///
@external(javascript, "./string.ffi.mjs", "replace")
pub fn replace(
  in string: String,
  pattern pattern: String,
  with replacement: String,
) -> String

@external(javascript, "./string.ffi.mjs", "replace_all")
pub fn replace_all(
  in string: String,
  pattern pattern: String,
  with replacement: String,
) -> String

@external(javascript, "./string.ffi.mjs", "split")
pub fn split(string: String, on separator: String) -> List(String)

@external(javascript, "./string.ffi.mjs", "split_with_limit")
pub fn split_with_limit(
  string: String,
  on separator: String,
  limit limit: Int,
) -> List(String)

@external(javascript, "./string.ffi.mjs", "to_lower_case")
pub fn to_lower_case(string: String) -> String

@external(javascript, "./string.ffi.mjs", "to_upper_case")
pub fn to_upper_case(string: String) -> String

@external(javascript, "./string.ffi.mjs", "trim")
pub fn trim(string: String) -> String

@external(javascript, "./string.ffi.mjs", "trim_start")
pub fn trim_start(string: String) -> String

@external(javascript, "./string.ffi.mjs", "trim_end")
pub fn trim_end(string: String) -> String

/// Returns the string repeated `times` times. Returns an error if `times`
/// is negative or the resulting string would exceed the maximum string
/// length.
///
@external(javascript, "./string.ffi.mjs", "repeat")
pub fn repeat(string: String, times times: Int) -> Result(String, JsError)

/// Pads the start to reach `target_length` UTF-16 code units. This differs
/// from `gleam/string.pad_start` which counts grapheme clusters.
///
@external(javascript, "./string.ffi.mjs", "pad_start")
pub fn pad_start(
  string: String,
  to target_length: Int,
  with pad: String,
) -> String

/// Pads the end to reach `target_length` UTF-16 code units. This differs
/// from `gleam/string.pad_end` which counts grapheme clusters.
///
@external(javascript, "./string.ffi.mjs", "pad_end")
pub fn pad_end(
  string: String,
  to target_length: Int,
  with pad: String,
) -> String

/// Like `slice`, but swaps `start` and `end` if `start` is greater, and
/// treats negative values as zero. Indices are UTF-16 code units — this
/// differs from `gleam/string.slice` which counts grapheme clusters.
///
@external(javascript, "./string.ffi.mjs", "substring")
pub fn substring(string: String, from start: Int, to end: Int) -> String
