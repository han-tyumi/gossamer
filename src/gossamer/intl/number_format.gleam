//// Locale-aware number formatting via the JavaScript
//// `Intl.NumberFormat`. Configure with [`new`](#new) and chain
//// `with_*` setters before calling [`build`](#build). Reusing a built
//// [`NumberFormat`](#NumberFormat) across many calls is significantly
//// faster than building one per call.
////
//// Formatting is bound per numeric type — `format_float`,
//// `format_int`, and `format_big_int` — each with matching
//// `*_to_parts`, `*_range`, and `*_range_to_parts` variants.

import gleam/option.{type Option, None, Some}
import gossamer/big_int.{type BigInt}

/// A configured number formatter that produces locale-aware string
/// output for numeric input.
///
/// See [Intl.NumberFormat](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Intl/NumberFormat) on MDN.
///
@external(javascript, "./number_format.type.ts", "NumberFormat$")
pub type NumberFormat

/// The high-level formatting style. Maps the JavaScript `style`
/// option.
///
pub type Style {
  /// Plain decimal numbers (the default).
  StyleDecimal

  /// Currency amounts. Requires a currency code set via
  /// [`with_currency`](#with_currency).
  StyleCurrency

  /// Percentages — input values are multiplied by 100 for display
  /// (`0.25` formats as `"25%"`).
  StylePercent

  /// Measurements. Requires a unit identifier set via
  /// [`with_unit`](#with_unit).
  StyleUnit
}

/// How currency is presented. Maps the JavaScript `currencyDisplay`
/// option.
///
pub type CurrencyDisplay {
  /// The ISO 4217 currency code (`"USD"`).
  CurrencyCode

  /// The localized currency symbol (`"$"`, the default).
  CurrencySymbol

  /// The narrow currency symbol where available (`"$"` rather than
  /// `"US$"`).
  CurrencyNarrowSymbol

  /// The localized currency name (`"US dollars"`).
  CurrencyName
}

/// How negative currency amounts are presented. Maps the JavaScript
/// `currencySign` option.
///
pub type CurrencySign {
  /// Standard minus-sign notation (`"-$1.00"`, the default).
  CurrencySignStandard

  /// Accounting notation, often parentheses (`"($1.00)"`).
  CurrencySignAccounting
}

/// How a measurement unit is presented. Maps the JavaScript
/// `unitDisplay` option.
///
pub type UnitDisplay {
  /// The long unit form (`"16 liters"`).
  UnitLong

  /// The short unit form (`"16 L"`, the default).
  UnitShort

  /// The narrow unit form (`"16L"`).
  UnitNarrow
}

/// Whether and when to insert grouping separators. Maps the
/// JavaScript `useGrouping` option.
///
pub type UseGrouping {
  /// Group regardless of locale convention.
  UseGroupingAlways

  /// Group following the locale's convention (the default).
  UseGroupingAuto

  /// Group only when there are at least two digits in a group.
  UseGroupingMin2

  /// Never insert grouping separators.
  UseGroupingOff
}

/// The numeric notation. Maps the JavaScript `notation` option.
///
pub type Notation {
  /// Plain decimal notation (`"1,234"`, the default).
  NotationStandard

  /// Scientific notation (`"1.234E3"`).
  NotationScientific

  /// Engineering notation — exponents are always multiples of three
  /// (`"1.234E3"`).
  NotationEngineering

  /// Compact human-readable notation (`"1.2K"` or `"1.2 thousand"`,
  /// depending on [`CompactDisplay`](#CompactDisplay)).
  NotationCompact
}

/// Whether [`NotationCompact`](#NotationCompact) uses short or long
/// labels. Maps the JavaScript `compactDisplay` option.
///
pub type CompactDisplay {
  /// Short labels (`"1.2K"`, the default).
  CompactShort

  /// Long labels (`"1.2 thousand"`).
  CompactLong
}

/// The rounding strategy applied to the formatter's output. Maps the
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

/// When to render an explicit sign. Maps the JavaScript `signDisplay`
/// option.
///
pub type SignDisplay {
  /// Render the sign only for negative numbers (the default).
  SignAuto

  /// Render the sign for all numbers, including zero.
  SignAlways

  /// Render the sign for all non-zero numbers.
  SignExceptZero

  /// Render the sign only for numbers the formatter considers
  /// negative (including negative zero, depending on locale).
  SignNegative

  /// Never render an explicit sign.
  SignNever
}

/// A single segment of a formatted number, returned by the
/// `format_*_to_parts` family.
///
pub type Part {
  Part(kind: PartKind, value: String)
}

