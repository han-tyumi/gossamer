import * as $intl from "$/gossamer/gossamer/intl.mjs";
import * as $numberFormat from "$/gossamer/gossamer/intl/number_format.mjs";
import { Result$Error, Result$Ok } from "$/prelude.mjs";
import { fromRangeSource, toLocaleMatcher } from "~/utils/intl.ffi.ts";
import { fromArray, fromArrayMapped, toArray } from "~/utils/list.ffi.ts";
import { mapIfSome, setIfSome } from "~/utils/option.ffi.ts";

function toStyle(
  style: $numberFormat.Style$,
): "decimal" | "currency" | "percent" | "unit" {
  if ($numberFormat.Style$isStyleDecimal(style)) return "decimal";
  if ($numberFormat.Style$isStyleCurrency(style)) return "currency";
  if ($numberFormat.Style$isStylePercent(style)) return "percent";
  return "unit";
}

function toCurrencyDisplay(
  display: $numberFormat.CurrencyDisplay$,
): "code" | "symbol" | "narrowSymbol" | "name" {
  if ($numberFormat.CurrencyDisplay$isCurrencyCode(display)) {
    return "code";
  }
  if ($numberFormat.CurrencyDisplay$isCurrencySymbol(display)) {
    return "symbol";
  }
  if ($numberFormat.CurrencyDisplay$isCurrencyNarrowSymbol(display)) {
    return "narrowSymbol";
  }
  return "name";
}

function toCurrencySign(
  sign: $numberFormat.CurrencySign$,
): "standard" | "accounting" {
  return $numberFormat.CurrencySign$isCurrencySignStandard(sign)
    ? "standard"
    : "accounting";
}

function toUnitDisplay(
  display: $numberFormat.UnitDisplay$,
): "long" | "short" | "narrow" {
  if ($numberFormat.UnitDisplay$isUnitLong(display)) return "long";
  if ($numberFormat.UnitDisplay$isUnitShort(display)) return "short";
  return "narrow";
}

function toUseGrouping(
  grouping: $numberFormat.UseGrouping$,
): "always" | "auto" | "min2" | false {
  if ($numberFormat.UseGrouping$isUseGroupingAlways(grouping)) return "always";
  if ($numberFormat.UseGrouping$isUseGroupingAuto(grouping)) return "auto";
  if ($numberFormat.UseGrouping$isUseGroupingMin2(grouping)) return "min2";
  return false;
}

function toNotation(
  notation: $numberFormat.Notation$,
): "standard" | "scientific" | "engineering" | "compact" {
  if ($numberFormat.Notation$isNotationStandard(notation)) return "standard";
  if ($numberFormat.Notation$isNotationScientific(notation)) {
    return "scientific";
  }
  if ($numberFormat.Notation$isNotationEngineering(notation)) {
    return "engineering";
  }
  return "compact";
}

function toCompactDisplay(
  display: $numberFormat.CompactDisplay$,
): "short" | "long" {
  return $numberFormat.CompactDisplay$isCompactShort(display)
    ? "short"
    : "long";
}

function toSignDisplay(
  sign: $numberFormat.SignDisplay$,
): "auto" | "always" | "exceptZero" | "negative" | "never" {
  if ($numberFormat.SignDisplay$isSignAuto(sign)) return "auto";
  if ($numberFormat.SignDisplay$isSignAlways(sign)) return "always";
  if ($numberFormat.SignDisplay$isSignExceptZero(sign)) {
    return "exceptZero";
  }
  if ($numberFormat.SignDisplay$isSignNegative(sign)) return "negative";
  return "never";
}

export function toRoundingMode(
  mode: $intl.RoundingMode$,
):
  | "ceil"
  | "floor"
  | "expand"
  | "trunc"
  | "halfCeil"
  | "halfFloor"
  | "halfExpand"
  | "halfTrunc"
  | "halfEven" {
  if ($intl.RoundingMode$isRoundingModeCeil(mode)) return "ceil";
  if ($intl.RoundingMode$isRoundingModeFloor(mode)) return "floor";
  if ($intl.RoundingMode$isRoundingModeExpand(mode)) return "expand";
  if ($intl.RoundingMode$isRoundingModeTrunc(mode)) return "trunc";
  if ($intl.RoundingMode$isRoundingModeHalfCeil(mode)) return "halfCeil";
  if ($intl.RoundingMode$isRoundingModeHalfFloor(mode)) return "halfFloor";
  if ($intl.RoundingMode$isRoundingModeHalfExpand(mode)) return "halfExpand";
  if ($intl.RoundingMode$isRoundingModeHalfTrunc(mode)) return "halfTrunc";
  return "halfEven";
}

export function toRoundingPriority(
  priority: $intl.RoundingPriority$,
): "auto" | "morePrecision" | "lessPrecision" {
  if ($intl.RoundingPriority$isRoundingPriorityAuto(priority)) return "auto";
  if ($intl.RoundingPriority$isRoundingPriorityMorePrecision(priority)) {
    return "morePrecision";
  }
  return "lessPrecision";
}

export function toTrailingZeroDisplay(
  display: $intl.TrailingZeroDisplay$,
): "auto" | "stripIfInteger" {
  return $intl.TrailingZeroDisplay$isTrailingZeroAuto(display)
    ? "auto"
    : "stripIfInteger";
}

