//// Locale-aware duration formatting via the JavaScript
//// `Intl.DurationFormat`. Reusing a built
//// [`DurationFormat`](#DurationFormat) across many calls is
//// significantly faster than building one per call.

import gleam/option.{type Option, None, Some}
import gleam/time/duration.{type Duration}
import gossamer/intl.{type LabelStyle, type LocaleMatcher}

/// A configured duration formatter.
///
/// See [Intl.DurationFormat](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Intl/DurationFormat) on MDN.
///
@external(javascript, "./duration_format.type.ts", "DurationFormat$")
pub type DurationFormat

/// The overall rendering style. Maps the JavaScript `style` option.
///
pub type Style {
  /// Full unit names: `"2 hours, 30 minutes"`.
  StyleLong

  /// Shortened unit names: `"2 hr, 30 min"`.
  StyleShort

  /// Narrowest forms: `"2h 30m"`.
  StyleNarrow

  /// Digital-clock style: `"2:30:45"`.
  StyleDigital
}

/// Rendering style for hours, minutes, and seconds. Maps the JavaScript
/// `hours`/`minutes`/`seconds` options.
///
pub type ClockStyle {
  /// Full unit name (`"2 hours"`).
  ClockLong

  /// Shortened unit name (`"2 hr"`).
  ClockShort

  /// Narrowest unit form (`"2h"`).
  ClockNarrow

  /// Compact numeric form (`"2"` instead of `"02"`).
  ClockNumeric

  /// Zero-padded two-digit form (`"02"` instead of `"2"`).
  ClockTwoDigit
}

/// Rendering style for milliseconds, microseconds, and nanoseconds.
/// Maps the JavaScript `milliseconds`/`microseconds`/`nanoseconds`
/// options.
///
pub type SubSecondStyle {
  /// Full unit name (`"500 milliseconds"`).
  SubSecondLong

  /// Shortened unit name (`"500 ms"`).
  SubSecondShort

  /// Narrowest unit form (`"500ms"`).
  SubSecondNarrow

  /// Compact numeric form (`"500"`).
  SubSecondNumeric
}

/// Number of fractional digits shown on the smallest rendered unit.
/// Maps the JavaScript `fractionalDigits` option.
///
pub type FractionalDigits {
  /// No fractional digits (`"1:30:45"`).
  FractionalDigits0

  /// One fractional digit (`"1:30:45.5"`).
  FractionalDigits1

  /// Two fractional digits (`"1:30:45.50"`).
  FractionalDigits2

  /// Three fractional digits — millisecond precision
  /// (`"1:30:45.500"`).
  FractionalDigits3

  /// Four fractional digits.
  FractionalDigits4

  /// Five fractional digits.
  FractionalDigits5

  /// Six fractional digits — microsecond precision.
  FractionalDigits6

  /// Seven fractional digits.
  FractionalDigits7

  /// Eight fractional digits.
  FractionalDigits8

  /// Nine fractional digits — nanosecond precision.
  FractionalDigits9
}

/// Whether to display a unit even when its value is zero. Maps the
/// JavaScript `<unit>Display` option.
///
pub type Display {
  /// Show the unit only when its value is non-zero (the default for
  /// most units).
  Auto

  /// Always show the unit, even when its value is zero.
  Always
}

/// The set of fields a duration can carry, mapping the JavaScript
/// `Temporal.Duration`-like input. Use [`zero`](#zero) plus record
/// update for sparse values:
///
/// ```gleam
/// DurationParts(..duration_format.zero, hours: 2, minutes: 30)
/// ```
///
/// All fields must share the same sign — mixing positive and negative
/// values causes [`format`](#format) to return `Error(Nil)`.
///
pub type DurationParts {
  DurationParts(
    years: Int,
    months: Int,
    weeks: Int,
    days: Int,
    hours: Int,
    minutes: Int,
    seconds: Int,
    milliseconds: Int,
    microseconds: Int,
    nanoseconds: Int,
  )
}

/// A `DurationParts` where every field is zero.
///
pub const zero: DurationParts = DurationParts(0, 0, 0, 0, 0, 0, 0, 0, 0, 0)

/// Decomposes a `gleam/time/duration.Duration` into a `DurationParts`,
/// filling in hours through nanoseconds. Calendar fields
/// (years/months/weeks/days) stay zero since `Duration` represents
/// elapsed time without calendar context.
///
pub fn from_duration(value: Duration) -> DurationParts {
  let #(total_seconds, ns_remainder) =
    duration.to_seconds_and_nanoseconds(value)
  let hours = total_seconds / 3600
  let after_hours = total_seconds % 3600
  let minutes = after_hours / 60
  let seconds = after_hours % 60
  let milliseconds = ns_remainder / 1_000_000
  let after_ms = ns_remainder % 1_000_000
  let microseconds = after_ms / 1000
  let nanoseconds = after_ms % 1000
  DurationParts(
    years: 0,
    months: 0,
    weeks: 0,
    days: 0,
    hours:,
    minutes:,
    seconds:,
    milliseconds:,
    microseconds:,
    nanoseconds:,
  )
}