/// The kind of a [`Part`](#Part). Mirrors the JavaScript
/// `Intl.NumberFormatPart.type` field.
///
pub type PartKind {
  /// A literal string (separator words, punctuation, etc.).
  PartLiteral

  /// The integer portion.
  PartInteger

  /// The decimal separator (`"."` or `","` per locale).
  PartDecimal

  /// The fractional portion.
  PartFraction

  /// A digit-group separator (`","` or `" "` per locale).
  PartGroup

  /// A minus sign.
  PartMinusSign

  /// A plus sign.
  PartPlusSign

  /// A currency symbol or name.
  PartCurrency

  /// The percent sign.
  PartPercentSign

  /// A compact-notation literal (`"K"`, `"thousand"`).
  PartCompact

  /// The integer portion of a scientific or engineering exponent.
  PartExponentInteger

  /// A minus sign on a scientific or engineering exponent.
  PartExponentMinusSign

  /// The `"E"` separator on a scientific or engineering exponent.
  PartExponentSeparator

  /// The literal infinity symbol (`"∞"`).
  PartInfinity

  /// The literal NaN representation.
  PartNan

  /// A measurement unit name or symbol.
  PartUnit

  /// Any future part kind the binding doesn't recognize, passed
  /// through verbatim.
  PartUnknown(String)
}

/// A single segment of a formatted number range, returned by the
/// `format_*_range_to_parts` family. Like [`Part`](#Part) but also
/// carries a [`RangePartSource`](#RangePartSource) identifying which
/// endpoint the segment came from.
///
pub type RangePart {
  RangePart(kind: PartKind, value: String, source: RangePartSource)
}

/// Which endpoint of a formatted range a [`RangePart`](#RangePart)
/// belongs to.
///
pub type RangePartSource {
  /// The segment is part of the range's start value.
  Start

  /// The segment is shared (typically the separator and any
  /// literal surrounds).
  Shared

  /// The segment is part of the range's end value.
  End
}

/// The configuration for a [`NumberFormat`](#NumberFormat). Construct
/// with [`new`](#new), chain `with_*` setters, then call
/// [`build`](#build).
///
pub opaque type Builder {
  Builder(
    locales: List(String),
    style: Option(Style),
    currency: Option(String),
    currency_display: Option(CurrencyDisplay),
    currency_sign: Option(CurrencySign),
    unit: Option(String),
    unit_display: Option(UnitDisplay),
    use_grouping: Option(UseGrouping),
    minimum_integer_digits: Option(Int),
    minimum_fraction_digits: Option(Int),
    maximum_fraction_digits: Option(Int),
    minimum_significant_digits: Option(Int),
    maximum_significant_digits: Option(Int),
    notation: Option(Notation),
    compact_display: Option(CompactDisplay),
    sign_display: Option(SignDisplay),
    rounding_mode: Option(RoundingMode),
    rounding_priority: Option(RoundingPriority),
    rounding_increment: Option(Int),
    trailing_zero_display: Option(TrailingZeroDisplay),
    numbering_system: Option(String),
  )
}

/// Creates a `Builder` for the given locale priority list. The
/// runtime picks the first locale it supports; pass an empty list
/// to use the runtime's default locale.
///
pub fn new(locales: List(String)) -> Builder {
  Builder(
    locales:,
    style: None,
    currency: None,
    currency_display: None,
    currency_sign: None,
    unit: None,
    unit_display: None,
    use_grouping: None,
    minimum_integer_digits: None,
    minimum_fraction_digits: None,
    maximum_fraction_digits: None,
    minimum_significant_digits: None,
    maximum_significant_digits: None,
    notation: None,
    compact_display: None,
    sign_display: None,
    rounding_mode: None,
    rounding_priority: None,
    rounding_increment: None,
    trailing_zero_display: None,
    numbering_system: None,
  )
}

/// Sets the high-level formatting style. Pairs with
/// [`with_currency`](#with_currency) and [`with_unit`](#with_unit)
/// for the corresponding [`StyleCurrency`](#StyleCurrency) and
/// [`StyleUnit`](#StyleUnit) cases.
///
pub fn with_style(builder: Builder, value: Style) -> Builder {
  Builder(..builder, style: Some(value))
}

/// Sets the ISO 4217 currency code (e.g., `"USD"`, `"EUR"`). Used
/// when the style is [`StyleCurrency`](#StyleCurrency).
///
pub fn with_currency(builder: Builder, value: String) -> Builder {
  Builder(..builder, currency: Some(value))
}

/// Sets how the currency is presented.
///
pub fn with_currency_display(
  builder: Builder,
  value: CurrencyDisplay,
) -> Builder {
  Builder(..builder, currency_display: Some(value))
}

