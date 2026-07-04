import * as $durationFormat from "$/gossamer/gossamer/intl/duration_format.mjs";
import { Result$Error, Result$Ok } from "$/prelude.mjs";
import {
  fromLabelStyle,
  supportedLocalesOf,
  toLabelStyle,
  toLocaleMatcher,
} from "~/utils/intl.ffi.ts";
import { fromArrayMapped, toArray } from "~/utils/list.ffi.ts";
import {
  mapIfSome,
  mapOption,
  setIfSome,
  toOption,
} from "~/utils/option.ffi.ts";

function toStyle(
  style: $durationFormat.Style$,
): "long" | "short" | "narrow" | "digital" {
  if ($durationFormat.Style$isStyleLong(style)) return "long";
  if ($durationFormat.Style$isStyleShort(style)) return "short";
  if ($durationFormat.Style$isStyleNarrow(style)) return "narrow";
  return "digital";
}

function toClockStyle(
  style: $durationFormat.ClockStyle$,
): "long" | "short" | "narrow" | "numeric" | "2-digit" {
  if ($durationFormat.ClockStyle$isClockLong(style)) return "long";
  if ($durationFormat.ClockStyle$isClockShort(style)) return "short";
  if ($durationFormat.ClockStyle$isClockNarrow(style)) return "narrow";
  if ($durationFormat.ClockStyle$isClockNumeric(style)) return "numeric";
  return "2-digit";
}

function toSubSecondStyle(
  style: $durationFormat.SubSecondStyle$,
): "long" | "short" | "narrow" | "numeric" {
  if ($durationFormat.SubSecondStyle$isSubSecondLong(style)) return "long";
  if ($durationFormat.SubSecondStyle$isSubSecondShort(style)) return "short";
  if ($durationFormat.SubSecondStyle$isSubSecondNarrow(style)) return "narrow";
  return "numeric";
}

function toDisplay(
  display: $durationFormat.Display$,
): "auto" | "always" {
  return $durationFormat.Display$isAuto(display) ? "auto" : "always";
}

function toFractionalDigits(
  value: $durationFormat.FractionalDigits$,
): 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 {
  if ($durationFormat.FractionalDigits$isFractionalDigits0(value)) return 0;
  if ($durationFormat.FractionalDigits$isFractionalDigits1(value)) return 1;
  if ($durationFormat.FractionalDigits$isFractionalDigits2(value)) return 2;
  if ($durationFormat.FractionalDigits$isFractionalDigits3(value)) return 3;
  if ($durationFormat.FractionalDigits$isFractionalDigits4(value)) return 4;
  if ($durationFormat.FractionalDigits$isFractionalDigits5(value)) return 5;
  if ($durationFormat.FractionalDigits$isFractionalDigits6(value)) return 6;
  if ($durationFormat.FractionalDigits$isFractionalDigits7(value)) return 7;
  if ($durationFormat.FractionalDigits$isFractionalDigits8(value)) return 8;
  return 9;
}

function fromStyle(value: string): $durationFormat.Style$ {
  switch (value) {
    case "short":
      return $durationFormat.Style$StyleShort();
    case "narrow":
      return $durationFormat.Style$StyleNarrow();
    case "digital":
      return $durationFormat.Style$StyleDigital();
    default:
      return $durationFormat.Style$StyleLong();
  }
}

function fromClockStyle(value: string): $durationFormat.ClockStyle$ {
  switch (value) {
    case "short":
      return $durationFormat.ClockStyle$ClockShort();
    case "narrow":
      return $durationFormat.ClockStyle$ClockNarrow();
    case "numeric":
      return $durationFormat.ClockStyle$ClockNumeric();
    case "2-digit":
      return $durationFormat.ClockStyle$ClockTwoDigit();
    default:
      return $durationFormat.ClockStyle$ClockLong();
  }
}

function fromSubSecondStyle(value: string): $durationFormat.SubSecondStyle$ {
  switch (value) {
    case "short":
      return $durationFormat.SubSecondStyle$SubSecondShort();
    case "narrow":
      return $durationFormat.SubSecondStyle$SubSecondNarrow();
    case "numeric":
      return $durationFormat.SubSecondStyle$SubSecondNumeric();
    default:
      return $durationFormat.SubSecondStyle$SubSecondLong();
  }
}

