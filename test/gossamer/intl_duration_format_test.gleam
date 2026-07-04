import gleam/list
import gleam/option.{Some}
import gleam/time/duration
import gleeunit/should
import gossamer/intl
import gossamer/intl/duration_format

pub fn build_default_test() {
  duration_format.new([]) |> duration_format.build |> should.be_ok
}

pub fn build_invalid_locale_test() {
  duration_format.new(["not_a_locale!"])
  |> duration_format.build
  |> should.be_error
}

pub fn format_long_test() {
  let assert Ok(formatter) =
    duration_format.new(["en-US"])
    |> duration_format.with_style(duration_format.StyleLong)
    |> duration_format.build
  duration_format.format(
    formatter,
    duration_format.DurationParts(..duration_format.zero, hours: 2, minutes: 30),
  )
  |> should.equal(Ok("2 hours, 30 minutes"))
}

pub fn format_short_test() {
  let assert Ok(formatter) =
    duration_format.new(["en-US"])
    |> duration_format.with_style(duration_format.StyleShort)
    |> duration_format.build
  duration_format.format(
    formatter,
    duration_format.DurationParts(..duration_format.zero, hours: 2, minutes: 30),
  )
  |> should.equal(Ok("2 hr, 30 min"))
}

pub fn format_narrow_test() {
  let assert Ok(formatter) =
    duration_format.new(["en-US"])
    |> duration_format.with_style(duration_format.StyleNarrow)
    |> duration_format.build
  duration_format.format(
    formatter,
    duration_format.DurationParts(..duration_format.zero, hours: 2, minutes: 30),
  )
  |> should.equal(Ok("2h 30m"))
}

pub fn format_digital_test() {
  let assert Ok(formatter) =
    duration_format.new(["en-US"])
    |> duration_format.with_style(duration_format.StyleDigital)
    |> duration_format.build
  duration_format.format(
    formatter,
    duration_format.DurationParts(
      ..duration_format.zero,
      hours: 2,
      minutes: 30,
      seconds: 45,
    ),
  )
  |> should.equal(Ok("2:30:45"))
}

pub fn format_all_zero_test() {
  let assert Ok(formatter) =
    duration_format.new(["en-US"]) |> duration_format.build
  duration_format.format(formatter, duration_format.zero)
  |> should.equal(Ok(""))
}

pub fn format_negative_test() {
  let assert Ok(formatter) =
    duration_format.new(["en-US"])
    |> duration_format.with_style(duration_format.StyleLong)
    |> duration_format.build
  duration_format.format(
    formatter,
    duration_format.DurationParts(..duration_format.zero, hours: -2),
  )
  |> should.equal(Ok("-2 hours"))
}

pub fn format_mixed_signs_test() {
  let assert Ok(formatter) =
    duration_format.new(["en-US"]) |> duration_format.build
  duration_format.format(
    formatter,
    duration_format.DurationParts(
      ..duration_format.zero,
      hours: 1,
      minutes: -30,
    ),
  )
  |> should.be_error
}

pub fn format_display_always_test() {
  let assert Ok(formatter) =
    duration_format.new(["en-US"])
    |> duration_format.with_style(duration_format.StyleLong)
    |> duration_format.with_years_display(duration_format.Always)
    |> duration_format.build
  duration_format.format(
    formatter,
    duration_format.DurationParts(..duration_format.zero, years: 0, hours: 2),
  )
  |> should.equal(Ok("0 years, 2 hours"))
}

pub fn format_clock_two_digit_test() {
  let assert Ok(formatter) =
    duration_format.new(["en-US"])
    |> duration_format.with_style(duration_format.StyleDigital)
    |> duration_format.with_hours(duration_format.ClockTwoDigit)
    |> duration_format.build
  duration_format.format(
    formatter,
    duration_format.DurationParts(..duration_format.zero, hours: 2, minutes: 30),
  )
  |> should.equal(Ok("02:30:00"))
}

pub fn format_fractional_digits_test() {
  let assert Ok(formatter) =
    duration_format.new(["en-US"])
    |> duration_format.with_style(duration_format.StyleDigital)
    |> duration_format.with_fractional_digits(duration_format.FractionalDigits3)
    |> duration_format.build
  duration_format.format(
    formatter,
    duration_format.DurationParts(
      ..duration_format.zero,
      hours: 1,
      minutes: 30,
      seconds: 45,
      milliseconds: 123,
    ),
  )
  |> should.equal(Ok("1:30:45.123"))
}

