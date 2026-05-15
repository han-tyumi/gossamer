//// Locale-aware list formatting via the JavaScript `Intl.ListFormat`.
//// Reusing a built [`ListFormat`](#ListFormat) across many calls is
//// significantly faster than building one per call.

import gleam/option.{type Option, None, Some}
import gossamer/intl.{type LabelStyle}

/// A configured list formatter that joins a list of strings using a
/// locale-specific conjunction or separator.
///
/// See [Intl.ListFormat](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Intl/ListFormat) on MDN.
///
@external(javascript, "./list_format.type.ts", "ListFormat$")
pub type ListFormat

/// The kind of join the formatter produces. Maps the JavaScript
/// `type` option.
///
pub type Kind {
  /// "And"-style joining: `"apple, banana, and cherry"` (the
  /// default).
  Conjunction

  /// "Or"-style joining: `"apple, banana, or cherry"`.
  Disjunction

  /// Unit-style joining for compound measurements:
  /// `"5 hours, 10 minutes"`.
  Unit
}

/// A single segment of a formatted list, returned by
/// [`format_to_parts`](#format_to_parts).
///
pub type Part {
  Part(kind: PartKind, value: String)
}

/// The kind of a [`Part`](#Part) — either a literal join word /
/// separator or one of the input elements.
///
pub type PartKind {
  /// A literal join word or separator (`", "`, `"and "`, etc.).
  Literal

  /// One of the input list elements, passed through unchanged.
  Element
}

/// The configuration for a [`ListFormat`](#ListFormat).
///
pub opaque type Builder {
  Builder(locales: List(String), kind: Option(Kind), style: Option(LabelStyle))
}

/// Creates a `Builder` for the given locale priority list. The
/// runtime picks the first locale it supports; pass an empty list
/// to use the runtime's default locale.
///
pub fn new(locales: List(String)) -> Builder {
  Builder(locales:, kind: None, style: None)
}

/// Sets the kind of join the formatter produces.
///
pub fn with_kind(builder: Builder, value: Kind) -> Builder {
  Builder(..builder, kind: Some(value))
}

/// Sets the verbosity of the joining words and separators.
///
pub fn with_style(builder: Builder, value: LabelStyle) -> Builder {
  Builder(..builder, style: Some(value))
}

/// Constructs a [`ListFormat`](#ListFormat) from the configured
/// builder. Returns `Error(Nil)` if any locale tag is structurally
/// invalid.
///
pub fn build(builder: Builder) -> Result(ListFormat, Nil) {
  do_build(builder.locales, builder.kind, builder.style)
}

@external(javascript, "./list_format.ffi.mjs", "build")
@internal
pub fn do_build(
  locales: List(String),
  kind: Option(Kind),
  style: Option(LabelStyle),
) -> Result(ListFormat, Nil)

/// Formats `list` as a locale-aware joined string. An empty list
/// produces `""`; a single-element list returns that element
/// unchanged.
///
@external(javascript, "./list_format.ffi.mjs", "format")
pub fn format(formatter: ListFormat, list: List(String)) -> String

/// Formats `list` and returns its decomposition into segments —
/// alternating [`Literal`](#Literal) join words / separators and
/// [`Element`](#Element) entries.
///
@external(javascript, "./list_format.ffi.mjs", "format_to_parts")
pub fn format_to_parts(formatter: ListFormat, list: List(String)) -> List(Part)

/// The BCP 47 locale tag the runtime resolved from the requested
/// priority list (e.g., `"en-US"`).
///
@external(javascript, "./list_format.ffi.mjs", "resolved_locale")
pub fn resolved_locale(formatter: ListFormat) -> String

/// Filters `locales` to those the runtime supports for list
/// formatting, preserving the input order.
///
@external(javascript, "./list_format.ffi.mjs", "supported_locales_of")
pub fn supported_locales_of(locales: List(String)) -> List(String)