function fromDisplay(value: string): $durationFormat.Display$ {
  return value === "always"
    ? $durationFormat.Display$Always()
    : $durationFormat.Display$Auto();
}

function fromFractionalDigits(
  value: number,
): $durationFormat.FractionalDigits$ {
  switch (value) {
    case 1:
      return $durationFormat.FractionalDigits$FractionalDigits1();
    case 2:
      return $durationFormat.FractionalDigits$FractionalDigits2();
    case 3:
      return $durationFormat.FractionalDigits$FractionalDigits3();
    case 4:
      return $durationFormat.FractionalDigits$FractionalDigits4();
    case 5:
      return $durationFormat.FractionalDigits$FractionalDigits5();
    case 6:
      return $durationFormat.FractionalDigits$FractionalDigits6();
    case 7:
      return $durationFormat.FractionalDigits$FractionalDigits7();
    case 8:
      return $durationFormat.FractionalDigits$FractionalDigits8();
    case 9:
      return $durationFormat.FractionalDigits$FractionalDigits9();
    default:
      return $durationFormat.FractionalDigits$FractionalDigits0();
  }
}

function fromPartKind(type: string): $durationFormat.PartKind$ {
  switch (type) {
    case "integer":
      return $durationFormat.PartKind$Integer();
    case "decimal":
      return $durationFormat.PartKind$Decimal();
    case "fraction":
      return $durationFormat.PartKind$Fraction();
    case "group":
      return $durationFormat.PartKind$Group();
    case "literal":
      return $durationFormat.PartKind$Literal();
    case "unit":
      return $durationFormat.PartKind$Unit();
    default:
      throw new Error(
        `gossamer.intl.duration_format: runtime returned unexpected DurationFormat part type: ${type}`,
      );
  }
}

function toPart(
  item: { type: string; value: string; unit?: string },
): $durationFormat.Part$ {
  return $durationFormat.Part$Part(
    fromPartKind(item.type),
    item.value,
    toOption(item.unit),
  );
}

function toDuration(
  parts: $durationFormat.DurationParts$,
): Record<string, number> {
  return {
    years: $durationFormat.DurationParts$DurationParts$years(parts),
    months: $durationFormat.DurationParts$DurationParts$months(parts),
    weeks: $durationFormat.DurationParts$DurationParts$weeks(parts),
    days: $durationFormat.DurationParts$DurationParts$days(parts),
    hours: $durationFormat.DurationParts$DurationParts$hours(parts),
    minutes: $durationFormat.DurationParts$DurationParts$minutes(parts),
    seconds: $durationFormat.DurationParts$DurationParts$seconds(parts),
    milliseconds: $durationFormat.DurationParts$DurationParts$milliseconds(
      parts,
    ),
    microseconds: $durationFormat.DurationParts$DurationParts$microseconds(
      parts,
    ),
    nanoseconds: $durationFormat.DurationParts$DurationParts$nanoseconds(parts),
  };
}