pub fn format_to_parts_test() {
  let assert Ok(formatter) =
    duration_format.new(["en-US"])
    |> duration_format.with_style(duration_format.StyleLong)
    |> duration_format.build
  let assert Ok(parts) =
    duration_format.format_to_parts(
      formatter,
      duration_format.DurationParts(..duration_format.zero, hours: 2),
    )
  list.is_empty(parts) |> should.be_false
  list.any(parts, fn(p) {
    case p {
      duration_format.Part(duration_format.Integer, "2", Some("hour")) -> True
      _ -> False
    }
  })
  |> should.be_true
}

pub fn format_to_parts_fractional_kinds_test() {
  let assert Ok(formatter) =
    duration_format.new(["en-US"])
    |> duration_format.with_style(duration_format.StyleDigital)
    |> duration_format.with_fractional_digits(duration_format.FractionalDigits3)
    |> duration_format.build
  let assert Ok(parts) =
    duration_format.format_to_parts(
      formatter,
      duration_format.DurationParts(
        ..duration_format.zero,
        seconds: 12,
        milliseconds: 500,
      ),
    )
  let kinds = list.map(parts, fn(part) { part.kind })
  list.contains(kinds, duration_format.Decimal) |> should.be_true
  list.contains(kinds, duration_format.Fraction) |> should.be_true
}

pub fn format_to_parts_group_kind_test() {
  let assert Ok(formatter) =
    duration_format.new(["en-US"])
    |> duration_format.with_style(duration_format.StyleLong)
    |> duration_format.build
  let assert Ok(parts) =
    duration_format.format_to_parts(
      formatter,
      duration_format.DurationParts(..duration_format.zero, seconds: 1_234_567),
    )
  let kinds = list.map(parts, fn(part) { part.kind })
  list.contains(kinds, duration_format.Group) |> should.be_true
}

pub fn supported_locales_of_test() {
  duration_format.supported_locales_of(["en-US", "fr"])
  |> should.equal(Ok(["en-US", "fr"]))
}

pub fn supported_locales_of_malformed_tag_test() {
  duration_format.supported_locales_of(["not_a_locale!"])
  |> should.be_error
}

pub fn resolved_options_test() {
  let assert Ok(formatter) =
    duration_format.new(["en-US"])
    |> duration_format.with_style(duration_format.StyleShort)
    |> duration_format.build
  let options = duration_format.resolved_options(formatter)
  options.locale |> should.equal("en-US")
  options.style |> should.equal(duration_format.StyleShort)
  options.years |> should.equal(intl.Short)
}

pub fn from_duration_test() {
  let d = duration.hours(2) |> duration.add(duration.minutes(30))
  duration_format.from_duration(d)
  |> should.equal(duration_format.DurationParts(
    years: 0,
    months: 0,
    weeks: 0,
    days: 0,
    hours: 2,
    minutes: 30,
    seconds: 0,
    milliseconds: 0,
    microseconds: 0,
    nanoseconds: 0,
  ))
}

pub fn format_duration_test() {
  let assert Ok(formatter) =
    duration_format.new(["en-US"])
    |> duration_format.with_style(duration_format.StyleLong)
    |> duration_format.build
  duration_format.format_duration(formatter, duration.hours(2))
  |> should.equal("2 hours")
}

pub fn format_duration_to_parts_test() {
  let assert Ok(formatter) =
    duration_format.new(["en-US"]) |> duration_format.build
  duration_format.format_duration_to_parts(formatter, duration.hours(2))
  |> should.not_equal([])
}

pub fn from_duration_with_subseconds_test() {
  let d = duration.milliseconds(1500)
  let parts = duration_format.from_duration(d)
  parts.seconds |> should.equal(1)
  parts.milliseconds |> should.equal(500)
}

pub fn from_duration_negative_subseconds_test() {
  let parts = duration_format.from_duration(duration.milliseconds(-1500))
  parts.seconds |> should.equal(-1)
  parts.milliseconds |> should.equal(-500)
  let assert Ok(formatter) =
    duration_format.new(["en-US"]) |> duration_format.build
  duration_format.format(formatter, parts) |> should.be_ok
}

pub fn from_duration_negative_whole_seconds_test() {
  let parts = duration_format.from_duration(duration.seconds(-3700))
  parts.hours |> should.equal(-1)
  parts.minutes |> should.equal(-1)
  parts.seconds |> should.equal(-40)
  parts.milliseconds |> should.equal(0)
}
