//// BCP 47 locale-identifier parsing and manipulation via the
//// JavaScript `Intl.Locale`. Parse a tag with optional extension
//// subtags, query its components via [`info`](#info), list the
//// calendars or collations the locale supports, and convert between
//// maximal and minimal canonical forms.

import gleam/option.{type Option, None, Some}
import gossamer/intl.{type CaseFirst, type HourCycle}

/// A parsed BCP 47 locale identifier with optional extension subtags.
///
/// See [Intl.Locale](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Intl/Locale) on MDN.
///
@external(javascript, "./locale.type.ts", "Locale$")
pub type Locale

/// The dominant writing direction of a locale's primary script.
/// Returned by [`text_direction`](#text_direction).
///
pub type TextDirection {
  /// Left-to-right (Latin, Cyrillic, etc.).
  Ltr

  /// Right-to-left (Arabic, Hebrew, etc.).
  Rtl
}

/// Locale-specific calendar-week information, returned by
/// [`week_info`](#week_info). `first_day` and entries of `weekend`
/// use ISO 8601 day-of-week numbering — Monday is `1`, Sunday is
/// `7`.
///
pub type WeekInfo {
  WeekInfo(first_day: Int, weekend: List(Int))
}

/// A snapshot of a locale's parsed components, returned by
/// [`info`](#info). Components with no value for the locale are
/// `None`.
///
pub type Info {
  Info(
    /// The BCP 47 base name — the language, script (if any), and
    /// region (if any) joined with hyphens, without extension
    /// subtags. For `"en-US-u-ca-gregory"`, this is `"en-US"`.
    base_name: String,
    /// The language subtag (e.g., `"en"`).
    language: String,
    /// The script subtag (e.g., `"Latn"`, `"Hans"`).
    script: Option(String),
    /// The region subtag (e.g., `"US"`, `"CN"`).
    region: Option(String),
    /// The preferred calendar identifier (e.g., `"gregory"`,
    /// `"chinese"`).
    calendar: Option(String),
    /// The preferred case-first ordering.
    case_first: Option(CaseFirst),
    /// The preferred collation identifier (e.g., `"phonebk"`,
    /// `"pinyin"`).
    collation: Option(String),
    /// The preferred hour cycle.
    hour_cycle: Option(HourCycle),
    /// The preferred numbering-system identifier (e.g., `"latn"`,
    /// `"arab"`).
    numbering_system: Option(String),
    /// Whether numeric collation is preferred — digit runs compared
    /// as numbers rather than character by character.
    is_numeric: Bool,
  )
}

/// The configuration for a [`Locale`](#Locale). Constructed from a
/// BCP 47 tag with optional per-component overrides.
///
pub opaque type Builder {
  Builder(
    tag: String,
    calendar: Option(String),
    case_first: Option(CaseFirst),
    collation: Option(String),
    hour_cycle: Option(HourCycle),
    language: Option(String),
    numbering_system: Option(String),
    numeric: Option(Bool),
    region: Option(String),
    script: Option(String),
  )
}

/// Creates a `Builder` for the given BCP 47 locale tag (e.g.,
/// `"en-US"`, `"zh-Hans-CN"`).
///
pub fn new(tag: String) -> Builder {
  Builder(
    tag:,
    calendar: None,
    case_first: None,
    collation: None,
    hour_cycle: None,
    language: None,
    numbering_system: None,
    numeric: None,
    region: None,
    script: None,
  )
}

/// Overrides the calendar identifier (e.g., `"gregory"`,
/// `"chinese"`).
///
pub fn with_calendar(builder: Builder, value: String) -> Builder {
  Builder(..builder, calendar: Some(value))
}

/// Overrides the case-first preference.
///
pub fn with_case_first(builder: Builder, value: CaseFirst) -> Builder {
  Builder(..builder, case_first: Some(value))
}

/// Overrides the collation identifier (e.g., `"phonebk"`,
/// `"pinyin"`).
///
pub fn with_collation(builder: Builder, value: String) -> Builder {
  Builder(..builder, collation: Some(value))
}

/// Overrides the preferred hour cycle.
///
pub fn with_hour_cycle(builder: Builder, value: HourCycle) -> Builder {
  Builder(..builder, hour_cycle: Some(value))
}

