/// Flags that modify how a `RegExp` matches.
///
/// `Unicode` and `UnicodeSets` are mutually exclusive — passing both
/// to `regexp.new_with` returns an error.
///
pub type RegExpFlag {
  /// `g` — find all matches, not just the first.
  Global
  /// `i` — case-insensitive matching.
  IgnoreCase
  /// `m` — `^` and `$` match line boundaries, not just string ends.
  Multiline
  /// `s` — `.` matches newlines.
  DotAll
  /// `u` — treat the pattern as Unicode code points.
  Unicode
  /// `v` — extended Unicode set features (supersedes `u`).
  UnicodeSets
  /// `y` — match starting at `last_index`, no skipping.
  Sticky
  /// `d` — include match indices in `Match` results.
  HasIndices
}
