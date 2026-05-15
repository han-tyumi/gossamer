import gleam/option
import gleeunit/should
import gossamer/intl
import gossamer/intl/relative_time_format

pub fn build_default_test() {
  relative_time_format.new([]) |> relative_time_format.build |> should.be_ok
}

pub fn build_invalid_locale_test() {
  relative_time_format.new(["not_a_locale!"])
  |> relative_time_format.build
  |> should.be_error
}

pub fn format_int_future_test() {
  let assert Ok(formatter) =
    relative_time_format.new(["en-US"]) |> relative_time_format.build
  relative_time_format.format_int(formatter, 1, in: relative_time_format.Day)
  |> should.equal("in 1 day")
}

pub fn format_int_past_test() {
  let assert Ok(formatter) =
    relative_time_format.new(["en-US"]) |> relative_time_format.build
  relative_time_format.format_int(formatter, -1, in: relative_time_format.Day)
  |> should.equal("1 day ago")
}

pub fn format_float_test() {
  let assert Ok(formatter) =
    relative_time_format.new(["en-US"]) |> relative_time_format.build
  relative_time_format.format_float(
    formatter,
    1.5,
    in: relative_time_format.Hour,
  )
  |> should.equal("in 1.5 hours")
}

pub fn format_numeric_auto_test() {
  let assert Ok(formatter) =
    relative_time_format.new(["en-US"])
    |> relative_time_format.with_numeric(relative_time_format.Auto)
    |> relative_time_format.build
  relative_time_format.format_int(formatter, -1, in: relative_time_format.Day)
  |> should.equal("yesterday")
  relative_time_format.format_int(formatter, 1, in: relative_time_format.Day)
  |> should.equal("tomorrow")
}

pub fn format_style_short_test() {
  let assert Ok(formatter) =
    relative_time_format.new(["en-US"])
    |> relative_time_format.with_style(intl.Short)
    |> relative_time_format.build
  relative_time_format.format_int(formatter, 1, in: relative_time_format.Month)
  |> should.equal("in 1 mo.")
}

pub fn format_style_narrow_test() {
  let assert Ok(formatter) =
    relative_time_format.new(["en-US"])
    |> relative_time_format.with_style(intl.Narrow)
    |> relative_time_format.build
  relative_time_format.format_int(formatter, 1, in: relative_time_format.Month)
  |> should.equal("in 1mo")
}

pub fn format_all_units_test() {
  let assert Ok(formatter) =
    relative_time_format.new(["en-US"]) |> relative_time_format.build
  relative_time_format.format_int(formatter, 2, in: relative_time_format.Year)
  |> should.equal("in 2 years")
  relative_time_format.format_int(
    formatter,
    2,
    in: relative_time_format.Quarter,
  )
  |> should.equal("in 2 quarters")
  relative_time_format.format_int(formatter, 2, in: relative_time_format.Month)
  |> should.equal("in 2 months")
  relative_time_format.format_int(formatter, 2, in: relative_time_format.Week)
  |> should.equal("in 2 weeks")
  relative_time_format.format_int(formatter, 2, in: relative_time_format.Day)
  |> should.equal("in 2 days")
  relative_time_format.format_int(formatter, 2, in: relative_time_format.Hour)
  |> should.equal("in 2 hours")
  relative_time_format.format_int(formatter, 2, in: relative_time_format.Minute)
  |> should.equal("in 2 minutes")
  relative_time_format.format_int(formatter, 2, in: relative_time_format.Second)
  |> should.equal("in 2 seconds")
}

pub fn format_int_to_parts_test() {
  let assert Ok(formatter) =
    relative_time_format.new(["en-US"]) |> relative_time_format.build
  let parts =
    relative_time_format.format_int_to_parts(
      formatter,
      1,
      in: relative_time_format.Day,
    )
  // First part is "in " literal with no unit.
  case parts {
    [first, ..] -> {
      first.kind |> should.equal(relative_time_format.Literal)
      first.unit |> should.equal(option.None)
    }
    [] -> panic as "expected non-empty parts"
  }
}

pub fn format_float_to_parts_test() {
  let assert Ok(formatter) =
    relative_time_format.new(["en-US"]) |> relative_time_format.build
  relative_time_format.format_float_to_parts(
    formatter,
    1.5,
    in: relative_time_format.Hour,
  )
  |> should.not_equal([])
}

pub fn resolved_locale_test() {
  let assert Ok(formatter) =
    relative_time_format.new(["en-US"]) |> relative_time_format.build
  relative_time_format.resolved_locale(formatter) |> should.equal("en-US")
}

pub fn supported_locales_of_test() {
  relative_time_format.supported_locales_of(["en-US", "zz-INVALID"])
  |> should.equal(["en-US"])
}
