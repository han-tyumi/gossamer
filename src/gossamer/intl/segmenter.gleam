//// Locale-aware text segmentation via the JavaScript `Intl.Segmenter`.
//// Reusing a built [`Segmenter`](#Segmenter) across many calls is
//// significantly faster than building one per call.

import gleam/option.{type Option, None, Some}
import gleam/yielder.{type Yielder}
import gossamer/intl.{type LocaleMatcher}

/// A configured segmenter that splits a string into graphemes, words,
/// or sentences using locale-specific rules.
///
/// See [Intl.Segmenter](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Intl/Segmenter) on MDN.
///
@external(javascript, "./segmenter.type.ts", "Segmenter$")
pub type Segmenter

/// The unit of segmentation. Maps the JavaScript `granularity`
/// option.
///
pub type Granularity {
  /// Split into user-perceived characters — accounts for combining
  /// marks, emoji sequences, and the like (the default).
  Grapheme

  /// Split into words.
  Word

  /// Split into sentences.
  Sentence
}

/// A single segment from a segmented string. `value` is the
/// substring, `index` is the UTF-16 code-unit position within the
/// input, and `is_word_like` is `Some` only when the segmenter was
/// configured with [`Word`](#Word) granularity.
///
pub type Segment {
  Segment(value: String, index: Int, is_word_like: Option(Bool))
}

/// The configuration for a [`Segmenter`](#Segmenter).
///
pub opaque type Builder {
  Builder(
    locales: List(String),
    locale_matcher: Option(LocaleMatcher),
    granularity: Option(Granularity),
  )
}

/// Creates a `Builder` for the given locale priority list. The
/// runtime picks the first locale it supports; pass an empty list to
/// use the runtime's default locale.
///
pub fn new(locales: List(String)) -> Builder {
  Builder(locales:, locale_matcher: None, granularity: None)
}

/// Sets the locale-matching algorithm used to pick a locale from the
/// priority list.
///
pub fn with_locale_matcher(builder: Builder, value: LocaleMatcher) -> Builder {
  Builder(..builder, locale_matcher: Some(value))
}

/// Sets the unit of segmentation.
///
pub fn with_granularity(builder: Builder, value: Granularity) -> Builder {
  Builder(..builder, granularity: Some(value))
}

/// Constructs a [`Segmenter`](#Segmenter) from the configured
/// builder. Returns `Error(Nil)` if any locale tag is structurally
/// invalid.
///
pub fn build(builder: Builder) -> Result(Segmenter, Nil) {
  do_build(builder.locales, builder.locale_matcher, builder.granularity)
}

@external(javascript, "./segmenter.ffi.mjs", "build")
@internal
pub fn do_build(
  locales: List(String),
  locale_matcher: Option(LocaleMatcher),
  granularity: Option(Granularity),
) -> Result(Segmenter, Nil)

/// Splits `input` into segments according to the segmenter's
/// configured [`Granularity`](#Granularity). The returned yielder
/// produces each [`Segment`](#Segment) lazily, in order.
///
@external(javascript, "./segmenter.ffi.mjs", "segment")
pub fn segment(segmenter: Segmenter, input: String) -> Yielder(Segment)

/// The BCP 47 locale tag the runtime resolved from the requested
/// priority list (e.g., `"en-US"`).
///
@external(javascript, "./segmenter.ffi.mjs", "resolved_locale")
pub fn resolved_locale(segmenter: Segmenter) -> String

/// Filters `locales` to those the runtime supports for segmentation,
/// preserving the input order.
///
@external(javascript, "./segmenter.ffi.mjs", "supported_locales_of")
pub fn supported_locales_of(locales: List(String)) -> List(String)
