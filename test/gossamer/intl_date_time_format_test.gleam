import gleam/list
import gleam/string
import gleam/time/timestamp.{type Timestamp}
import gleeunit/should
import gossamer/intl
import gossamer/intl/date_time_format

// 2025-05-15T14:30:45.123Z — a fixed UTC instant used across tests.
fn fixed() -> Timestamp {
  let assert Ok(t) = timestamp.parse_rfc3339("2025-05-15T14:30:45.123Z")
  t
}

fn at(year_month_day: String) -> Timestamp {
  let assert Ok(t) = timestamp.parse_rfc3339(year_month_day <> "T00:00:00Z")
  t
}

fn utc_format() {
  date_time_format.new(["en-US"])
  |> date_time_format.with_time_zone("UTC")
}

pub fn build_default_test() {
  date_time_format.new([]) |> date_time_format.build |> should.be_ok
}

pub fn build_invalid_locale_test() {
  date_time_format.new(["not_a_locale!"])
  |> date_time_format.build
  |> should.be_error
}

pub fn build_invalid_time_zone_test() {
  date_time_format.new(["en-US"])
  |> date_time_format.with_time_zone("Not/A_Zone")
  |> date_time_format.build
  |> should.be_error
}

pub fn build_date_style_with_components_conflicts_test() {
  date_time_format.new(["en-US"])
  |> date_time_format.with_date_style(date_time_format.StyleFull)
  |> date_time_format.with_year(date_time_format.Numeric)
  |> date_time_format.build
  |> should.be_error
}

pub fn build_time_style_with_components_conflicts_test() {
  date_time_format.new(["en-US"])
  |> date_time_format.with_time_style(date_time_format.StyleFull)
  |> date_time_format.with_hour(date_time_format.Numeric)
  |> date_time_format.build
  |> should.be_error
}

pub fn format_year_month_day_test() {
  let assert Ok(fmt) =
    utc_format()
    |> date_time_format.with_year(date_time_format.Numeric)
    |> date_time_format.with_month(date_time_format.MonthLong)
    |> date_time_format.with_day(date_time_format.Numeric)
    |> date_time_format.build
  date_time_format.format(fmt, fixed())
  |> should.equal("May 15, 2025")
}

pub fn format_year_two_digit_test() {
  let assert Ok(fmt) =
    utc_format()
    |> date_time_format.with_year(date_time_format.TwoDigit)
    |> date_time_format.build
  date_time_format.format(fmt, fixed()) |> should.equal("25")
}

pub fn format_month_numeric_test() {
  let assert Ok(fmt) =
    utc_format()
    |> date_time_format.with_month(date_time_format.MonthNumeric)
    |> date_time_format.build
  date_time_format.format(fmt, fixed()) |> should.equal("5")
}

pub fn format_month_two_digit_test() {
  let assert Ok(fmt) =
    utc_format()
    |> date_time_format.with_month(date_time_format.MonthTwoDigit)
    |> date_time_format.build
  date_time_format.format(fmt, fixed()) |> should.equal("05")
}

pub fn format_month_narrow_test() {
  let assert Ok(fmt) =
    utc_format()
    |> date_time_format.with_month(date_time_format.MonthNarrow)
    |> date_time_format.build
  date_time_format.format(fmt, fixed()) |> should.equal("M")
}

pub fn format_weekday_long_test() {
  let assert Ok(fmt) =
    utc_format()
    |> date_time_format.with_weekday(intl.Long)
    |> date_time_format.build
  date_time_format.format(fmt, fixed()) |> should.equal("Thursday")
}

pub fn format_weekday_narrow_test() {
  let assert Ok(fmt) =
    utc_format()
    |> date_time_format.with_weekday(intl.Narrow)
    |> date_time_format.build
  date_time_format.format(fmt, fixed()) |> should.equal("T")
}

pub fn format_era_long_test() {
  let assert Ok(fmt) =
    utc_format()
    |> date_time_format.with_year(date_time_format.Numeric)
    |> date_time_format.with_era(intl.Long)
    |> date_time_format.build
  date_time_format.format(fmt, fixed())
  |> should.equal("2025 Anno Domini")
}

pub fn format_hour_minute_test() {
  let assert Ok(fmt) =
    utc_format()
    |> date_time_format.with_hour(date_time_format.Numeric)
    |> date_time_format.with_minute(date_time_format.TwoDigit)
    |> date_time_format.with_hour_cycle(intl.H23)
    |> date_time_format.build
  date_time_format.format(fmt, fixed()) |> should.equal("14:30")
}

