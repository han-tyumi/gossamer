import gleeunit/should
import gossamer/big_int
import gossamer/intl/number_format

pub fn build_default_test() {
  number_format.new([]) |> number_format.build |> should.be_ok
}

pub fn build_single_locale_test() {
  number_format.new(["en-US"]) |> number_format.build |> should.be_ok
}

pub fn build_invalid_locale_test() {
  number_format.new(["not_a_locale!"]) |> number_format.build |> should.be_error
}

pub fn build_invalid_currency_test() {
  number_format.new(["en-US"])
  |> number_format.with_style(number_format.StyleCurrency)
  |> number_format.with_currency("INVALID_CURRENCY_CODE!")
  |> number_format.build
  |> should.be_error
}

pub fn format_float_test() {
  let assert Ok(formatter) = number_format.new(["en-US"]) |> number_format.build
  number_format.format_float(formatter, 1234.5) |> should.equal("1,234.5")
}

pub fn format_int_test() {
  let assert Ok(formatter) = number_format.new(["en-US"]) |> number_format.build
  number_format.format_int(formatter, 1234) |> should.equal("1,234")
}

pub fn format_big_int_test() {
  let assert Ok(formatter) = number_format.new(["en-US"]) |> number_format.build
  number_format.format_big_int(formatter, big_int.from_int(1_234_567))
  |> should.equal("1,234,567")
}

pub fn format_currency_test() {
  let assert Ok(formatter) =
    number_format.new(["en-US"])
    |> number_format.with_style(number_format.StyleCurrency)
    |> number_format.with_currency("USD")
    |> number_format.build
  number_format.format_float(formatter, 1234.5) |> should.equal("$1,234.50")
}

pub fn format_percent_test() {
  let assert Ok(formatter) =
    number_format.new(["en-US"])
    |> number_format.with_style(number_format.StylePercent)
    |> number_format.build
  number_format.format_float(formatter, 0.25) |> should.equal("25%")
}

pub fn format_unit_test() {
  let assert Ok(formatter) =
    number_format.new(["en-US"])
    |> number_format.with_style(number_format.StyleUnit)
    |> number_format.with_unit("meter")
    |> number_format.build
  number_format.format_float(formatter, 5.0) |> should.equal("5 m")
}

pub fn format_no_grouping_test() {
  let assert Ok(formatter) =
    number_format.new(["en-US"])
    |> number_format.with_use_grouping(number_format.UseGroupingOff)
    |> number_format.build
  number_format.format_float(formatter, 1234.5) |> should.equal("1234.5")
}

pub fn format_minimum_fraction_digits_test() {
  let assert Ok(formatter) =
    number_format.new(["en-US"])
    |> number_format.with_minimum_fraction_digits(2)
    |> number_format.build
  number_format.format_float(formatter, 1.0) |> should.equal("1.00")
}

pub fn format_scientific_notation_test() {
  let assert Ok(formatter) =
    number_format.new(["en-US"])
    |> number_format.with_notation(number_format.NotationScientific)
    |> number_format.build
  number_format.format_float(formatter, 1234.0) |> should.equal("1.234E3")
}

pub fn format_sign_display_always_test() {
  let assert Ok(formatter) =
    number_format.new(["en-US"])
    |> number_format.with_sign_display(number_format.SignAlways)
    |> number_format.build
  number_format.format_float(formatter, 5.0) |> should.equal("+5")
}

pub fn format_sign_display_negative_test() {
  let assert Ok(formatter) =
    number_format.new(["en-US"])
    |> number_format.with_sign_display(number_format.SignNegative)
    |> number_format.build
  number_format.format_float(formatter, 0.0) |> should.equal("0")
  number_format.format_float(formatter, -5.0) |> should.equal("-5")
}

pub fn format_use_grouping_min2_test() {
  let assert Ok(formatter) =
    number_format.new(["en-US"])
    |> number_format.with_use_grouping(number_format.UseGroupingMin2)
    |> number_format.build
  number_format.format_int(formatter, 1000) |> should.equal("1000")
  number_format.format_int(formatter, 10_000) |> should.equal("10,000")
}

pub fn format_compact_notation_test() {
  let assert Ok(formatter) =
    number_format.new(["en-US"])
    |> number_format.with_notation(number_format.NotationCompact)
    |> number_format.with_compact_display(number_format.CompactLong)
    |> number_format.build
  number_format.format_int(formatter, 1200)
  |> should.equal("1.2 thousand")
}

pub fn format_currency_accounting_test() {
  let assert Ok(formatter) =
    number_format.new(["en-US"])
    |> number_format.with_style(number_format.StyleCurrency)
    |> number_format.with_currency("USD")
    |> number_format.with_currency_sign(number_format.CurrencySignAccounting)
    |> number_format.build
  number_format.format_float(formatter, -5.0) |> should.equal("($5.00)")
}