/// A single segment of a formatted duration, returned by
/// [`format_to_parts`](#format_to_parts).
///
pub type Part {
  Part(kind: PartKind, value: String, unit: Option(String))
}

/// The kind of a [`Part`](#Part).
///
pub type PartKind {
  /// The numeric portion of a value (e.g., `"2"` from `"2 hours"`).
  Integer

  /// A literal separator or spacing (e.g., `", "` or `" "`).
  Literal

  /// The unit-name portion of a value (e.g., `"hours"`).
  Unit
}

/// The configuration for a [`DurationFormat`](#DurationFormat).
///
pub opaque type Builder {
  Builder(
    locales: List(String),
    locale_matcher: Option(LocaleMatcher),
    style: Option(Style),
    fractional_digits: Option(FractionalDigits),
    numbering_system: Option(String),
    years: Option(LabelStyle),
    months: Option(LabelStyle),
    weeks: Option(LabelStyle),
    days: Option(LabelStyle),
    hours: Option(ClockStyle),
    minutes: Option(ClockStyle),
    seconds: Option(ClockStyle),
    milliseconds: Option(SubSecondStyle),
    microseconds: Option(SubSecondStyle),
    nanoseconds: Option(SubSecondStyle),
    years_display: Option(Display),
    months_display: Option(Display),
    weeks_display: Option(Display),
    days_display: Option(Display),
    hours_display: Option(Display),
    minutes_display: Option(Display),
    seconds_display: Option(Display),
    milliseconds_display: Option(Display),
    microseconds_display: Option(Display),
    nanoseconds_display: Option(Display),
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
    style: None,
    fractional_digits: None,
    numbering_system: None,
    years: None,
    months: None,
    weeks: None,
    days: None,
    hours: None,
    minutes: None,
    seconds: None,
    milliseconds: None,
    microseconds: None,
    nanoseconds: None,
    years_display: None,
    months_display: None,
    weeks_display: None,
    days_display: None,
    hours_display: None,
    minutes_display: None,
    seconds_display: None,
    milliseconds_display: None,
    microseconds_display: None,
    nanoseconds_display: None,
  )
}

/// Sets the locale-matching algorithm used to pick a locale from the
/// priority list.
///
pub fn with_locale_matcher(builder: Builder, value: LocaleMatcher) -> Builder {
  Builder(..builder, locale_matcher: Some(value))
}

/// Sets the overall rendering style.
///
pub fn with_style(builder: Builder, value: Style) -> Builder {
  Builder(..builder, style: Some(value))
}

/// Sets the number of fractional digits shown on the smallest rendered
/// unit. Most visible in [`StyleDigital`](#StyleDigital) style.
///
pub fn with_fractional_digits(
  builder: Builder,
  value: FractionalDigits,
) -> Builder {
  Builder(..builder, fractional_digits: Some(value))
}

/// Sets the numbering system used for digits (e.g., `"latn"`,
/// `"arab"`).
///
pub fn with_numbering_system(builder: Builder, value: String) -> Builder {
  Builder(..builder, numbering_system: Some(value))
}

/// Sets the rendering style for years.
///
pub fn with_years(builder: Builder, value: LabelStyle) -> Builder {
  Builder(..builder, years: Some(value))
}

/// Sets the rendering style for months.
///
pub fn with_months(builder: Builder, value: LabelStyle) -> Builder {
  Builder(..builder, months: Some(value))
}

/// Sets the rendering style for weeks.
///
pub fn with_weeks(builder: Builder, value: LabelStyle) -> Builder {
  Builder(..builder, weeks: Some(value))
}

/// Sets the rendering style for days.
///
pub fn with_days(builder: Builder, value: LabelStyle) -> Builder {
  Builder(..builder, days: Some(value))
}

/// Sets the rendering style for hours.
///
pub fn with_hours(builder: Builder, value: ClockStyle) -> Builder {
  Builder(..builder, hours: Some(value))
}

/// Sets the rendering style for minutes.
///
pub fn with_minutes(builder: Builder, value: ClockStyle) -> Builder {
  Builder(..builder, minutes: Some(value))
}

/// Sets the rendering style for seconds.
///
pub fn with_seconds(builder: Builder, value: ClockStyle) -> Builder {
  Builder(..builder, seconds: Some(value))
}

/// Sets the rendering style for milliseconds.
///
pub fn with_milliseconds(builder: Builder, value: SubSecondStyle) -> Builder {
  Builder(..builder, milliseconds: Some(value))
}

/// Sets the rendering style for microseconds.
///
pub fn with_microseconds(builder: Builder, value: SubSecondStyle) -> Builder {
  Builder(..builder, microseconds: Some(value))
}

/// Sets the rendering style for nanoseconds.
///
pub fn with_nanoseconds(builder: Builder, value: SubSecondStyle) -> Builder {
  Builder(..builder, nanoseconds: Some(value))
}

