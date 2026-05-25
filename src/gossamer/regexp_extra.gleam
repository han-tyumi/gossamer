//// Extras for `gleam/regexp` — full flag access beyond the two-field
//// `Options` record upstream exposes, plus introspection accessors and
//// ES2025 `escape`.

import gleam/regexp.{type CompileError, type Regexp}

/// A `RegExp` flag. The full set is reachable via `compile` and `flags`;
/// `gleam/regexp.compile`'s `Options` exposes only `IgnoreCase` and
/// `Multiline`.
///
pub type RegExpFlag {
  /// `g` — find all matches in a string, not just the first.
  Global
  /// `i` — case-insensitive matching.
  IgnoreCase
  /// `m` — `^` and `$` match per-line, not per-string.
  Multiline
  /// `s` — `.` matches newline characters.
  DotAll
  /// `u` — Unicode mode: surrogate pairs treated as single code points,
  /// `\u{...}` escapes recognized.
  Unicode
  /// `v` — extended Unicode set features. Mutually exclusive with `Unicode`.
  UnicodeSets
  /// `y` — anchored matching at `lastIndex`.
  Sticky
  /// `d` — capture-group indices in match results (ES2022).
  HasIndices
}

/// Compiles `pattern` with exactly the flags given. Unlike
/// `gleam/regexp.compile`, no flags are auto-added. Returns an error if
/// `pattern` is not a valid regular expression or the flag set is invalid
/// (e.g., `Unicode` and `UnicodeSets` together).
///
/// ## Examples
///
/// ```gleam
/// let assert Ok(re) =
///   regexp_extra.compile("abc", with: [Global, Unicode, Sticky])
/// regexp.check(with: re, content: "abc")
/// // -> True
/// ```
///
@external(javascript, "./regexp_extra.ffi.mjs", "compile")
pub fn compile(
  pattern: String,
  with flags: List(RegExpFlag),
) -> Result(Regexp, CompileError)

/// The flags set on `regexp`, including ones `gleam/regexp` doesn't
/// surface.
///
/// ## Examples
///
/// ```gleam
/// let assert Ok(re) = regexp.from_string("abc")
/// regexp_extra.flags(re)
/// // -> [Global, Unicode]
/// ```
///
@external(javascript, "./regexp_extra.ffi.mjs", "flags")
pub fn flags(regexp: Regexp) -> List(RegExpFlag)

/// The original pattern string the regex was compiled from.
///
/// ## Examples
///
/// ```gleam
/// let assert Ok(re) = regexp.from_string("abc(\\d+)")
/// regexp_extra.source(re)
/// // -> "abc(\\d+)"
/// ```
///
@external(javascript, "./regexp_extra.ffi.mjs", "source")
pub fn source(regexp: Regexp) -> String

/// Escapes regex metacharacters in `string` so it can be embedded as a
/// literal pattern. Equivalent to JavaScript's static `RegExp.escape`
/// (ES2025).
///
/// ## Examples
///
/// ```gleam
/// let assert Ok(re) =
///   regexp.from_string(regexp_extra.escape("a.b*c+"))
/// regexp.check(with: re, content: "a.b*c+")
/// // -> True
/// ```
///
@external(javascript, "./regexp_extra.ffi.mjs", "escape")
pub fn escape(string: String) -> String