pub fn format_second_test() {
  let assert Ok(fmt) =
    utc_format()
    |> date_time_format.with_second(date_time_format.TwoDigit)
    |> date_time_format.with_hour_cycle(intl.H23)
    |> date_time_format.build
  // hour is implied by the presence of second; assert it contains "45".
  date_time_format.format(fmt, fixed())
  |> string.contains("45")
  |> should.be_true
}

pub fn format_fractional_seconds_test() {
  let assert Ok(fmt) =
    utc_format()
    |> date_time_format.with_second(date_time_format.TwoDigit)
    |> date_time_format.with_fractional_second_digits(
      date_time_format.FractionalSeconds3,
    )
    |> date_time_format.with_hour_cycle(intl.H23)
    |> date_time_format.build
  date_time_format.format(fmt, fixed())
  |> string.contains("123")
  |> should.be_true
}

pub fn format_hour12_true_test() {
  let assert Ok(fmt) =
    utc_format()
    |> date_time_format.with_hour(date_time_format.Numeric)
    |> date_time_format.with_hour12(True)
    |> date_time_format.build
  // 14:30 UTC -> 2 PM (AM/PM marker present).
  let output = date_time_format.format(fmt, fixed())
  output |> string.contains("2") |> should.be_true
  output |> string.contains("PM") |> should.be_true
}

pub fn format_hour_cycle_h23_test() {
  let assert Ok(fmt) =
    utc_format()
    |> date_time_format.with_hour(date_time_format.Numeric)
    |> date_time_format.with_hour_cycle(intl.H23)
    |> date_time_format.build
  date_time_format.format(fmt, fixed()) |> should.equal("14")
}

pub fn format_time_zone_name_long_test() {
  let assert Ok(fmt) =
    utc_format()
    |> date_time_format.with_hour(date_time_format.Numeric)
    |> date_time_format.with_time_zone_name(date_time_format.TimeZoneLong)
    |> date_time_format.build
  date_time_format.format(fmt, fixed())
  |> string.contains("Coordinated Universal Time")
  |> should.be_true
}

pub fn format_time_zone_name_offset_test() {
  let assert Ok(fmt) =
    utc_format()
    |> date_time_format.with_hour(date_time_format.Numeric)
    |> date_time_format.with_time_zone_name(date_time_format.TimeZoneLongOffset)
    |> date_time_format.build
  date_time_format.format(fmt, fixed())
  |> string.contains("GMT")
  |> should.be_true
}

pub fn format_with_time_zone_test() {
  let assert Ok(fmt) =
    date_time_format.new(["en-US"])
    |> date_time_format.with_time_zone("America/New_York")
    |> date_time_format.with_hour(date_time_format.Numeric)
    |> date_time_format.with_hour_cycle(intl.H23)
    |> date_time_format.build
  // 14:30 UTC is 10:30 EDT in May.
  date_time_format.format(fmt, fixed()) |> should.equal("10")
}

pub fn format_date_style_test() {
  let assert Ok(fmt) =
    utc_format()
    |> date_time_format.with_date_style(date_time_format.StyleShort)
    |> date_time_format.build
  date_time_format.format(fmt, fixed()) |> should.equal("5/15/25")
}

pub fn format_time_style_short_test() {
  let assert Ok(fmt) =
    utc_format()
    |> date_time_format.with_time_style(date_time_format.StyleShort)
    |> date_time_format.with_hour_cycle(intl.H23)
    |> date_time_format.build
  date_time_format.format(fmt, fixed()) |> should.equal("14:30")
}

pub fn format_with_calendar_test() {
  let assert Ok(fmt) =
    utc_format()
    |> date_time_format.with_calendar("chinese")
    |> date_time_format.with_year(date_time_format.Numeric)
    |> date_time_format.with_month(date_time_format.MonthNumeric)
    |> date_time_format.with_day(date_time_format.Numeric)
    |> date_time_format.build
  // Chinese calendar produces non-Gregorian output; just verify it
  // differs from the Gregorian formatting.
  let assert Ok(default_fmt) =
    utc_format()
    |> date_time_format.with_year(date_time_format.Numeric)
    |> date_time_format.with_month(date_time_format.MonthNumeric)
    |> date_time_format.with_day(date_time_format.Numeric)
    |> date_time_format.build
  let chinese_output = date_time_format.format(fmt, fixed())
  let gregorian_output = date_time_format.format(default_fmt, fixed())
  { chinese_output != gregorian_output } |> should.be_true
}

