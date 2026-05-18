//// Parent module for the Internationalization family — JavaScript's
//// `Intl.*` constructors. Hosts option types shared across siblings
//// and top-level helpers like
//// [`canonical_locales`](#canonical_locales) and the
//// per-category enumerators ([`calendars`](#calendars),
//// [`currencies`](#currencies), [`time_zones`](#time_zones), etc.).

/// The locale-matching algorithm used to pick a locale from the
/// requested priority list. Maps the JavaScript `localeMatcher` option
/// shared by the `Intl.*` formatter and matcher constructors.
///
pub type LocaleMatcher {
  /// Implementation-defined "best fit" heuristic — the runtime
  /// chooses the closest locale it supports, even when the requested
  /// tag isn't an exact match. JavaScript's default.
  BestFit

  /// The BCP 47 Lookup algorithm — strict tag-hierarchy walk that
  /// stops at the first exact subtag prefix the runtime supports.
  Lookup
}

/// Canonicalizes a list of BCP 47 locale tags and removes duplicates.
/// Returns an error if any tag is malformed.
///
/// See [Intl.getCanonicalLocales](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Intl/getCanonicalLocales) on MDN.
///
/// ## Examples
///
/// ```gleam
/// assert intl.canonical_locales(["EN-US", "Fr"]) == Ok(["en-US", "fr"])
/// ```
///
@external(javascript, "./intl.ffi.mjs", "canonical_locales")
pub fn canonical_locales(locales: List(String)) -> Result(List(String), Nil)

/// The calendar identifiers the runtime's `Intl` implementation
/// supports (e.g., `"gregory"`, `"buddhist"`), sorted ascending.
///
@external(javascript, "./intl.ffi.mjs", "calendars")
pub fn calendars() -> List(String)

/// The collation identifiers the runtime's `Intl` implementation
/// supports (e.g., `"phonebk"`, `"pinyin"`), sorted ascending.
///
@external(javascript, "./intl.ffi.mjs", "collations")
pub fn collations() -> List(String)

/// The ISO 4217 currency codes the runtime's `Intl` implementation
/// supports (e.g., `"USD"`, `"EUR"`), sorted ascending.
///
@external(javascript, "./intl.ffi.mjs", "currencies")
pub fn currencies() -> List(String)

/// The numbering-system identifiers the runtime's `Intl`
/// implementation supports (e.g., `"latn"`, `"arab"`), sorted
/// ascending.
///
@external(javascript, "./intl.ffi.mjs", "numbering_systems")
pub fn numbering_systems() -> List(String)

/// The IANA time-zone identifiers the runtime's `Intl` implementation
/// supports (e.g., `"America/New_York"`), sorted ascending.
///
@external(javascript, "./intl.ffi.mjs", "time_zones")
pub fn time_zones() -> List(String)

/// The measurement-unit identifiers the runtime's `Intl`
/// implementation supports (e.g., `"meter"`, `"hour"`), sorted
/// ascending.
///
@external(javascript, "./intl.ffi.mjs", "units")
pub fn units() -> List(String)

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
