//// Locale-aware date and time formatting via the JavaScript
//// `Intl.DateTimeFormat`. Reusing a built
//// [`DateTimeFormat`](#DateTimeFormat) across many calls is
//// significantly faster than building one per call.
////
//// Formatting accepts a
//// [`gleam/time/timestamp.Timestamp`](https://hexdocs.pm/gleam_time/gleam/time/timestamp.html#Timestamp);
//// the `*_to_parts` variants return a typed decomposition and the
//// `*_range` variants format a start-to-end pair.

import gleam/option.{type Option, None, Some}
import gleam/time/timestamp.{type Timestamp}
import gossamer/intl.{
  type HourCycle, type LabelStyle, type LocaleMatcher, type RangePartSource,
}

/// A configured formatter that renders a `Timestamp` as a
/// locale-aware date/time string.
///
/// See [Intl.DateTimeFormat](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Intl/DateTimeFormat) on MDN.
///
@external(javascript, "./date_time_format.type.ts", "DateTimeFormat$")
pub type DateTimeFormat

/// The presentation of a numeric date/time component. Maps the
/// JavaScript `"numeric" | "2-digit"` value set, shared by the
/// `year`, `day`, `hour`, `minute`, and `second` options.
///
pub type NumericWidth {
  /// Compact numeric form (`"3"` instead of `"03"`).
  Numeric

  /// Zero-padded two-digit form (`"03"` instead of `"3"`).
  TwoDigit
}

/// The format of the month component. Combines the numeric and
/// width-style presentations — months accept either.
///
pub type Month {
  /// Compact numeric form (`"3"` instead of `"03"`).
  MonthNumeric

  /// Zero-padded two-digit form (`"03"` instead of `"3"`).
  MonthTwoDigit

  /// Full name (`"March"`).
  MonthLong

  /// Shortened form (`"Mar"`).
  MonthShort

  /// The shortest form (`"M"`).
  MonthNarrow
}

/// The number of digits in the fractional-seconds component. Maps
/// the JavaScript `fractionalSecondDigits` option's `1 | 2 | 3`
/// value set.
///
pub type FractionalSecondDigits {
  /// Tenths-of-a-second precision (`"3"` for 0.3s).
  FractionalSeconds1

  /// Hundredths-of-a-second precision (`"30"` for 0.30s).
  FractionalSeconds2

  /// Milliseconds precision (`"300"` for 0.300s).
  FractionalSeconds3
}

/// The presentation of the time-zone label. Maps the JavaScript
/// `timeZoneName` option.
///
pub type TimeZoneName {
  /// Short locale-specific name (`"PST"`).
  TimeZoneShort

  /// Long locale-specific name (`"Pacific Standard Time"`).
  TimeZoneLong

  /// Short localized GMT-offset (`"GMT-8"`).
  TimeZoneShortOffset

  /// Long localized GMT-offset (`"GMT-08:00"`).
  TimeZoneLongOffset

  /// Short generic non-location name (`"PT"`).
  TimeZoneShortGeneric

  /// Long generic non-location name (`"Pacific Time"`).
  TimeZoneLongGeneric
}

/// A verbosity preset for date or time formatting. Used by
/// [`with_date_style`](#with_date_style) and
/// [`with_time_style`](#with_time_style).
///
pub type Style {
  /// Most verbose (`"Friday, May 15, 2026"`).
  StyleFull

  /// Verbose (`"May 15, 2026"`).
  StyleLong

  /// Standard (`"May 15, 2026"` for date; `"3:30:00 PM"` for time).
  StyleMedium

  /// Compact (`"5/15/26"` for date; `"3:30 PM"` for time).
  StyleShort
}

/// A single segment of a formatted date/time, returned by
/// [`format_to_parts`](#format_to_parts).
///
pub type Part {
  Part(kind: PartKind, value: String)
}

/// A single segment of a formatted date/time range, returned by
/// [`format_range_to_parts`](#format_range_to_parts). `source` is an
/// [`intl.RangePartSource`](../intl.html#RangePartSource)
/// identifying which side of the range produced the segment.
///
pub type RangePart {
  RangePart(kind: PartKind, value: String, source: RangePartSource)
}

