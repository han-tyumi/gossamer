//// Locale-aware localized names for languages, regions, scripts,
//// currencies, calendars, and date/time fields via the JavaScript
//// `Intl.DisplayNames`. Configure with [`new`](#new) and chain
//// `with_*` setters before calling [`build`](#build).

import gleam/option.{type Option, None, Some}

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

/// The verbosity of the produced display name. Maps the JavaScript
/// `style` option.
///
pub type Style {
  /// Full names (the default).
  Long

  /// Shortened forms.
  Short

  /// The shortest forms.
  Narrow
}

/// What the formatter returns when no display name exists for the
/// input code. Maps the JavaScript `fallback` option.
///
pub type Fallback {
  /// Return the input code unchanged (the default).
  FallbackCode

  /// Return `Error(Nil)`.
  FallbackNone
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

/// The configuration for a [`DisplayNames`](#DisplayNames). Construct
/// with [`new`](#new), chain `with_*` setters, then call
/// [`build`](#build).
///
pub opaque type Builder {
  Builder(
    locales: List(String),
    kind: Kind,
    style: Option(Style),
    fallback: Option(Fallback),
    language_display: Option(LanguageDisplay),
  )
}

/// Creates a `Builder` for the given locale priority list, configured
/// to resolve codes of the given [`Kind`](#Kind). The runtime picks
/// the first locale it supports; pass an empty list to use the
/// runtime's default locale.
///
pub fn new(locales: List(String), of kind: Kind) -> Builder {
  Builder(locales:, kind:, style: None, fallback: None, language_display: None)
}

/// Sets the verbosity of the produced display name.
///
pub fn with_style(builder: Builder, value: Style) -> Builder {
  Builder(..builder, style: Some(value))
}

/// Sets what the formatter returns when no display name exists for
/// the input code.
///
pub fn with_fallback(builder: Builder, value: Fallback) -> Builder {
  Builder(..builder, fallback: Some(value))
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
    builder.kind,
    builder.style,
    builder.fallback,
    builder.language_display,
  )
}

@external(javascript, "./display_names.ffi.mjs", "build")
@internal
pub fn do_build(
  locales: List(String),
  kind: Kind,
  style: Option(Style),
  fallback: Option(Fallback),
  language_display: Option(LanguageDisplay),
) -> Result(DisplayNames, Nil)

/// Returns the localized name for the given code. Returns
/// `Error(Nil)` only when [`with_fallback`](#with_fallback) was set
/// to [`FallbackNone`](#FallbackNone) and no name exists. With the
/// default fallback of [`FallbackCode`](#FallbackCode), an unknown
/// code returns `Ok(code)`.
///
@external(javascript, "./display_names.ffi.mjs", "of")
pub fn of(formatter: DisplayNames, code: String) -> Result(String, Nil)

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
