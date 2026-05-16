//// Locale-aware localized names for languages, regions, scripts,
//// currencies, calendars, and date/time fields via the JavaScript
//// `Intl.DisplayNames`. Reusing a built
//// [`DisplayNames`](#DisplayNames) across many calls is
//// significantly faster than building one per call.

import gleam/option.{type Option, None, Some}
import gossamer/intl.{type LabelStyle, type LocaleMatcher}

/// A configured formatter that maps standard codes (BCP 47 language
/// tags, ISO 4217 currency codes, ISO 15924 script codes, etc.) to
/// their locale-specific display names.
///
/// See [Intl.DisplayNames](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Intl/DisplayNames) on MDN.
///
@external(javascript, "./display_names.type.ts", "DisplayNames$")
pub type DisplayNames

/// The category of code the formatter resolves to a display name.
/// Maps the JavaScript `type` option.
///
pub type Kind {
  /// BCP 47 language tags (`"fr"` → `"French"`).
  Language

  /// ISO 3166 region codes (`"US"` → `"United States"`).
  Region

  /// ISO 15924 script codes (`"Latn"` → `"Latin"`).
  Script

  /// ISO 4217 currency codes (`"USD"` → `"US Dollar"`).
  Currency

  /// Calendar identifiers (`"gregory"` → `"Gregorian Calendar"`).
  Calendar

  /// Date and time field identifiers (`"year"` → `"year"`).
  DateTimeField
}

/// How language display names are rendered when the input combines a
/// language and a region. Maps the JavaScript `languageDisplay`
/// option. Only meaningful when [`new`](#new) is called with
/// [`Language`](#Language).
///
pub type LanguageDisplay {
  /// Dialect-style names (`"American English"` for `"en-US"`, the
  /// default).
  Dialect

  /// Standard-style names (`"English (United States)"` for `"en-US"`).
  Standard
}

/// The configuration for a [`DisplayNames`](#DisplayNames).
///
pub opaque type Builder {
  Builder(
    locales: List(String),
    locale_matcher: Option(LocaleMatcher),
    kind: Kind,
    style: Option(LabelStyle),
    language_display: Option(LanguageDisplay),
  )
}

/// Creates a `Builder` for the given locale priority list, configured
/// to resolve codes of the given [`Kind`](#Kind). The runtime picks
/// the first locale it supports; pass an empty list to use the
/// runtime's default locale.
///
pub fn new(locales: List(String), of kind: Kind) -> Builder {
  Builder(
    locales:,
    locale_matcher: None,
    kind:,
    style: None,
    language_display: None,
  )
}

/// Sets the locale-matching algorithm used to pick a locale from the
/// priority list.
///
pub fn with_locale_matcher(builder: Builder, value: LocaleMatcher) -> Builder {
  Builder(..builder, locale_matcher: Some(value))
}

/// Sets the verbosity of the produced display name.
///
pub fn with_style(builder: Builder, value: LabelStyle) -> Builder {
  Builder(..builder, style: Some(value))
}

/// Sets how language display names are rendered when the input
/// combines a language and a region.
///
pub fn with_language_display(
  builder: Builder,
  value: LanguageDisplay,
) -> Builder {
  Builder(..builder, language_display: Some(value))
}

/// Constructs a [`DisplayNames`](#DisplayNames) from the configured
/// builder. Returns `Error(Nil)` if any locale tag is structurally
/// invalid.
///
pub fn build(builder: Builder) -> Result(DisplayNames, Nil) {
  do_build(
    builder.locales,
    builder.locale_matcher,
    builder.kind,
    builder.style,
    builder.language_display,
  )
}

@external(javascript, "./display_names.ffi.mjs", "build")
@internal
pub fn do_build(
  locales: List(String),
  locale_matcher: Option(LocaleMatcher),
  kind: Kind,
  style: Option(LabelStyle),
  language_display: Option(LanguageDisplay),
) -> Result(DisplayNames, Nil)

/// Returns the localized name for the given code, or the code itself
/// if no name is registered for it in the formatter's locale.
/// Equivalent to JavaScript's default `fallback: "code"` mode. For a
/// strict lookup that distinguishes the two cases, use
/// [`find`](#find).
///
@external(javascript, "./display_names.ffi.mjs", "of")
pub fn of(formatter: DisplayNames, code: String) -> String

/// Looks up the localized name for the given code. Returns
/// `Error(Nil)` if no name is registered for the code in the
/// formatter's locale. Equivalent to JavaScript's
/// `fallback: "none"` mode.
///
@external(javascript, "./display_names.ffi.mjs", "find")
pub fn find(formatter: DisplayNames, code: String) -> Result(String, Nil)

/// The BCP 47 locale tag the runtime resolved from the requested
/// priority list (e.g., `"en-US"`).
///
@external(javascript, "./display_names.ffi.mjs", "resolved_locale")
pub fn resolved_locale(formatter: DisplayNames) -> String

/// Filters `locales` to those the runtime supports for display
/// names, preserving the input order.
///
@external(javascript, "./display_names.ffi.mjs", "supported_locales_of")
pub fn supported_locales_of(locales: List(String)) -> List(String)