/// The kind of a [`Part`](#Part) or [`RangePart`](#RangePart).
/// Mirrors the JavaScript `Intl.DateTimeFormatPart.type` field.
///
pub type PartKind {
  /// A literal segment (separator characters, connecting words).
  Literal

  /// The era component (`"AD"`, `"Anno Domini"`).
  Era

  /// The year component (`"2026"`, `"26"`).
  Year

  /// The Gregorian year that contains the formatted date, emitted
  /// alongside `YearName` for non-Gregorian calendars.
  RelatedYear

  /// The locale-specific year name (e.g., `"丙午"` for Chinese
  /// sexagenary years).
  YearName

  /// The month component (`"March"`, `"03"`).
  Month

  /// The day-of-month component (`"15"`, `"05"`).
  Day

  /// The day-of-week component (`"Friday"`, `"Fri"`).
  Weekday

  /// The hour component (`"3"`, `"15"`).
  Hour

  /// The minute component (`"30"`).
  Minute

  /// The second component (`"45"`).
  Second

  /// The fractional-seconds component (`"123"`).
  FractionalSecond

  /// The day-period component (`"AM"`, `"in the morning"`).
  DayPeriod

  /// The time-zone label (`"PST"`, `"GMT-08:00"`).
  TimeZoneName

  /// Any future part type the binding doesn't recognize, passed
  /// through verbatim.
  Other(String)
}

/// The configuration for a [`DateTimeFormat`](#DateTimeFormat).
///
pub opaque type Builder {
  Builder(
    locales: List(String),
    locale_matcher: Option(LocaleMatcher),
    calendar: Option(String),
    numbering_system: Option(String),
    hour12: Option(Bool),
    hour_cycle: Option(HourCycle),
    time_zone: Option(String),
    weekday: Option(LabelStyle),
    era: Option(LabelStyle),
    year: Option(NumericWidth),
    month: Option(Month),
    day: Option(NumericWidth),
    hour: Option(NumericWidth),
    minute: Option(NumericWidth),
    second: Option(NumericWidth),
    fractional_second_digits: Option(FractionalSecondDigits),
    time_zone_name: Option(TimeZoneName),
    day_period: Option(LabelStyle),
    date_style: Option(Style),
    time_style: Option(Style),
  )
}

/// Creates a `Builder` for the given locale priority list. The
/// runtime picks the first locale it supports; pass an empty list to
/// use the runtime's default locale.
///
pub fn new(locales: List(String)) -> Builder {
  Builder(
    locales:,
    locale_matcher: None,
    calendar: None,
    numbering_system: None,
    hour12: None,
    hour_cycle: None,
    time_zone: None,
    weekday: None,
    era: None,
    year: None,
    month: None,
    day: None,
    hour: None,
    minute: None,
    second: None,
    fractional_second_digits: None,
    time_zone_name: None,
    day_period: None,
    date_style: None,
    time_style: None,
  )
}

/// Sets the locale-matching algorithm used to pick a locale from the
/// priority list.
///
pub fn with_locale_matcher(builder: Builder, value: LocaleMatcher) -> Builder {
  Builder(..builder, locale_matcher: Some(value))
}

/// Sets the calendar identifier (e.g., `"gregory"`, `"chinese"`,
/// `"hebrew"`).
///
pub fn with_calendar(builder: Builder, value: String) -> Builder {
  Builder(..builder, calendar: Some(value))
}

/// Sets the numbering-system identifier (e.g., `"latn"`, `"arab"`,
/// `"hans"`).
///
pub fn with_numbering_system(builder: Builder, value: String) -> Builder {
  Builder(..builder, numbering_system: Some(value))
}

/// Sets whether time is rendered with a 12-hour clock (when `True`)
/// or a 24-hour clock (when `False`). The runtime picks a specific
/// [`intl.HourCycle`](../intl.html#HourCycle) compatible with the
/// locale. Takes precedence over
/// [`with_hour_cycle`](#with_hour_cycle) when both are set; use
/// [`with_hour_cycle`](#with_hour_cycle) alone to pick a specific
/// cycle.
///
pub fn with_hour12(builder: Builder, value: Bool) -> Builder {
  Builder(..builder, hour12: Some(value))
}

