//// Parent module for the Internationalization family — JavaScript's
//// `Intl.*` constructors. Hosts option enums shared across siblings
//// and top-level helpers like [`get_canonical_locales`](#get_canonical_locales)
//// and [`supported_values_of`](#supported_values_of).

/// Categories of locale-related values that
/// [`supported_values_of`](#supported_values_of) can enumerate.
///
pub type SupportedValueKey {
  /// Calendar identifiers (e.g., `"gregory"`, `"buddhist"`).
  Calendar

  /// Collation identifiers (e.g., `"phonebk"`, `"pinyin"`).
  Collation

  /// ISO 4217 currency codes (e.g., `"USD"`, `"EUR"`).
  Currency

  /// Numbering system identifiers (e.g., `"latn"`, `"arab"`).
  NumberingSystem

  /// IANA time zone identifiers (e.g., `"America/New_York"`).
  TimeZone

  /// Measurement unit identifiers (e.g., `"meter"`, `"hour"`).
  Unit
}

/// Canonicalizes a list of BCP 47 locale tags and removes duplicates.
/// Returns an error if any tag is malformed.
///
/// See [Intl.getCanonicalLocales](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Intl/getCanonicalLocales) on MDN.
///
/// ## Examples
///
/// ```gleam
/// assert intl.get_canonical_locales(["EN-US", "Fr"]) == Ok(["en-US", "fr"])
/// ```
///
@external(javascript, "./intl.ffi.mjs", "get_canonical_locales")
pub fn get_canonical_locales(locales: List(String)) -> Result(List(String), Nil)

/// Returns the values supported by the runtime's `Intl` implementation
/// for the given category, sorted in ascending order.
///
/// See [Intl.supportedValuesOf](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Intl/supportedValuesOf) on MDN.
///
/// ## Examples
///
/// ```gleam
/// intl.supported_values_of(intl.TimeZone)
/// // -> ["Africa/Abidjan", "Africa/Accra", ...]
/// ```
///
@external(javascript, "./intl.ffi.mjs", "supported_values_of")
pub fn supported_values_of(key: SupportedValueKey) -> List(String)

/// The rounding strategy applied to a formatter's output. Maps the
/// JavaScript `roundingMode` option.
///
pub type RoundingMode {
  /// Round toward positive infinity (toward `+∞`).
  RoundingModeCeil

  /// Round toward negative infinity (toward `-∞`).
  RoundingModeFloor

  /// Round away from zero.
  RoundingModeExpand

  /// Round toward zero (truncation).
  RoundingModeTrunc

  /// Round to the nearest value; ties round toward positive infinity.
  RoundingModeHalfCeil

  /// Round to the nearest value; ties round toward negative infinity.
  RoundingModeHalfFloor

  /// Round to the nearest value; ties round away from zero (the
  /// default).
  RoundingModeHalfExpand

  /// Round to the nearest value; ties round toward zero.
  RoundingModeHalfTrunc

  /// Round to the nearest value; ties round to the nearest even
  /// digit (banker's rounding).
  RoundingModeHalfEven
}

/// How rounding interacts when both significant-digit and
/// fraction-digit options are set. Maps the JavaScript
/// `roundingPriority` option.
///
pub type RoundingPriority {
  /// Significant digits take priority over fraction digits (the
  /// default).
  RoundingPriorityAuto

  /// Whichever option produces the higher number of significant
  /// digits is used.
  RoundingPriorityMorePrecision

  /// Whichever option produces the lower number of significant
  /// digits is used.
  RoundingPriorityLessPrecision
}

/// Whether trailing fraction zeros are displayed on integer values.
/// Maps the JavaScript `trailingZeroDisplay` option.
///
pub type TrailingZeroDisplay {
  /// Keep trailing zeros (the default).
  TrailingZeroAuto

  /// Strip trailing fraction zeros from integer values (e.g.,
  /// `"1.00"` becomes `"1"`).
  TrailingZeroStripIfInteger
}

/// The clock format. Maps the JavaScript `hourCycle` option.
///
pub type HourCycle {
  /// 12-hour clock starting at hour 0 (midnight is `0:00 AM`).
  H11

  /// 12-hour clock starting at hour 12 (midnight is `12:00 AM` — the
  /// common AM/PM clock).
  H12

  /// 24-hour clock starting at hour 0 (midnight is `0:00` — the
  /// common 24-hour clock).
  H23

  /// 24-hour clock starting at hour 24 (midnight is `24:00`).
  H24
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

/// The verbosity of a rendered label. Maps the JavaScript
/// `"long" | "short" | "narrow"` value set used by `Intl.DateTimeFormat`
/// (weekday/era/dayPeriod), `Intl.DisplayNames` (style),
/// `Intl.ListFormat` (style), and `Intl.RelativeTimeFormat` (style).
///
pub type LabelStyle {
  /// Full names (`"Friday"`, `"American English"`).
  Long

  /// Shortened forms (`"Fri"`, `"AmE"`).
  Short

  /// The shortest forms (`"F"`).
  Narrow
}

/// Which side of a formatted range produced a particular segment.
/// Returned in the `source` field of `format_range_to_parts` output
/// across `Intl.DateTimeFormat` and `Intl.NumberFormat`.
///
pub type RangePartSource {
  /// Produced from the start of the range.
  Start

  /// Shared by both sides of the range (e.g., a connecting `" - "`).
  Shared

  /// Produced from the end of the range.
  End
}
