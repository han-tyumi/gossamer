//// Locale-aware relative-time formatting via the JavaScript
//// `Intl.RelativeTimeFormat`. Reusing a built
//// [`RelativeTimeFormat`](#RelativeTimeFormat) across many calls is
//// significantly faster than building one per call.

import gleam/option.{type Option, None, Some}

/// A configured formatter that renders relative time spans
/// (`"in 2 hours"`, `"yesterday"`, etc.) in a locale-specific way.
///
/// See [Intl.RelativeTimeFormat](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Intl/RelativeTimeFormat) on MDN.
///
@external(javascript, "./relative_time_format.type.ts", "RelativeTimeFormat$")
pub type RelativeTimeFormat

/// Whether the formatter renders numeric values verbatim or
/// substitutes locale-specific wording. Maps the JavaScript
/// `numeric` option.
///
pub type Numeric {
  /// Always render the numeric value (`"in 1 day"`, the default).
  Always

  /// Substitute locale-specific wording for special values
  /// (`"tomorrow"` instead of `"in 1 day"`).
  Auto
}

/// The verbosity of the unit labels. Maps the JavaScript `style`
/// option.
///
pub type Style {
  /// Full words (`"in 1 month"`, the default).
  Long

  /// Shortened forms (`"in 1 mo."`).
  Short

  /// The shortest forms (`"in 1mo"`).
  Narrow
}

/// A time unit accepted by the format operations. Maps the JavaScript
/// `unit` argument string.
///
pub type Unit {
  Year
  Quarter
  Month
  Week
  Day
  Hour
  Minute
  Second
}

/// A single segment of a formatted relative-time string, returned by
/// the `format_*_to_parts` family. The `unit` field is `Some` for
/// segments that quantify a time unit (the integer portion of
/// `"in 1 day"`) and `None` for literal connective text.
///
pub type Part {
  Part(kind: PartKind, value: String, unit: Option(Unit))
}

/// The kind of a [`Part`](#Part). Mirrors the relevant subset of
/// JavaScript `Intl.RelativeTimeFormatPart.type`.
///
pub type PartKind {
  /// A literal connective text (`"in "`, `" ago"`).
  Literal

  /// An integer digit run.
  Integer

  /// The decimal separator (`"."` or `","` per locale).
  Decimal

  /// The fractional portion of a number.
  Fraction

  /// A digit-group separator (`","` or `" "` per locale).
  Group

  /// A minus sign for negative durations.
  MinusSign

  /// A plus sign.
  PlusSign

  /// The literal infinity symbol (`"∞"`).
  Infinity

  /// The literal NaN representation.
  Nan

  /// Any future part kind the binding doesn't recognize, passed
  /// through verbatim.
  Unknown(String)
}

/// The configuration for a
/// [`RelativeTimeFormat`](#RelativeTimeFormat).
///
pub opaque type Builder {
  Builder(locales: List(String), numeric: Option(Numeric), style: Option(Style))
}

/// Creates a `Builder` for the given locale priority list. The
/// runtime picks the first locale it supports; pass an empty list to
/// use the runtime's default locale.
///
pub fn new(locales: List(String)) -> Builder {
  Builder(locales:, numeric: None, style: None)
}

/// Sets whether the formatter renders numeric values verbatim or
/// substitutes locale-specific wording for special values.
///
pub fn with_numeric(builder: Builder, value: Numeric) -> Builder {
  Builder(..builder, numeric: Some(value))
}

/// Sets the verbosity of the unit labels.
///
pub fn with_style(builder: Builder, value: Style) -> Builder {
  Builder(..builder, style: Some(value))
}

/// Constructs a [`RelativeTimeFormat`](#RelativeTimeFormat) from the
/// configured builder. Returns `Error(Nil)` if any locale tag is
/// structurally invalid.
///
pub fn build(builder: Builder) -> Result(RelativeTimeFormat, Nil) {
  do_build(builder.locales, builder.numeric, builder.style)
}

@external(javascript, "./relative_time_format.ffi.mjs", "build")
@internal
pub fn do_build(
  locales: List(String),
  numeric: Option(Numeric),
  style: Option(Style),
) -> Result(RelativeTimeFormat, Nil)

/// Formats a `Float` value as a relative time in the given unit
/// (`format_float(rtf, -1.0, in: Day)` → `"1 day ago"`).
///
@external(javascript, "./relative_time_format.ffi.mjs", "format")
pub fn format_float(
  formatter: RelativeTimeFormat,
  value: Float,
  in unit: Unit,
) -> String

/// Formats an `Int` value as a relative time in the given unit.
///
@external(javascript, "./relative_time_format.ffi.mjs", "format")
pub fn format_int(
  formatter: RelativeTimeFormat,
  value: Int,
  in unit: Unit,
) -> String

/// Formats a `Float` value and returns its decomposition into
/// segments.
///
@external(javascript, "./relative_time_format.ffi.mjs", "format_to_parts")
pub fn format_float_to_parts(
  formatter: RelativeTimeFormat,
  value: Float,
  in unit: Unit,
) -> List(Part)

/// Formats an `Int` value as a list of [`Part`](#Part)s.
///
@external(javascript, "./relative_time_format.ffi.mjs", "format_to_parts")
pub fn format_int_to_parts(
  formatter: RelativeTimeFormat,
  value: Int,
  in unit: Unit,
) -> List(Part)

/// The BCP 47 locale tag the runtime resolved from the requested
/// priority list (e.g., `"en-US"`).
///
@external(javascript, "./relative_time_format.ffi.mjs", "resolved_locale")
pub fn resolved_locale(formatter: RelativeTimeFormat) -> String

/// Filters `locales` to those the runtime supports for relative-time
/// formatting, preserving the input order.
///
@external(javascript, "./relative_time_format.ffi.mjs", "supported_locales_of")
pub fn supported_locales_of(locales: List(String)) -> List(String)