/// Sets how negative currency amounts are presented.
///
pub fn with_currency_sign(builder: Builder, value: CurrencySign) -> Builder {
  Builder(..builder, currency_sign: Some(value))
}

/// Sets the measurement unit identifier (e.g., `"meter"`,
/// `"kilometer-per-hour"`). Used when the style is
/// [`StyleUnit`](#StyleUnit).
///
pub fn with_unit(builder: Builder, value: String) -> Builder {
  Builder(..builder, unit: Some(value))
}

/// Sets how the unit is presented.
///
pub fn with_unit_display(builder: Builder, value: UnitDisplay) -> Builder {
  Builder(..builder, unit_display: Some(value))
}

/// Sets whether and when grouping separators are inserted.
///
pub fn with_use_grouping(builder: Builder, value: UseGrouping) -> Builder {
  Builder(..builder, use_grouping: Some(value))
}

/// Sets the minimum number of integer digits. Values below the
/// minimum are zero-padded.
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

/// Sets the numeric notation.
///
pub fn with_notation(builder: Builder, value: Notation) -> Builder {
  Builder(..builder, notation: Some(value))
}

/// Sets the compact-notation label form. Only applies when the
/// notation is [`NotationCompact`](#NotationCompact).
///
pub fn with_compact_display(builder: Builder, value: CompactDisplay) -> Builder {
  Builder(..builder, compact_display: Some(value))
}

