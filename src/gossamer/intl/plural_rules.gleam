//// Locale-aware plural-form selection via the JavaScript
//// `Intl.PluralRules`. Reusing a built [`PluralRules`](#PluralRules)
//// across many selections is significantly faster than building one
//// per call.
////
//// Selection is bound for `Float` and `Int` with matching `*_range`
//// variants returning [`PluralCategory`](#PluralCategory). `BigInt`
//// is not supported — Deno's V8 throws `TypeError` on `BigInt`
//// inputs to `Intl.PluralRules.select` despite the ES2023 spec
//// allowing them. Convert with
//// [`big_int.to_int`](https://hexdocs.pm/gossamer/gossamer/big_int.html#to_int)
//// first when the value fits in `Int`'s safe range.

import gleam/option.{type Option, None, Some}
import gossamer/intl.{
  type RoundingMode, type RoundingPriority, type TrailingZeroDisplay,
}

/// A configured plural-rules selector that maps a number to its
/// locale-specific plural category.
///
/// See [Intl.PluralRules](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Intl/PluralRules) on MDN.
///
@external(javascript, "./plural_rules.type.ts", "PluralRules$")
pub type PluralRules

/// Whether the rules describe cardinal counts ("one apple, two
/// apples") or ordinal positions ("1st, 2nd, 3rd"). Maps the
/// JavaScript `type` option.
///
pub type Kind {
  /// Cardinal counts (the default).
  Cardinal

  /// Ordinal positions.
  Ordinal
}

/// The plural form a number selects under the configured locale and
/// rule type. Mirrors the
/// [CLDR plural categories](https://cldr.unicode.org/index/cldr-spec/plural-rules).
/// Not every locale uses every category — English `cardinal` only
/// distinguishes `One` and `Other`, while Arabic uses all six.
///
pub type PluralCategory {
  /// Zero count (e.g., `"0 items"` in some locales).
  Zero

  /// Singular (e.g., `"1 item"`).
  One

  /// Dual (e.g., Arabic `"2 items"`).
  Two

  /// Few (e.g., Russian `"2-4 items"`).
  Few

  /// Many (e.g., Polish `"5-21 items"`).
  Many

  /// The fallback used when no other category matches.
  Other
}

/// The configuration for a [`PluralRules`](#PluralRules).
///
pub opaque type Builder {
  Builder(
    locales: List(String),
    kind: Option(Kind),
    minimum_integer_digits: Option(Int),
    minimum_fraction_digits: Option(Int),
    maximum_fraction_digits: Option(Int),
    minimum_significant_digits: Option(Int),
    maximum_significant_digits: Option(Int),
    rounding_mode: Option(RoundingMode),
    rounding_priority: Option(RoundingPriority),
    rounding_increment: Option(Int),
    trailing_zero_display: Option(TrailingZeroDisplay),
  )
}

/// Creates a `Builder` for the given locale priority list. The runtime
/// picks the first locale it supports; pass an empty list to use the
/// runtime's default locale.
///
pub fn new(locales: List(String)) -> Builder {
  Builder(
    locales:,
    kind: None,
    minimum_integer_digits: None,
    minimum_fraction_digits: None,
    maximum_fraction_digits: None,
    minimum_significant_digits: None,
    maximum_significant_digits: None,
    rounding_mode: None,
    rounding_priority: None,
    rounding_increment: None,
    trailing_zero_display: None,
  )
}

/// Sets whether the rules describe cardinal counts or ordinal
/// positions.
///
pub fn with_kind(builder: Builder, value: Kind) -> Builder {
  Builder(..builder, kind: Some(value))
}

/// Sets the minimum number of integer digits. Values below the
/// minimum are zero-padded for plural-rule selection purposes.
///
pub fn with_minimum_integer_digits(builder: Builder, value: Int) -> Builder {
  Builder(..builder, minimum_integer_digits: Some(value))
}

/// Sets the minimum number of fraction digits.
///
pub fn with_minimum_fraction_digits(builder: Builder, value: Int) -> Builder {
  Builder(..builder, minimum_fraction_digits: Some(value))
}

/// Sets the maximum number of fraction digits.
///
pub fn with_maximum_fraction_digits(builder: Builder, value: Int) -> Builder {
  Builder(..builder, maximum_fraction_digits: Some(value))
}

/// Sets the minimum number of significant digits.
///
pub fn with_minimum_significant_digits(builder: Builder, value: Int) -> Builder {
  Builder(..builder, minimum_significant_digits: Some(value))
}

/// Sets the maximum number of significant digits.
///
pub fn with_maximum_significant_digits(builder: Builder, value: Int) -> Builder {
  Builder(..builder, maximum_significant_digits: Some(value))
}

