//// Locale-aware string comparison via the JavaScript `Intl.Collator`.
//// Reusing a built [`Collator`](#Collator) across many comparisons
//// is significantly faster than building one per call.

import gleam/option.{type Option, None, Some}
import gleam/order.{type Order}
import gossamer/intl.{type CaseFirst, type LocaleMatcher}

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

/// The configuration for a [`Collator`](#Collator).
///
pub opaque type Builder {
  Builder(
    locales: List(String),
    locale_matcher: Option(LocaleMatcher),
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
    locale_matcher: None,
    usage: Sort,
    sensitivity: None,
    ignore_punctuation: False,
    numeric: False,
    case_first: None,
    collation: None,
  )
}

/// Sets the locale-matching algorithm used to pick a locale from the
/// priority list.
///
pub fn with_locale_matcher(
  builder: Builder,
  locale_matcher: LocaleMatcher,
) -> Builder {
  Builder(..builder, locale_matcher: Some(locale_matcher))
}

/// Sets whether the comparator is tuned for sorting or searching.
///
pub fn with_usage(builder: Builder, usage: Usage) -> Builder {
  Builder(..builder, usage:)
}

/// Sets which differences between strings produce a non-zero comparison
/// result. When unset, derived from the configured [`Usage`](#Usage)
/// and locale.
///
pub fn with_sensitivity(builder: Builder, sensitivity: Sensitivity) -> Builder {
  Builder(..builder, sensitivity: Some(sensitivity))
}

/// Sets whether punctuation is skipped during comparison.
///
pub fn with_ignore_punctuation(
  builder: Builder,
  ignore_punctuation: Bool,
) -> Builder {
  Builder(..builder, ignore_punctuation:)
}

/// Sets whether numeric substrings (e.g. `"foo10"` vs `"foo2"`) are
/// compared as numbers rather than character by character.
///
pub fn with_numeric(builder: Builder, numeric: Bool) -> Builder {
  Builder(..builder, numeric:)
}

/// Sets how case influences sort order. When unset, derived from the
/// locale.
///
pub fn with_case_first(builder: Builder, case_first: CaseFirst) -> Builder {
  Builder(..builder, case_first: Some(case_first))
}

/// Sets a specific collation variant (e.g., `"pinyin"` for Chinese,
/// `"phonebk"` for German). When unset, the locale's default collation
/// is used. Values not supported by the locale are silently ignored.
///
pub fn with_collation(builder: Builder, collation: String) -> Builder {
  Builder(..builder, collation: Some(collation))
}

/// Constructs a [`Collator`](#Collator) from the configured builder.
/// Returns `Error(Nil)` if any locale tag is structurally malformed.
///
pub fn build(builder: Builder) -> Result(Collator, Nil) {
  do_build(
    builder.locales,
    builder.locale_matcher,
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
  locale_matcher: Option(LocaleMatcher),
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
pub fn compare(collator: Collator, a: String, b: String) -> Order

/// The options the runtime resolved for a [`Collator`](#Collator),
/// including the defaults it filled in. `locale` is the BCP 47 tag
/// chosen from the requested priority list (e.g., `"en-US"`);
/// `collation` is the resolved collation identifier (`"default"` when
/// none was requested).
///
pub type ResolvedOptions {
  ResolvedOptions(
    locale: String,
    usage: Usage,
    sensitivity: Sensitivity,
    ignore_punctuation: Bool,
    collation: String,
    numeric: Bool,
    case_first: CaseFirst,
  )
}

/// The full configuration the runtime resolved from the builder,
/// including the sensitivity and case ordering it derived from the
/// usage and locale.
///
@external(javascript, "./collator.ffi.mjs", "resolved_options")
pub fn resolved_options(collator: Collator) -> ResolvedOptions

/// Filters `locales` to those the runtime supports for collation,
/// preserving the input order. Returns `Error(Nil)` if any locale tag
/// is structurally malformed.
///
@external(javascript, "./collator.ffi.mjs", "supported_locales_of")
pub fn supported_locales_of(locales: List(String)) -> Result(List(String), Nil)
