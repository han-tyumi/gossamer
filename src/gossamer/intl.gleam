//// Parent module for the Internationalization family — JavaScript's
//// `Intl.*` constructors. Hosts the rounding option enums shared
//// across siblings that accept rounding configuration
//// ([`gossamer/intl/number_format`](./intl/number_format.html) and
//// [`gossamer/intl/plural_rules`](./intl/plural_rules.html)).

/// The rounding strategy applied to a formatter's output. Maps the
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