pub fn format_with_numbering_system_test() {
  let assert Ok(fmt) =
    utc_format()
    |> date_time_format.with_year(date_time_format.Numeric)
    |> date_time_format.with_numbering_system("arab")
    |> date_time_format.build
  // Arabic-Indic digits for 2025: ٢٠٢٥
  date_time_format.format(fmt, fixed()) |> should.equal("٢٠٢٥")
}

pub fn format_to_parts_test() {
  let assert Ok(fmt) =
    utc_format()
    |> date_time_format.with_year(date_time_format.Numeric)
    |> date_time_format.with_month(date_time_format.MonthLong)
    |> date_time_format.with_day(date_time_format.Numeric)
    |> date_time_format.build
  let parts = date_time_format.format_to_parts(fmt, fixed())
  { parts != [] } |> should.be_true
  let kinds = list.map(parts, fn(p) { p.kind })
  list.contains(kinds, date_time_format.PartMonth) |> should.be_true
  list.contains(kinds, date_time_format.PartDay) |> should.be_true
  list.contains(kinds, date_time_format.PartYear) |> should.be_true
}

pub fn format_to_parts_year_name_test() {
  let assert Ok(fmt) =
    date_time_format.new(["zh-u-ca-chinese"])
    |> date_time_format.with_time_zone("UTC")
    |> date_time_format.with_year(date_time_format.Numeric)
    |> date_time_format.build
  let parts = date_time_format.format_to_parts(fmt, fixed())
  let kinds = list.map(parts, fn(p) { p.kind })
  // The Chinese calendar emits a `yearName` segment. Deno and Node
  // additionally emit a `relatedYear`; Bun does not, so this test only
  // asserts the cross-runtime-stable segment.
  list.contains(kinds, date_time_format.PartYearName) |> should.be_true
}

pub fn format_range_test() {
  let assert Ok(fmt) =
    utc_format()
    |> date_time_format.with_year(date_time_format.Numeric)
    |> date_time_format.with_month(date_time_format.MonthLong)
    |> date_time_format.with_day(date_time_format.Numeric)
    |> date_time_format.build
  // The exact spacing around the en dash differs across runtimes (Bun
  // uses regular spaces; Deno and Node use U+2009 thin spaces), so
  // verify substrings instead.
  let output =
    date_time_format.format_range(
      fmt,
      from: at("2025-05-08"),
      to: at("2025-05-15"),
    )
  output |> string.contains("May 8") |> should.be_true
  output |> string.contains("15, 2025") |> should.be_true
  output |> string.contains("–") |> should.be_true
}

pub fn format_range_reverse_does_not_throw_test() {
  let assert Ok(fmt) =
    utc_format()
    |> date_time_format.with_year(date_time_format.Numeric)
    |> date_time_format.with_month(date_time_format.MonthLong)
    |> date_time_format.with_day(date_time_format.Numeric)
    |> date_time_format.build
  // End-before-start is well-defined per spec; output is locale-dependent
  // but should be non-empty.
  date_time_format.format_range(
    fmt,
    from: at("2025-05-15"),
    to: at("2025-05-08"),
  )
  |> string.is_empty
  |> should.be_false
}

pub fn format_range_to_parts_test() {
  let assert Ok(fmt) =
    utc_format()
    |> date_time_format.with_year(date_time_format.Numeric)
    |> date_time_format.with_month(date_time_format.MonthLong)
    |> date_time_format.with_day(date_time_format.Numeric)
    |> date_time_format.build
  let parts =
    date_time_format.format_range_to_parts(
      fmt,
      from: at("2025-05-08"),
      to: at("2025-05-15"),
    )
  let sources = list.map(parts, fn(p) { p.source })
  list.contains(sources, intl.Start) |> should.be_true
  list.contains(sources, intl.End) |> should.be_true
}

pub fn resolved_locale_test() {
  let assert Ok(fmt) = date_time_format.new(["en-US"]) |> date_time_format.build
  date_time_format.resolved_locale(fmt) |> should.equal("en-US")
}

pub fn supported_locales_of_test() {
  date_time_format.supported_locales_of(["en-US", "zz-INVALID"])
  |> should.equal(["en-US"])
}
