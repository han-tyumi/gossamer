//// Extras for `gleam/string` — Unicode normalization, locale-aware
//// comparison and case conversion, and UTF-16 well-formedness checks.
////
//// For constructing a string from Unicode code points, use
//// `gleam/string.utf_codepoint` together with
//// `gleam/string.from_utf_codepoints`.

import gleam/order.{type Order}

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

/// Compares two strings using the runtime's locale-aware collation. The
/// resulting `Order` reflects the active locale, which differs from
/// `gleam/string.compare`'s code-point ordering.
///
@external(javascript, "./string_extra.ffi.mjs", "locale_compare")
pub fn locale_compare(string: String, to other: String) -> Order

/// Returns `string` lowercased using the runtime's active locale. This
/// differs from `gleam/string.lowercase` for locale-specific casing rules
/// (e.g., Turkish dotted/dotless I).
///
@external(javascript, "./string_extra.ffi.mjs", "to_locale_lower_case")
pub fn to_locale_lower_case(string: String) -> String

/// Returns `string` uppercased using the runtime's active locale. This
/// differs from `gleam/string.uppercase` for locale-specific casing rules.
///
@external(javascript, "./string_extra.ffi.mjs", "to_locale_upper_case")
pub fn to_locale_upper_case(string: String) -> String

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