/// Sets the clock format directly. Ignored when
/// [`with_hour12`](#with_hour12) is also set.
///
pub fn with_hour_cycle(builder: Builder, value: HourCycle) -> Builder {
  Builder(..builder, hour_cycle: Some(value))
}

/// Sets the time-zone identifier (e.g., `"UTC"`,
/// `"America/Los_Angeles"`).
///
pub fn with_time_zone(builder: Builder, value: String) -> Builder {
  Builder(..builder, time_zone: Some(value))
}

/// Sets the format of the day-of-week component.
///
pub fn with_weekday(builder: Builder, value: LabelStyle) -> Builder {
  Builder(..builder, weekday: Some(value))
}

/// Sets the format of the era component.
///
pub fn with_era(builder: Builder, value: LabelStyle) -> Builder {
  Builder(..builder, era: Some(value))
}

/// Sets the format of the year component.
///
pub fn with_year(builder: Builder, value: NumericWidth) -> Builder {
  Builder(..builder, year: Some(value))
}

/// Sets the format of the month component.
///
pub fn with_month(builder: Builder, value: Month) -> Builder {
  Builder(..builder, month: Some(value))
}

/// Sets the format of the day-of-month component.
///
pub fn with_day(builder: Builder, value: NumericWidth) -> Builder {
  Builder(..builder, day: Some(value))
}

/// Sets the format of the hour component.
///
pub fn with_hour(builder: Builder, value: NumericWidth) -> Builder {
  Builder(..builder, hour: Some(value))
}

/// Sets the format of the minute component.
///
pub fn with_minute(builder: Builder, value: NumericWidth) -> Builder {
  Builder(..builder, minute: Some(value))
}

/// Sets the format of the second component.
///
pub fn with_second(builder: Builder, value: NumericWidth) -> Builder {
  Builder(..builder, second: Some(value))
}

/// Sets the number of digits in the fractional-seconds component.
///
pub fn with_fractional_second_digits(
  builder: Builder,
  value: FractionalSecondDigits,
) -> Builder {
  Builder(..builder, fractional_second_digits: Some(value))
}

/// Sets the format of the time-zone label.
///
pub fn with_time_zone_name(builder: Builder, value: TimeZoneName) -> Builder {
  Builder(..builder, time_zone_name: Some(value))
}

/// Sets the format of the day-period component (e.g., `"AM"` /
/// `"in the morning"`).
///
pub fn with_day_period(builder: Builder, value: LabelStyle) -> Builder {
  Builder(..builder, day_period: Some(value))
}

/// Sets a date verbosity preset. Cannot be combined with the
/// component-level setters ([`with_year`](#with_year),
/// [`with_month`](#with_month), etc.); doing so causes
/// [`build`](#build) to return `Error(Nil)`.
///
pub fn with_date_style(builder: Builder, value: Style) -> Builder {
  Builder(..builder, date_style: Some(value))
}

/// Sets a time verbosity preset. Cannot be combined with the
/// component-level setters ([`with_hour`](#with_hour),
/// [`with_minute`](#with_minute), etc.); doing so causes
/// [`build`](#build) to return `Error(Nil)`.
///
pub fn with_time_style(builder: Builder, value: Style) -> Builder {
  Builder(..builder, time_style: Some(value))
}

/// Constructs a [`DateTimeFormat`](#DateTimeFormat) from the
/// configured builder. Returns `Error(Nil)` if any locale tag,
/// calendar, numbering-system, or time-zone identifier is malformed,
/// or if [`with_date_style`](#with_date_style) or
/// [`with_time_style`](#with_time_style) was combined with any
/// component-level setter.
///
pub fn build(builder: Builder) -> Result(DateTimeFormat, Nil) {
  do_build(
    builder.locales,
    builder.locale_matcher,
    builder.calendar,
    builder.numbering_system,
    builder.hour12,
    builder.hour_cycle,
    builder.time_zone,
    builder.weekday,
    builder.era,
    builder.year,
    builder.month,
    builder.day,
    builder.hour,
    builder.minute,
    builder.second,
    builder.fractional_second_digits,
    builder.time_zone_name,
    builder.day_period,
    builder.date_style,
    builder.time_style,
  )
}

