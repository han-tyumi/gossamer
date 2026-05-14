//// Locale-aware string comparison via the JavaScript `Intl.Collator`.
//// Configure with [`new`](#new) and chain `with_*` setters before
//// calling [`build`](#build). Reusing a built [`Collator`](#Collator)
//// across many comparisons is significantly faster than building one
//// per call.

import gleam/option.{type Option, None, Some}
import gleam/order.{type Order}

/// A configured comparator that orders strings using a locale-
/// specific collation.
///
/// See [Intl.Collator](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Intl/Collator) on MDN.
///
@external(javascript, "./collator.type.ts", "Collator$")
pub type Collator

/// Whether the comparator is tuned for sorting or for searching. Maps
/// the JavaScript `usage` option.
///
pub type Usage {
  /// Sort comparisons. Differences contribute to the result per the
  /// configured sensitivity.
  Sort

  /// Substring or equality search. May ignore locale-specific
  /// differences for more lenient matching.
  Search
}

/// Which differences between strings produce a non-zero comparison
/// result. Maps the JavaScript `sensitivity` option.
///
pub type Sensitivity {
  /// Only base letters differ. `a` equals `á`; `a` differs from `b`.
  Base

  /// Base letters and accents differ. `a` differs from `á`.
  Accent

  /// Base letters and case differ. `a` differs from `A`.
  Case

  /// Base letters, accents, and case all differ.
  Variant
}

/// How case influences sort order when case would otherwise be a
/// tiebreaker. Maps the JavaScript `caseFirst` option.
///
pub type CaseFirst {
  /// Uppercase letters sort before their lowercase equivalents.
  Upper

  /// Lowercase letters sort before their uppercase equivalents.
  Lower

  /// Case is not considered (the JavaScript option value `"false"`).
  Neither
}

/// The configuration for an [`Intl.Collator`](#Collator). Construct
/// with [`new`](#new), chain `with_*` setters, then call
/// [`build`](#build).
///
pub opaque type Builder {
  Builder(
    locales: List(String),
    usage: Usage,
    sensitivity: Option(Sensitivity),
    ignore_punctuation: Bool,
    numeric: Bool,
    case_first: Option(CaseFirst),
    collation: Option(String),
  )
}

/// Creates a `Builder` for the given locale priority list. The runtime
/// picks the first locale it supports; pass an empty list to use the
/// runtime's default locale.
///
pub fn new(locales: List(String)) -> Builder {
  Builder(
    locales:,
    usage: Sort,
    sensitivity: None,
    ignore_punctuation: False,
    numeric: False,
    case_first: None,
    collation: None,
  )
}

/// Sets whether the comparator is tuned for sorting or searching.
///
pub fn with_usage(builder: Builder, value: Usage) -> Builder {
  Builder(..builder, usage: value)
}

/// Sets which differences between strings produce a non-zero comparison
/// result. When unset, derived from the configured [`Usage`](#Usage)
/// and locale.
///
pub fn with_sensitivity(builder: Builder, value: Sensitivity) -> Builder {
  Builder(..builder, sensitivity: Some(value))
}

/// Sets whether punctuation is skipped during comparison.
///
pub fn with_ignore_punctuation(builder: Builder, value: Bool) -> Builder {
  Builder(..builder, ignore_punctuation: value)
}

/// Sets whether numeric substrings (e.g. `"foo10"` vs `"foo2"`) are
/// compared as numbers rather than character by character.
///
pub fn with_numeric(builder: Builder, value: Bool) -> Builder {
  Builder(..builder, numeric: value)
}

/// Sets how case influences sort order. When unset, derived from the
/// locale.
///
pub fn with_case_first(builder: Builder, value: CaseFirst) -> Builder {
  Builder(..builder, case_first: Some(value))
}

/// Sets a specific collation variant (e.g., `"pinyin"` for Chinese,
/// `"phonebk"` for German). When unset, the locale's default collation
/// is used. Values not supported by the locale are silently ignored.
///
pub fn with_collation(builder: Builder, value: String) -> Builder {
  Builder(..builder, collation: Some(value))
}

/// Constructs a [`Collator`](#Collator) from the configured builder.
/// Returns `Error(Nil)` if any locale tag or the collation subtag is
/// structurally malformed.
///
pub fn build(builder: Builder) -> Result(Collator, Nil) {
  do_build(
    builder.locales,
    builder.usage,
    builder.sensitivity,
    builder.ignore_punctuation,
    builder.numeric,
    builder.case_first,
    builder.collation,
  )
}

@external(javascript, "./collator.ffi.mjs", "build")
@internal
pub fn do_build(
  locales: List(String),
  usage: Usage,
  sensitivity: Option(Sensitivity),
  ignore_punctuation: Bool,
  numeric: Bool,
  case_first: Option(CaseFirst),
  collation: Option(String),
) -> Result(Collator, Nil)

/// Compares two strings under the configured locale's collation.
///
@external(javascript, "./collator.ffi.mjs", "compare")
pub fn compare(collator: Collator, a: String, to b: String) -> Order

/// The BCP 47 locale tag the runtime resolved from the requested
/// priority list (e.g., `"en-US"`).
///
@external(javascript, "./collator.ffi.mjs", "resolved_locale")
pub fn resolved_locale(collator: Collator) -> String

/// Filters `locales` to those the runtime supports for collation,
/// preserving the input order.
///
@external(javascript, "./collator.ffi.mjs", "supported_locales_of")
pub fn supported_locales_of(locales: List(String)) -> List(String)