export const build: typeof $durationFormat.do_build = (
  locales,
  locale_matcher,
  style,
  fractional_digits,
  numbering_system,
  years,
  months,
  weeks,
  days,
  hours,
  minutes,
  seconds,
  milliseconds,
  microseconds,
  nanoseconds,
  years_display,
  months_display,
  weeks_display,
  days_display,
  hours_display,
  minutes_display,
  seconds_display,
  milliseconds_display,
  microseconds_display,
  nanoseconds_display,
) => {
  const options: Intl.DurationFormatOptions = {};
  mapIfSome(options, "localeMatcher", locale_matcher, toLocaleMatcher);
  mapIfSome(options, "style", style, toStyle);
  mapIfSome(options, "fractionalDigits", fractional_digits, toFractionalDigits);
  setIfSome(options, "numberingSystem", numbering_system);
  mapIfSome(options, "years", years, toLabelStyle);
  mapIfSome(options, "months", months, toLabelStyle);
  mapIfSome(options, "weeks", weeks, toLabelStyle);
  mapIfSome(options, "days", days, toLabelStyle);
  mapIfSome(options, "hours", hours, toClockStyle);
  mapIfSome(options, "minutes", minutes, toClockStyle);
  mapIfSome(options, "seconds", seconds, toClockStyle);
  mapIfSome(options, "milliseconds", milliseconds, toSubSecondStyle);
  mapIfSome(options, "microseconds", microseconds, toSubSecondStyle);
  mapIfSome(options, "nanoseconds", nanoseconds, toSubSecondStyle);
  mapIfSome(options, "yearsDisplay", years_display, toDisplay);
  mapIfSome(options, "monthsDisplay", months_display, toDisplay);
  mapIfSome(options, "weeksDisplay", weeks_display, toDisplay);
  mapIfSome(options, "daysDisplay", days_display, toDisplay);
  mapIfSome(options, "hoursDisplay", hours_display, toDisplay);
  mapIfSome(options, "minutesDisplay", minutes_display, toDisplay);
  mapIfSome(options, "secondsDisplay", seconds_display, toDisplay);
  mapIfSome(options, "millisecondsDisplay", milliseconds_display, toDisplay);
  mapIfSome(options, "microsecondsDisplay", microseconds_display, toDisplay);
  mapIfSome(options, "nanosecondsDisplay", nanoseconds_display, toDisplay);
  try {
    return Result$Ok(new Intl.DurationFormat(toArray(locales), options));
  } catch {
    return Result$Error(undefined);
  }
};

export const format: typeof $durationFormat.format = (formatter, parts) => {
  try {
    return Result$Ok(formatter.format(toDuration(parts)));
  } catch {
    return Result$Error(undefined);
  }
};

export const format_to_parts: typeof $durationFormat.format_to_parts = (
  formatter,
  parts,
) => {
  try {
    return Result$Ok(
      fromArrayMapped(formatter.formatToParts(toDuration(parts)), toPart),
    );
  } catch {
    return Result$Error(undefined);
  }
};

export const format_duration: typeof $durationFormat.do_format_duration = (
  formatter,
  parts,
) => {
  return formatter.format(toDuration(parts));
};

export const format_duration_to_parts:
  typeof $durationFormat.do_format_duration_to_parts = (formatter, parts) => {
    return fromArrayMapped(formatter.formatToParts(toDuration(parts)), toPart);
  };

export const resolved_options: typeof $durationFormat.resolved_options = (
  formatter,
) => {
  const resolved = formatter.resolvedOptions();
  return $durationFormat.ResolvedOptions$ResolvedOptions(
    resolved.locale,
    resolved.numberingSystem,
    fromStyle(resolved.style),
    fromLabelStyle(resolved.years),
    fromLabelStyle(resolved.months),
    fromLabelStyle(resolved.weeks),
    fromLabelStyle(resolved.days),
    fromClockStyle(resolved.hours),
    fromClockStyle(resolved.minutes),
    fromClockStyle(resolved.seconds),
    fromSubSecondStyle(resolved.milliseconds),
    fromSubSecondStyle(resolved.microseconds),
    fromSubSecondStyle(resolved.nanoseconds),
    fromDisplay(resolved.yearsDisplay),
    fromDisplay(resolved.monthsDisplay),
    fromDisplay(resolved.weeksDisplay),
    fromDisplay(resolved.daysDisplay),
    fromDisplay(resolved.hoursDisplay),
    fromDisplay(resolved.minutesDisplay),
    fromDisplay(resolved.secondsDisplay),
    fromDisplay(resolved.millisecondsDisplay),
    fromDisplay(resolved.microsecondsDisplay),
    fromDisplay(resolved.nanosecondsDisplay),
    mapOption(resolved.fractionalDigits, fromFractionalDigits),
  );
};

export const supported_locales_of: typeof $durationFormat.supported_locales_of =
  (locales) => {
    return supportedLocalesOf(Intl.DurationFormat.supportedLocalesOf, locales);
  };