function fromPartKind(type: string): $numberFormat.PartKind$ {
  switch (type) {
    case "literal":
      return $numberFormat.PartKind$PartLiteral();
    case "integer":
      return $numberFormat.PartKind$PartInteger();
    case "decimal":
      return $numberFormat.PartKind$PartDecimal();
    case "fraction":
      return $numberFormat.PartKind$PartFraction();
    case "group":
      return $numberFormat.PartKind$PartGroup();
    case "minusSign":
      return $numberFormat.PartKind$PartMinusSign();
    case "plusSign":
      return $numberFormat.PartKind$PartPlusSign();
    case "currency":
      return $numberFormat.PartKind$PartCurrency();
    case "percentSign":
      return $numberFormat.PartKind$PartPercentSign();
    case "compact":
      return $numberFormat.PartKind$PartCompact();
    case "exponentInteger":
      return $numberFormat.PartKind$PartExponentInteger();
    case "exponentMinusSign":
      return $numberFormat.PartKind$PartExponentMinusSign();
    case "exponentSeparator":
      return $numberFormat.PartKind$PartExponentSeparator();
    case "infinity":
      return $numberFormat.PartKind$PartInfinity();
    case "nan":
      return $numberFormat.PartKind$PartNan();
    case "unit":
      return $numberFormat.PartKind$PartUnit();
    default:
      return $numberFormat.PartKind$PartUnknown(type);
  }
}

function toPart(
  item: Intl.NumberFormatPart,
): $numberFormat.Part$ {
  return $numberFormat.Part$Part(fromPartKind(item.type), item.value);
}

interface NumberRangeFormatPart {
  type: string;
  value: string;
  source: "startRange" | "shared" | "endRange";
}

function toRangePart(item: NumberRangeFormatPart): $numberFormat.RangePart$ {
  return $numberFormat.RangePart$RangePart(
    fromPartKind(item.type),
    item.value,
    fromRangeSource(item.source),
  );
}

export const build: typeof $numberFormat.do_build = (
  locales,
  locale_matcher,
  style,
  currency,
  currency_display,
  currency_sign,
  unit,
  unit_display,
  use_grouping,
  minimum_integer_digits,
  minimum_fraction_digits,
  maximum_fraction_digits,
  minimum_significant_digits,
  maximum_significant_digits,
  notation,
  compact_display,
  sign_display,
  rounding_mode,
  rounding_priority,
  rounding_increment,
  trailing_zero_display,
  numbering_system,
) => {
  const options: Intl.NumberFormatOptions = {};
  mapIfSome(options, "localeMatcher", locale_matcher, toLocaleMatcher);
  mapIfSome(options, "style", style, toStyle);
  setIfSome(options, "currency", currency);
  mapIfSome(options, "currencyDisplay", currency_display, toCurrencyDisplay);
  mapIfSome(options, "currencySign", currency_sign, toCurrencySign);
  setIfSome(options, "unit", unit);
  mapIfSome(options, "unitDisplay", unit_display, toUnitDisplay);
  mapIfSome(options, "useGrouping", use_grouping, toUseGrouping);
  setIfSome(options, "minimumIntegerDigits", minimum_integer_digits);
  setIfSome(options, "minimumFractionDigits", minimum_fraction_digits);
  setIfSome(options, "maximumFractionDigits", maximum_fraction_digits);
  setIfSome(options, "minimumSignificantDigits", minimum_significant_digits);
  setIfSome(options, "maximumSignificantDigits", maximum_significant_digits);
  mapIfSome(options, "notation", notation, toNotation);
  mapIfSome(options, "compactDisplay", compact_display, toCompactDisplay);
  mapIfSome(options, "signDisplay", sign_display, toSignDisplay);
  mapIfSome(options, "roundingMode", rounding_mode, toRoundingMode);
  mapIfSome(
    options,
    "roundingPriority",
    rounding_priority,
    toRoundingPriority,
  );
  setIfSome(options, "roundingIncrement", rounding_increment);
  mapIfSome(
    options,
    "trailingZeroDisplay",
    trailing_zero_display,
    toTrailingZeroDisplay,
  );
  setIfSome(options, "numberingSystem", numbering_system);
  try {
    return Result$Ok(new Intl.NumberFormat(toArray(locales), options));
  } catch {
    return Result$Error(undefined);
  }
};

export const format: typeof $numberFormat.format_float = (formatter, value) => {
  return formatter.format(value);
};

export const format_to_parts: typeof $numberFormat.format_float_to_parts = (
  formatter,
  value,
) => {
  return fromArrayMapped(formatter.formatToParts(value), toPart);
};

export const format_range: typeof $numberFormat.format_float_range = (
  formatter,
  start,
  end,
) => {
  try {
    return Result$Ok(formatter.formatRange(start, end));
  } catch {
    return Result$Error(undefined);
  }
};

export const format_range_to_parts:
  typeof $numberFormat.format_float_range_to_parts = (
    formatter,
    start,
    end,
  ) => {
    try {
      return Result$Ok(
        fromArrayMapped(formatter.formatRangeToParts(start, end), toRangePart),
      );
    } catch {
      return Result$Error(undefined);
    }
  };

export const resolved_locale: typeof $numberFormat.resolved_locale = (
  formatter,
) => {
  return formatter.resolvedOptions().locale;
};

export const supported_locales_of: typeof $numberFormat.supported_locales_of = (
  locales,
) => {
  return fromArray(Intl.NumberFormat.supportedLocalesOf(toArray(locales)));
};