@external(javascript, "./date_time_format.ffi.mjs", "build")
@internal
pub fn do_build(
  locales: List(String),
  locale_matcher: Option(LocaleMatcher),
  calendar: Option(String),
  numbering_system: Option(String),
  hour12: Option(Bool),
  hour_cycle: Option(HourCycle),
  time_zone: Option(String),
  weekday: Option(LabelStyle),
  era: Option(LabelStyle),
  year: Option(NumericWidth),
  month: Option(Month),
  day: Option(NumericWidth),
  hour: Option(NumericWidth),
  minute: Option(NumericWidth),
  second: Option(NumericWidth),
  fractional_second_digits: Option(FractionalSecondDigits),
  time_zone_name: Option(TimeZoneName),
  day_period: Option(LabelStyle),
  date_style: Option(Style),
  time_style: Option(Style),
) -> Result(DateTimeFormat, Nil)

/// Formats `timestamp` as a locale-aware date/time string.
///
pub fn format(formatter: DateTimeFormat, timestamp: Timestamp) -> String {
  do_format(formatter, timestamp.to_unix_seconds(timestamp))
}

@external(javascript, "./date_time_format.ffi.mjs", "format")
@internal
pub fn do_format(formatter: DateTimeFormat, unix_seconds: Float) -> String

/// Formats `timestamp` and returns its decomposition into segments.
///
pub fn format_to_parts(
  formatter: DateTimeFormat,
  timestamp: Timestamp,
) -> List(Part) {
  do_format_to_parts(formatter, timestamp.to_unix_seconds(timestamp))
}

@external(javascript, "./date_time_format.ffi.mjs", "format_to_parts")
@internal
pub fn do_format_to_parts(
  formatter: DateTimeFormat,
  unix_seconds: Float,
) -> List(Part)

/// Formats `start`-`end` as a locale-aware date/time range. Passing
/// `end` earlier than `start` is well-defined and produces output —
/// the resulting string may not be meaningful but does not error.
///
pub fn format_range(
  formatter: DateTimeFormat,
  from start: Timestamp,
  to end: Timestamp,
) -> String {
  do_format_range(
    formatter,
    timestamp.to_unix_seconds(start),
    timestamp.to_unix_seconds(end),
  )
}

@external(javascript, "./date_time_format.ffi.mjs", "format_range")
@internal
pub fn do_format_range(
  formatter: DateTimeFormat,
  start_seconds: Float,
  end_seconds: Float,
) -> String

/// Formats `start`-`end` and returns its decomposition into segments
/// tagged by which side of the range produced each one.
///
pub fn format_range_to_parts(
  formatter: DateTimeFormat,
  from start: Timestamp,
  to end: Timestamp,
) -> List(RangePart) {
  do_format_range_to_parts(
    formatter,
    timestamp.to_unix_seconds(start),
    timestamp.to_unix_seconds(end),
  )
}

@external(javascript, "./date_time_format.ffi.mjs", "format_range_to_parts")
@internal
pub fn do_format_range_to_parts(
  formatter: DateTimeFormat,
  start_seconds: Float,
  end_seconds: Float,
) -> List(RangePart)

/// The BCP 47 locale tag the runtime resolved from the requested
/// priority list (e.g., `"en-US"`).
///
@external(javascript, "./date_time_format.ffi.mjs", "resolved_locale")
pub fn resolved_locale(formatter: DateTimeFormat) -> String

/// Filters `locales` to those the runtime supports for date/time
/// formatting, preserving the input order.
///
@external(javascript, "./date_time_format.ffi.mjs", "supported_locales_of")
pub fn supported_locales_of(locales: List(String)) -> List(String)