/// Sets whether zero years should be shown.
///
pub fn with_years_display(builder: Builder, value: Display) -> Builder {
  Builder(..builder, years_display: Some(value))
}

/// Sets whether zero months should be shown.
///
pub fn with_months_display(builder: Builder, value: Display) -> Builder {
  Builder(..builder, months_display: Some(value))
}

/// Sets whether zero weeks should be shown.
///
pub fn with_weeks_display(builder: Builder, value: Display) -> Builder {
  Builder(..builder, weeks_display: Some(value))
}

/// Sets whether zero days should be shown.
///
pub fn with_days_display(builder: Builder, value: Display) -> Builder {
  Builder(..builder, days_display: Some(value))
}

/// Sets whether zero hours should be shown.
///
pub fn with_hours_display(builder: Builder, value: Display) -> Builder {
  Builder(..builder, hours_display: Some(value))
}

/// Sets whether zero minutes should be shown.
///
pub fn with_minutes_display(builder: Builder, value: Display) -> Builder {
  Builder(..builder, minutes_display: Some(value))
}

/// Sets whether zero seconds should be shown.
///
pub fn with_seconds_display(builder: Builder, value: Display) -> Builder {
  Builder(..builder, seconds_display: Some(value))
}

/// Sets whether zero milliseconds should be shown.
///
pub fn with_milliseconds_display(builder: Builder, value: Display) -> Builder {
  Builder(..builder, milliseconds_display: Some(value))
}

/// Sets whether zero microseconds should be shown.
///
pub fn with_microseconds_display(builder: Builder, value: Display) -> Builder {
  Builder(..builder, microseconds_display: Some(value))
}

/// Sets whether zero nanoseconds should be shown.
///
pub fn with_nanoseconds_display(builder: Builder, value: Display) -> Builder {
  Builder(..builder, nanoseconds_display: Some(value))
}

/// Constructs a [`DurationFormat`](#DurationFormat) from the configured
/// builder. Returns `Error(Nil)` if any locale tag or numbering system
/// tag is structurally invalid.
///
pub fn build(builder: Builder) -> Result(DurationFormat, Nil) {
  do_build(
    builder.locales,
    builder.locale_matcher,
    builder.style,
    builder.fractional_digits,
    builder.numbering_system,
    builder.years,
    builder.months,
    builder.weeks,
    builder.days,
    builder.hours,
    builder.minutes,
    builder.seconds,
    builder.milliseconds,
    builder.microseconds,
    builder.nanoseconds,
    builder.years_display,
    builder.months_display,
    builder.weeks_display,
    builder.days_display,
    builder.hours_display,
    builder.minutes_display,
    builder.seconds_display,
    builder.milliseconds_display,
    builder.microseconds_display,
    builder.nanoseconds_display,
  )
}

@external(javascript, "./duration_format.ffi.mjs", "build")
@internal
pub fn do_build(
  locales: List(String),
  locale_matcher: Option(LocaleMatcher),
  style: Option(Style),
  fractional_digits: Option(FractionalDigits),
  numbering_system: Option(String),
  years: Option(LabelStyle),
  months: Option(LabelStyle),
  weeks: Option(LabelStyle),
  days: Option(LabelStyle),
  hours: Option(ClockStyle),
  minutes: Option(ClockStyle),
  seconds: Option(ClockStyle),
  milliseconds: Option(SubSecondStyle),
  microseconds: Option(SubSecondStyle),
  nanoseconds: Option(SubSecondStyle),
  years_display: Option(Display),
  months_display: Option(Display),
  weeks_display: Option(Display),
  days_display: Option(Display),
  hours_display: Option(Display),
  minutes_display: Option(Display),
  seconds_display: Option(Display),
  milliseconds_display: Option(Display),
  microseconds_display: Option(Display),
  nanoseconds_display: Option(Display),
) -> Result(DurationFormat, Nil)

/// Formats `parts` as a locale-aware duration string. Returns
/// `Error(Nil)` if the parts mix positive and negative values.
///
@external(javascript, "./duration_format.ffi.mjs", "format")
pub fn format(
  formatter: DurationFormat,
  parts: DurationParts,
) -> Result(String, Nil)

/// Formats `parts` and returns its decomposition into segments —
/// integer numerals, literal separators, and unit names. Returns
/// `Error(Nil)` if the parts mix positive and negative values.
///
@external(javascript, "./duration_format.ffi.mjs", "format_to_parts")
pub fn format_to_parts(
  formatter: DurationFormat,
  parts: DurationParts,
) -> Result(List(Part), Nil)

/// The BCP 47 locale tag the runtime resolved from the requested
/// priority list (e.g., `"en-US"`).
///
@external(javascript, "./duration_format.ffi.mjs", "resolved_locale")
pub fn resolved_locale(formatter: DurationFormat) -> String

/// Filters `locales` to those the runtime supports for duration
/// formatting, preserving the input order.
///
@external(javascript, "./duration_format.ffi.mjs", "supported_locales_of")
pub fn supported_locales_of(locales: List(String)) -> List(String)