/// Overrides the language subtag (e.g., `"en"`, `"fr"`).
///
pub fn with_language(builder: Builder, value: String) -> Builder {
  Builder(..builder, language: Some(value))
}

/// Overrides the numbering-system identifier (e.g., `"latn"`,
/// `"arab"`).
///
pub fn with_numbering_system(builder: Builder, value: String) -> Builder {
  Builder(..builder, numbering_system: Some(value))
}

/// Overrides whether numeric collation is preferred (digit runs
/// compared as numbers rather than character by character).
///
pub fn with_numeric(builder: Builder, value: Bool) -> Builder {
  Builder(..builder, numeric: Some(value))
}

/// Overrides the region subtag (e.g., `"US"`, `"CN"`).
///
pub fn with_region(builder: Builder, value: String) -> Builder {
  Builder(..builder, region: Some(value))
}

/// Overrides the script subtag (e.g., `"Latn"`, `"Hans"`).
///
pub fn with_script(builder: Builder, value: String) -> Builder {
  Builder(..builder, script: Some(value))
}

/// Constructs a [`Locale`](#Locale) from the configured builder.
/// Returns `Error(Nil)` if the tag or any override is structurally
/// invalid.
///
pub fn build(builder: Builder) -> Result(Locale, Nil) {
  do_build(
    builder.tag,
    builder.calendar,
    builder.case_first,
    builder.collation,
    builder.hour_cycle,
    builder.language,
    builder.numbering_system,
    builder.numeric,
    builder.region,
    builder.script,
  )
}

@external(javascript, "./locale.ffi.mjs", "build")
@internal
pub fn do_build(
  tag: String,
  calendar: Option(String),
  case_first: Option(CaseFirst),
  collation: Option(String),
  hour_cycle: Option(HourCycle),
  language: Option(String),
  numbering_system: Option(String),
  numeric: Option(Bool),
  region: Option(String),
  script: Option(String),
) -> Result(Locale, Nil)

/// A snapshot of the locale's parsed components — base name,
/// language, script, region, and Unicode extension subtags
/// (calendar, case-first, collation, hour cycle, numbering system,
/// and numeric flag).
///
@external(javascript, "./locale.ffi.mjs", "info")
pub fn info(locale: Locale) -> Info

/// The calendars supported by the locale, in preference order.
///
@external(javascript, "./locale.ffi.mjs", "calendars")
pub fn calendars(locale: Locale) -> List(String)

/// The collations supported by the locale, in preference order.
///
@external(javascript, "./locale.ffi.mjs", "collations")
pub fn collations(locale: Locale) -> List(String)

/// The hour cycles supported by the locale, in preference order.
///
@external(javascript, "./locale.ffi.mjs", "hour_cycles")
pub fn hour_cycles(locale: Locale) -> List(HourCycle)

/// The numbering systems supported by the locale, in preference
/// order.
///
@external(javascript, "./locale.ffi.mjs", "numbering_systems")
pub fn numbering_systems(locale: Locale) -> List(String)

/// The IANA time zones associated with the locale's region. Returns
/// `Error(Nil)` when the locale has no region subtag.
///
@external(javascript, "./locale.ffi.mjs", "time_zones")
pub fn time_zones(locale: Locale) -> Result(List(String), Nil)

/// The dominant writing direction of the locale's primary script.
///
@external(javascript, "./locale.ffi.mjs", "text_direction")
pub fn text_direction(locale: Locale) -> TextDirection

/// Locale-specific calendar-week information.
///
@external(javascript, "./locale.ffi.mjs", "week_info")
pub fn week_info(locale: Locale) -> WeekInfo

/// Returns a locale with all subtags filled in to canonical maximal
/// form per the Unicode Likely Subtags algorithm (e.g., `"en"`
/// becomes `"en-Latn-US"`).
///
@external(javascript, "./locale.ffi.mjs", "maximize")
pub fn maximize(locale: Locale) -> Locale

/// Returns a locale with redundant subtags removed per the Unicode
/// Likely Subtags algorithm (e.g., `"en-Latn-US"` becomes `"en"`).
///
@external(javascript, "./locale.ffi.mjs", "minimize")
pub fn minimize(locale: Locale) -> Locale

/// The canonical BCP 47 string representation of the locale,
/// including any extension subtags.
///
@external(javascript, "./locale.ffi.mjs", "to_string")
pub fn to_string(locale: Locale) -> String
