import gleam/dict.{type Dict}
import gleam/option.{type Option}
import gossamer/js_error.{type JsError}
import gossamer/regexp_flag.{type RegExpFlag}

/// A JS `RegExp` for matching patterns against strings. Mutable for
/// `Global` and `Sticky` flags — `last_index` advances after each
/// match.
///
/// See [RegExp](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/RegExp) on MDN.
///
@external(javascript, "./regexp.type.ts", "RegExp$")
pub type RegExp

/// The result of `exec`.
///
/// - `value` is the matched substring (the full match, group 0).
/// - `captures` contains the numbered capture groups, group 1 onwards.
///   `None` indicates a group that didn't match.
/// - `named_captures` contains only the named groups that matched.
/// - `index` is the 0-based position of the match in the input.
///
/// Match-level indices data from the `HasIndices` flag is not
/// currently exposed.
///
pub type Match {
  Match(
    value: String,
    captures: List(Option(String)),
    named_captures: Dict(String, String),
    index: Int,
  )
}

/// Creates a new `RegExp` from `pattern`. Returns an error if the
/// pattern is not a valid regular expression.
///
@external(javascript, "./regexp.ffi.mjs", "new_")
pub fn new(pattern: String) -> Result(RegExp, JsError)

/// Creates a new `RegExp` from `pattern` with the given flags. Returns
/// an error if the pattern is invalid or the flags are incompatible
/// (e.g., both `Unicode` and `UnicodeSets`).
///
@external(javascript, "./regexp.ffi.mjs", "new_with")
pub fn new_with(
  pattern: String,
  with flags: List(RegExpFlag),
) -> Result(RegExp, JsError)

/// Escapes `string` so it can be safely embedded in a regex pattern as
/// a literal substring.
///
@external(javascript, "./regexp.ffi.mjs", "escape")
pub fn escape(string: String) -> String

@external(javascript, "./regexp.ffi.mjs", "source")
pub fn source(of regex: RegExp) -> String

/// The flags of `regex` in canonical order (alphabetical by flag
/// character).
///
@external(javascript, "./regexp.ffi.mjs", "flags")
pub fn flags(of regex: RegExp) -> List(RegExpFlag)

/// The position at which the next `exec` will start matching, when the
/// regex has the `Global` or `Sticky` flag.
///
@external(javascript, "./regexp.ffi.mjs", "last_index")
pub fn last_index(of regex: RegExp) -> Int

/// Sets `last_index`. Mutates the regex.
///
@external(javascript, "./regexp.ffi.mjs", "set_last_index")
pub fn set_last_index(of regex: RegExp, to index: Int) -> RegExp

@external(javascript, "./regexp.ffi.mjs", "is_global")
pub fn is_global(of regex: RegExp) -> Bool

@external(javascript, "./regexp.ffi.mjs", "is_ignore_case")
pub fn is_ignore_case(of regex: RegExp) -> Bool

@external(javascript, "./regexp.ffi.mjs", "is_multiline")
pub fn is_multiline(of regex: RegExp) -> Bool

@external(javascript, "./regexp.ffi.mjs", "is_dot_all")
pub fn is_dot_all(of regex: RegExp) -> Bool

@external(javascript, "./regexp.ffi.mjs", "is_unicode")
pub fn is_unicode(of regex: RegExp) -> Bool

@external(javascript, "./regexp.ffi.mjs", "is_unicode_sets")
pub fn is_unicode_sets(of regex: RegExp) -> Bool

@external(javascript, "./regexp.ffi.mjs", "is_sticky")
pub fn is_sticky(of regex: RegExp) -> Bool

@external(javascript, "./regexp.ffi.mjs", "has_indices")
pub fn has_indices(of regex: RegExp) -> Bool

/// Tests whether `input` contains a match for `regex`. With the
/// `Global` or `Sticky` flag, advances `last_index`.
///
@external(javascript, "./regexp.ffi.mjs", "test_")
pub fn test_(regex: RegExp, against input: String) -> Bool

/// Returns the next match of `regex` in `input`, or an error if no
/// match. With the `Global` or `Sticky` flag, advances `last_index`.
///
@external(javascript, "./regexp.ffi.mjs", "exec")
pub fn exec(regex: RegExp, against input: String) -> Result(Match, Nil)
