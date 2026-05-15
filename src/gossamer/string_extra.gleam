//// Extras for `gleam/string` — Unicode normalization, locale-aware
//// case conversion, and UTF-16 well-formedness checks.
////
//// For constructing a string from Unicode code points, use
//// `gleam/string.utf_codepoint` together with
//// `gleam/string.from_utf_codepoints`. For locale-aware comparison,
//// use [`gossamer/intl/collator`](./intl/collator.html).

/// A Unicode normalization form used by `normalize_to`. NFC and NFD
/// preserve equivalence; NFKC and NFKD also apply compatibility
/// decomposition.
///
pub type NormalizationForm {
  /// Canonical composition — characters are recomposed into the
  /// shortest equivalent form. The default for equivalence comparison.
  Nfc

  /// Canonical decomposition — composed characters are decomposed
  /// into their canonical sequence (e.g., `é` → `e + ́`).
  Nfd

  /// Compatibility composition — applies compatibility decomposition
  /// then canonical composition. Lossy: visually similar forms
  /// collapse (e.g., `ﬁ` → `fi`).
  Nfkc

  /// Compatibility decomposition — like `Nfd` but also decomposes
  /// compatibility variants. Lossy in the same way as `Nfkc`.
  Nfkd
}

/// Returns the NFC-normalized form of `string`. NFC is the canonical
/// choice for equivalence comparison.
///
@external(javascript, "./string_extra.ffi.mjs", "normalize")
pub fn normalize(string: String) -> String

/// Returns the normalized form of `string` for the given form.
///
@external(javascript, "./string_extra.ffi.mjs", "normalize_to")
pub fn normalize_to(string: String, form form: NormalizationForm) -> String

/// Returns `string` lowercased using the first supported locale from
/// `locales` (or the runtime's default locale when the list is empty).
/// Differs from `gleam/string.lowercase` for locale-specific casing
/// rules (e.g., Turkish lowercases `"I"` to dotless `"ı"`, not
/// `"i"`). Returns `Error(Nil)` if any tag in `locales` is
/// structurally invalid.
///
@external(javascript, "./string_extra.ffi.mjs", "to_locale_lower_case")
pub fn to_locale_lower_case(
  string: String,
  in locales: List(String),
) -> Result(String, Nil)

/// Returns `string` uppercased using the first supported locale from
/// `locales` (or the runtime's default locale when the list is empty).
/// Differs from `gleam/string.uppercase` for locale-specific casing
/// rules. Returns `Error(Nil)` if any tag in `locales` is
/// structurally invalid.
///
@external(javascript, "./string_extra.ffi.mjs", "to_locale_upper_case")
pub fn to_locale_upper_case(
  string: String,
  in locales: List(String),
) -> Result(String, Nil)

/// `True` when `string` is a well-formed UTF-16 sequence — every
/// surrogate is part of a valid pair.
///
@external(javascript, "./string_extra.ffi.mjs", "is_well_formed")
pub fn is_well_formed(string: String) -> Bool

/// Returns `string` with any lone surrogate replaced by `U+FFFD`
/// (replacement character).
///
@external(javascript, "./string_extra.ffi.mjs", "to_well_formed")
pub fn to_well_formed(string: String) -> String