/// Sets when explicit signs are rendered.
///
pub fn with_sign_display(builder: Builder, value: SignDisplay) -> Builder {
  Builder(..builder, sign_display: Some(value))
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

/// Sets the rounding increment — the formatter rounds to the nearest
/// multiple of this value. Valid values are `1`, `2`, `5`, `10`,
/// `20`, `25`, `50`, `100`, `200`, `250`, `500`, `1000`, `2000`,
/// `2500`, and `5000`; other values cause [`build`](#build) to
/// return `Error(Nil)`.
///
pub fn with_rounding_increment(builder: Builder, value: Int) -> Builder {
  Builder(..builder, rounding_increment: Some(value))
}

/// Sets whether trailing fraction zeros are stripped from integer
/// values.
///
pub fn with_trailing_zero_display(
  builder: Builder,
  value: TrailingZeroDisplay,
) -> Builder {
  Builder(..builder, trailing_zero_display: Some(value))
}

/// Sets the numbering system identifier (e.g., `"arab"`, `"hans"`,
/// `"latn"`). When unset, the locale's default numbering system is
/// used.
///
pub fn with_numbering_system(builder: Builder, value: String) -> Builder {
  Builder(..builder, numbering_system: Some(value))
}

/// Constructs a [`NumberFormat`](#NumberFormat) from the configured
/// builder. Returns `Error(Nil)` if any locale tag, currency code,
/// unit identifier, or numbering-system identifier is structurally
/// invalid, if a digit-count option is outside its allowed range, or
/// if [`with_rounding_increment`](#with_rounding_increment) is set to
/// an unsupported value.
///
pub fn build(builder: Builder) -> Result(NumberFormat, Nil) {
  do_build(
    builder.locales,
    builder.style,
    builder.currency,
    builder.currency_display,
    builder.currency_sign,
    builder.unit,
    builder.unit_display,
    builder.use_grouping,
    builder.minimum_integer_digits,
    builder.minimum_fraction_digits,
    builder.maximum_fraction_digits,
    builder.minimum_significant_digits,
    builder.maximum_significant_digits,
    builder.notation,
    builder.compact_display,
    builder.sign_display,
    builder.rounding_mode,
    builder.rounding_priority,
    builder.rounding_increment,
    builder.trailing_zero_display,
    builder.numbering_system,
  )
}

@external(javascript, "./number_format.ffi.mjs", "build")
@internal
pub fn do_build(
  locales: List(String),
  style: Option(Style),
  currency: Option(String),
  currency_display: Option(CurrencyDisplay),
  currency_sign: Option(CurrencySign),
  unit: Option(String),
  unit_display: Option(UnitDisplay),
  use_grouping: Option(UseGrouping),
  minimum_integer_digits: Option(Int),
  minimum_fraction_digits: Option(Int),
  maximum_fraction_digits: Option(Int),
  minimum_significant_digits: Option(Int),
  maximum_significant_digits: Option(Int),
  notation: Option(Notation),
  compact_display: Option(CompactDisplay),
  sign_display: Option(SignDisplay),
  rounding_mode: Option(RoundingMode),
  rounding_priority: Option(RoundingPriority),
  rounding_increment: Option(Int),
  trailing_zero_display: Option(TrailingZeroDisplay),
  numbering_system: Option(String),
) -> Result(NumberFormat, Nil)

/// Formats a `Float` value using the configured locale and options.
///
@external(javascript, "./number_format.ffi.mjs", "format")
pub fn format_float(formatter: NumberFormat, value: Float) -> String

/// Formats an `Int` value.
///
@external(javascript, "./number_format.ffi.mjs", "format")
pub fn format_int(formatter: NumberFormat, value: Int) -> String

/// Formats a [`BigInt`](https://hexdocs.pm/gossamer/gossamer/big_int.html#BigInt)
/// value at full precision.
///
@external(javascript, "./number_format.ffi.mjs", "format")
pub fn format_big_int(formatter: NumberFormat, value: BigInt) -> String

/// Formats a `Float` value and returns its decomposition into
/// segments, useful for separating currency symbols from amounts or
/// restyling individual digit groups.
///
@external(javascript, "./number_format.ffi.mjs", "format_to_parts")
pub fn format_float_to_parts(
  formatter: NumberFormat,
  value: Float,
) -> List(Part)

/// Formats an `Int` value as a list of [`Part`](#Part)s.
///
@external(javascript, "./number_format.ffi.mjs", "format_to_parts")
pub fn format_int_to_parts(formatter: NumberFormat, value: Int) -> List(Part)

/// Formats a [`BigInt`](https://hexdocs.pm/gossamer/gossamer/big_int.html#BigInt)
/// value as a list of [`Part`](#Part)s.
///
@external(javascript, "./number_format.ffi.mjs", "format_to_parts")
pub fn format_big_int_to_parts(
  formatter: NumberFormat,
  value: BigInt,
) -> List(Part)

/// Formats a `Float` range from `start` to `end` (e.g., `"$3 – $10"`).
/// Returns `Error(Nil)` if either endpoint is `NaN`. Runtimes vary on
/// whether `end < start` throws — some swap the values and produce a
/// reversed-range result.
///
@external(javascript, "./number_format.ffi.mjs", "format_range")
pub fn format_float_range(
  formatter: NumberFormat,
  from start: Float,
  to end: Float,
) -> Result(String, Nil)

/// Formats an `Int` range.
///
@external(javascript, "./number_format.ffi.mjs", "format_range")
pub fn format_int_range(
  formatter: NumberFormat,
  from start: Int,
  to end: Int,
) -> Result(String, Nil)

/// Formats a [`BigInt`](https://hexdocs.pm/gossamer/gossamer/big_int.html#BigInt)
/// range.
///
@external(javascript, "./number_format.ffi.mjs", "format_range")
pub fn format_big_int_range(
  formatter: NumberFormat,
  from start: BigInt,
  to end: BigInt,
) -> Result(String, Nil)

/// Formats a `Float` range and returns its decomposition into
/// [`RangePart`](#RangePart)s, each tagged by which endpoint it
/// came from. Returns `Error(Nil)` if either endpoint is `NaN`.
///
@external(javascript, "./number_format.ffi.mjs", "format_range_to_parts")
pub fn format_float_range_to_parts(
  formatter: NumberFormat,
  from start: Float,
  to end: Float,
) -> Result(List(RangePart), Nil)

/// Formats an `Int` range as a list of [`RangePart`](#RangePart)s.
///
@external(javascript, "./number_format.ffi.mjs", "format_range_to_parts")
pub fn format_int_range_to_parts(
  formatter: NumberFormat,
  from start: Int,
  to end: Int,
) -> Result(List(RangePart), Nil)

/// Formats a [`BigInt`](https://hexdocs.pm/gossamer/gossamer/big_int.html#BigInt)
/// range as a list of [`RangePart`](#RangePart)s.
///
@external(javascript, "./number_format.ffi.mjs", "format_range_to_parts")
pub fn format_big_int_range_to_parts(
  formatter: NumberFormat,
  from start: BigInt,
  to end: BigInt,
) -> Result(List(RangePart), Nil)

/// The BCP 47 locale tag the runtime resolved from the requested
/// priority list (e.g., `"en-US"`).
///
@external(javascript, "./number_format.ffi.mjs", "resolved_locale")
pub fn resolved_locale(formatter: NumberFormat) -> String

/// Filters `locales` to those the runtime supports for number
/// formatting, preserving the input order.
///
@external(javascript, "./number_format.ffi.mjs", "supported_locales_of")
pub fn supported_locales_of(locales: List(String)) -> List(String)