/// Sets the rounding strategy applied when the formatter discards
/// digits past the configured precision.
///
pub fn with_rounding_mode(builder: Builder, value: RoundingMode) -> Builder {
  Builder(..builder, rounding_mode: Some(value))
}

/// Sets how rounding interacts when both significant-digit and
/// fraction-digit options are set.
///
pub fn with_rounding_priority(
  builder: Builder,
  value: RoundingPriority,
) -> Builder {
  Builder(..builder, rounding_priority: Some(value))
}

/// Sets the rounding increment — the value is rounded to the nearest
/// multiple of this number before plural-rule selection. Valid values
/// are `1`, `2`, `5`, `10`, `20`, `25`, `50`, `100`, `200`, `250`,
/// `500`, `1000`, `2000`, `2500`, and `5000`; other values cause
/// [`build`](#build) to return `Error(Nil)`.
///
pub fn with_rounding_increment(builder: Builder, value: Int) -> Builder {
  Builder(..builder, rounding_increment: Some(value))
}

/// Sets whether trailing fraction zeros are stripped from integer
/// values prior to plural-rule selection.
///
pub fn with_trailing_zero_display(
  builder: Builder,
  value: TrailingZeroDisplay,
) -> Builder {
  Builder(..builder, trailing_zero_display: Some(value))
}

/// Constructs a [`PluralRules`](#PluralRules) from the configured
/// builder. Returns `Error(Nil)` if any locale tag is structurally
/// invalid, if a digit-count option is outside its allowed range, or
/// if [`with_rounding_increment`](#with_rounding_increment) is set to
/// an unsupported value.
///
pub fn build(builder: Builder) -> Result(PluralRules, Nil) {
  do_build(
    builder.locales,
    builder.kind,
    builder.minimum_integer_digits,
    builder.minimum_fraction_digits,
    builder.maximum_fraction_digits,
    builder.minimum_significant_digits,
    builder.maximum_significant_digits,
    builder.rounding_mode,
    builder.rounding_priority,
    builder.rounding_increment,
    builder.trailing_zero_display,
  )
}

@external(javascript, "./plural_rules.ffi.mjs", "build")
@internal
pub fn do_build(
  locales: List(String),
  kind: Option(Kind),
  minimum_integer_digits: Option(Int),
  minimum_fraction_digits: Option(Int),
  maximum_fraction_digits: Option(Int),
  minimum_significant_digits: Option(Int),
  maximum_significant_digits: Option(Int),
  rounding_mode: Option(RoundingMode),
  rounding_priority: Option(RoundingPriority),
  rounding_increment: Option(Int),
  trailing_zero_display: Option(TrailingZeroDisplay),
) -> Result(PluralRules, Nil)

/// Selects the [`PluralCategory`](#PluralCategory) for a `Float`
/// value.
///
@external(javascript, "./plural_rules.ffi.mjs", "select")
pub fn select_float(rules: PluralRules, value: Float) -> PluralCategory

/// Selects the [`PluralCategory`](#PluralCategory) for an `Int` value.
///
@external(javascript, "./plural_rules.ffi.mjs", "select")
pub fn select_int(rules: PluralRules, value: Int) -> PluralCategory

/// Selects the [`PluralCategory`](#PluralCategory) for a `Float`
/// range from `start` to `end`. Returns `Error(Nil)` if either
/// endpoint is `NaN`. Runtimes vary on whether `end < start` throws —
/// some swap the values and return a category for the reversed range.
///
@external(javascript, "./plural_rules.ffi.mjs", "select_range")
pub fn select_float_range(
  rules: PluralRules,
  from start: Float,
  to end: Float,
) -> Result(PluralCategory, Nil)

/// Selects the [`PluralCategory`](#PluralCategory) for an `Int`
/// range.
///
@external(javascript, "./plural_rules.ffi.mjs", "select_range")
pub fn select_int_range(
  rules: PluralRules,
  from start: Int,
  to end: Int,
) -> Result(PluralCategory, Nil)

/// The BCP 47 locale tag the runtime resolved from the requested
/// priority list. The runtime may normalize regional tags to the
/// language tag when plural rules don't differ by region — `"en-US"`
/// typically resolves to `"en"`.
///
@external(javascript, "./plural_rules.ffi.mjs", "resolved_locale")
pub fn resolved_locale(rules: PluralRules) -> String

/// Filters `locales` to those the runtime supports for plural-rules
/// selection, preserving the input order.
///
@external(javascript, "./plural_rules.ffi.mjs", "supported_locales_of")
pub fn supported_locales_of(locales: List(String)) -> List(String)