pub fn format_rounding_mode_floor_test() {
  let assert Ok(formatter) =
    number_format.new(["en-US"])
    |> number_format.with_maximum_fraction_digits(0)
    |> number_format.with_rounding_mode(number_format.RoundingModeFloor)
    |> number_format.build
  number_format.format_float(formatter, 1.9) |> should.equal("1")
  number_format.format_float(formatter, -1.1) |> should.equal("-2")
}

pub fn format_rounding_mode_ceil_test() {
  let assert Ok(formatter) =
    number_format.new(["en-US"])
    |> number_format.with_maximum_fraction_digits(0)
    |> number_format.with_rounding_mode(number_format.RoundingModeCeil)
    |> number_format.build
  number_format.format_float(formatter, 1.1) |> should.equal("2")
  number_format.format_float(formatter, -1.9) |> should.equal("-1")
}

pub fn format_rounding_mode_half_even_test() {
  let assert Ok(formatter) =
    number_format.new(["en-US"])
    |> number_format.with_maximum_fraction_digits(0)
    |> number_format.with_rounding_mode(number_format.RoundingModeHalfEven)
    |> number_format.build
  number_format.format_float(formatter, 2.5) |> should.equal("2")
  number_format.format_float(formatter, 3.5) |> should.equal("4")
}

pub fn format_rounding_increment_test() {
  let assert Ok(formatter) =
    number_format.new(["en-US"])
    |> number_format.with_maximum_fraction_digits(0)
    |> number_format.with_minimum_fraction_digits(0)
    |> number_format.with_rounding_increment(5)
    |> number_format.build
  number_format.format_int(formatter, 12) |> should.equal("10")
  number_format.format_int(formatter, 13) |> should.equal("15")
}

pub fn format_rounding_increment_invalid_test() {
  number_format.new(["en-US"])
  |> number_format.with_rounding_increment(3)
  |> number_format.build
  |> should.be_error
}

pub fn format_rounding_priority_more_precision_test() {
  let assert Ok(formatter) =
    number_format.new(["en-US"])
    |> number_format.with_maximum_significant_digits(3)
    |> number_format.with_maximum_fraction_digits(2)
    |> number_format.with_rounding_priority(
      number_format.RoundingPriorityMorePrecision,
    )
    |> number_format.build
  // Significant digits (3) wins over fraction digits (2).
  number_format.format_float(formatter, 1.2345) |> should.equal("1.23")
}

pub fn format_trailing_zero_strip_test() {
  let assert Ok(formatter) =
    number_format.new(["en-US"])
    |> number_format.with_minimum_fraction_digits(2)
    |> number_format.with_trailing_zero_display(
      number_format.TrailingZeroStripIfInteger,
    )
    |> number_format.build
  number_format.format_float(formatter, 1.0) |> should.equal("1")
  number_format.format_float(formatter, 1.5) |> should.equal("1.50")
}

pub fn format_to_parts_test() {
  let assert Ok(formatter) =
    number_format.new(["en-US"])
    |> number_format.with_style(number_format.StyleCurrency)
    |> number_format.with_currency("USD")
    |> number_format.build
  let parts = number_format.format_float_to_parts(formatter, 1234.5)
  case parts {
    [first, ..] -> first.kind |> should.equal(number_format.PartCurrency)
    [] -> panic as "expected non-empty parts"
  }
}

pub fn format_range_test() {
  let assert Ok(formatter) =
    number_format.new(["en-US"])
    |> number_format.with_style(number_format.StyleCurrency)
    |> number_format.with_currency("USD")
    |> number_format.build
  let assert Ok(result) =
    number_format.format_float_range(formatter, from: 3.0, to: 10.0)
  result |> should.equal("$3.00 – $10.00")
}

pub fn format_int_range_test() {
  let assert Ok(formatter) = number_format.new(["en-US"]) |> number_format.build
  number_format.format_int_range(formatter, from: 1, to: 5) |> should.be_ok
}

pub fn format_big_int_range_test() {
  let assert Ok(formatter) = number_format.new(["en-US"]) |> number_format.build
  number_format.format_big_int_range(
    formatter,
    from: big_int.from_int(1),
    to: big_int.from_int(5),
  )
  |> should.be_ok
}

pub fn format_range_to_parts_test() {
  let assert Ok(formatter) = number_format.new(["en-US"]) |> number_format.build
  let assert Ok(parts) =
    number_format.format_float_range_to_parts(formatter, from: 1.0, to: 5.0)
  // First part should be from the start side.
  case parts {
    [first, ..] -> first.source |> should.equal(number_format.Start)
    [] -> panic as "expected non-empty parts"
  }
}

pub fn resolved_locale_test() {
  let assert Ok(formatter) = number_format.new(["en-US"]) |> number_format.build
  number_format.resolved_locale(formatter) |> should.equal("en-US")
}

pub fn supported_locales_of_test() {
  number_format.supported_locales_of(["en-US", "zz-INVALID"])
  |> should.equal(["en-US"])
}
