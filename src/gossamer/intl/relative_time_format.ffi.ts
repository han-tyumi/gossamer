import * as $relativeTimeFormat from "$/gossamer/gossamer/intl/relative_time_format.mjs";
import { Result$Error, Result$Ok } from "$/prelude.mjs";
import {
  fromLabelStyle,
  toLabelStyle,
  toLocaleMatcher,
} from "~/utils/intl.ffi.ts";
import { fromArray, fromArrayMapped, toArray } from "~/utils/list.ffi.ts";
import { mapIfSome, mapOption } from "~/utils/option.ffi.ts";

function toNumeric(numeric: $relativeTimeFormat.Numeric$): "always" | "auto" {
  return $relativeTimeFormat.Numeric$isAlways(numeric) ? "always" : "auto";
}

function fromNumeric(value: string): $relativeTimeFormat.Numeric$ {
  return value === "auto"
    ? $relativeTimeFormat.Numeric$Auto()
    : $relativeTimeFormat.Numeric$Always();
}

function toUnit(
  unit: $relativeTimeFormat.Unit$,
): Intl.RelativeTimeFormatUnit {
  if ($relativeTimeFormat.Unit$isYear(unit)) return "year";
  if ($relativeTimeFormat.Unit$isQuarter(unit)) return "quarter";
  if ($relativeTimeFormat.Unit$isMonth(unit)) return "month";
  if ($relativeTimeFormat.Unit$isWeek(unit)) return "week";
  if ($relativeTimeFormat.Unit$isDay(unit)) return "day";
  if ($relativeTimeFormat.Unit$isHour(unit)) return "hour";
  if ($relativeTimeFormat.Unit$isMinute(unit)) return "minute";
  return "second";
}

function fromUnit(unit: string): $relativeTimeFormat.Unit$ {
  switch (unit) {
    case "year":
      return $relativeTimeFormat.Unit$Year();
    case "quarter":
      return $relativeTimeFormat.Unit$Quarter();
    case "month":
      return $relativeTimeFormat.Unit$Month();
    case "week":
      return $relativeTimeFormat.Unit$Week();
    case "day":
      return $relativeTimeFormat.Unit$Day();
    case "hour":
      return $relativeTimeFormat.Unit$Hour();
    case "minute":
      return $relativeTimeFormat.Unit$Minute();
    default:
      return $relativeTimeFormat.Unit$Second();
  }
}

function fromPartKind(type: string): $relativeTimeFormat.PartKind$ {
  switch (type) {
    case "literal":
      return $relativeTimeFormat.PartKind$Literal();
    case "integer":
      return $relativeTimeFormat.PartKind$Integer();
    case "decimal":
      return $relativeTimeFormat.PartKind$Decimal();
    case "fraction":
      return $relativeTimeFormat.PartKind$Fraction();
    case "group":
      return $relativeTimeFormat.PartKind$Group();
    case "minusSign":
      return $relativeTimeFormat.PartKind$MinusSign();
    case "plusSign":
      return $relativeTimeFormat.PartKind$PlusSign();
    case "infinity":
      return $relativeTimeFormat.PartKind$Infinity();
    case "nan":
      return $relativeTimeFormat.PartKind$Nan();
    default:
      throw new Error(
        `gossamer.intl.relative_time_format: runtime returned unexpected RelativeTimeFormat part type: ${type}`,
      );
  }
}

function toPart(
  item: { type: string; value: string; unit?: string },
): $relativeTimeFormat.Part$ {
  return $relativeTimeFormat.Part$Part(
    fromPartKind(item.type),
    item.value,
    mapOption(item.unit, fromUnit),
  );
}

export const build: typeof $relativeTimeFormat.do_build = (
  locales,
  locale_matcher,
  numeric,
  style,
) => {
  const options: Intl.RelativeTimeFormatOptions = {};
  mapIfSome(options, "localeMatcher", locale_matcher, toLocaleMatcher);
  mapIfSome(options, "numeric", numeric, toNumeric);
  mapIfSome(options, "style", style, toLabelStyle);
  try {
    return Result$Ok(new Intl.RelativeTimeFormat(toArray(locales), options));
  } catch {
    return Result$Error(undefined);
  }
};

export const format: typeof $relativeTimeFormat.format_int = (
  formatter,
  value,
  unit,
) => {
  return formatter.format(value, toUnit(unit));
};

export const format_to_parts: typeof $relativeTimeFormat.format_int_to_parts = (
  formatter,
  value,
  unit,
) => {
  return fromArrayMapped(formatter.formatToParts(value, toUnit(unit)), toPart);
};

export const resolved_options: typeof $relativeTimeFormat.resolved_options = (
  formatter,
) => {
  const resolved = formatter.resolvedOptions();
  return $relativeTimeFormat.ResolvedOptions$ResolvedOptions(
    resolved.locale,
    fromLabelStyle(resolved.style),
    fromNumeric(resolved.numeric),
    resolved.numberingSystem,
  );
};

export const supported_locales_of:
  typeof $relativeTimeFormat.supported_locales_of = (
    locales,
  ) => {
    return fromArray(
      Intl.RelativeTimeFormat.supportedLocalesOf(toArray(locales)),
    );
  };
