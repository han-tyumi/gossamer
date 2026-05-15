import * as $dateTimeFormat from "$/gossamer/gossamer/intl/date_time_format.mjs";
import { Result$Error, Result$Ok } from "$/prelude.mjs";
import {
  fromRangeSource,
  toHourCycle,
  toLabelStyle,
} from "~/utils/intl.ffi.ts";
import { fromArray, fromArrayMapped, toArray } from "~/utils/list.ffi.ts";
import { mapIfSome, setIfSome } from "~/utils/option.ffi.ts";

function toNumericWidth(
  width: $dateTimeFormat.NumericWidth$,
): "numeric" | "2-digit" {
  return $dateTimeFormat.NumericWidth$isNumeric(width) ? "numeric" : "2-digit";
}

function toMonth(
  month: $dateTimeFormat.Month$,
): "numeric" | "2-digit" | "long" | "short" | "narrow" {
  if ($dateTimeFormat.Month$isMonthNumeric(month)) return "numeric";
  if ($dateTimeFormat.Month$isMonthTwoDigit(month)) return "2-digit";
  if ($dateTimeFormat.Month$isMonthLong(month)) return "long";
  if ($dateTimeFormat.Month$isMonthShort(month)) return "short";
  return "narrow";
}

function toFractionalSecondDigits(
  digits: $dateTimeFormat.FractionalSecondDigits$,
): 1 | 2 | 3 {
  if ($dateTimeFormat.FractionalSecondDigits$isFractionalSeconds1(digits)) {
    return 1;
  }
  if ($dateTimeFormat.FractionalSecondDigits$isFractionalSeconds2(digits)) {
    return 2;
  }
  return 3;
}

function toTimeZoneName(
  name: $dateTimeFormat.TimeZoneName$,
):
  | "short"
  | "long"
  | "shortOffset"
  | "longOffset"
  | "shortGeneric"
  | "longGeneric" {
  if ($dateTimeFormat.TimeZoneName$isTimeZoneShort(name)) return "short";
  if ($dateTimeFormat.TimeZoneName$isTimeZoneLong(name)) return "long";
  if ($dateTimeFormat.TimeZoneName$isTimeZoneShortOffset(name)) {
    return "shortOffset";
  }
  if ($dateTimeFormat.TimeZoneName$isTimeZoneLongOffset(name)) {
    return "longOffset";
  }
  if ($dateTimeFormat.TimeZoneName$isTimeZoneShortGeneric(name)) {
    return "shortGeneric";
  }
  return "longGeneric";
}

function toStyle(
  style: $dateTimeFormat.Style$,
): "full" | "long" | "medium" | "short" {
  if ($dateTimeFormat.Style$isStyleFull(style)) return "full";
  if ($dateTimeFormat.Style$isStyleLong(style)) return "long";
  if ($dateTimeFormat.Style$isStyleMedium(style)) return "medium";
  return "short";
}

function fromPartKind(type: string): $dateTimeFormat.PartKind$ {
  switch (type) {
    case "literal":
      return $dateTimeFormat.PartKind$PartLiteral();
    case "era":
      return $dateTimeFormat.PartKind$PartEra();
    case "year":
      return $dateTimeFormat.PartKind$PartYear();
    case "relatedYear":
      return $dateTimeFormat.PartKind$PartRelatedYear();
    case "yearName":
      return $dateTimeFormat.PartKind$PartYearName();
    case "month":
      return $dateTimeFormat.PartKind$PartMonth();
    case "day":
      return $dateTimeFormat.PartKind$PartDay();
    case "weekday":
      return $dateTimeFormat.PartKind$PartWeekday();
    case "hour":
      return $dateTimeFormat.PartKind$PartHour();
    case "minute":
      return $dateTimeFormat.PartKind$PartMinute();
    case "second":
      return $dateTimeFormat.PartKind$PartSecond();
    case "fractionalSecond":
      return $dateTimeFormat.PartKind$PartFractionalSecond();
    case "dayPeriod":
      return $dateTimeFormat.PartKind$PartDayPeriod();
    case "timeZoneName":
      return $dateTimeFormat.PartKind$PartTimeZoneName();
    default:
      return $dateTimeFormat.PartKind$PartUnknown(type);
  }
}

function toPart(
  item: { type: string; value: string },
): $dateTimeFormat.Part$ {
  return $dateTimeFormat.Part$Part(fromPartKind(item.type), item.value);
}

function toRangePart(
  item: {
    type: string;
    value: string;
    source: "shared" | "startRange" | "endRange";
  },
): $dateTimeFormat.RangePart$ {
  return $dateTimeFormat.RangePart$RangePart(
    fromPartKind(item.type),
    item.value,
    fromRangeSource(item.source),
  );
}

function dateFromUnixSeconds(unixSeconds: number): Date {
  return new Date(unixSeconds * 1000);
}

export const build: typeof $dateTimeFormat.do_build = (
  locales,
  calendar,
  numberingSystem,
  hour12,
  hourCycle,
  timeZone,
  weekday,
  era,
  year,
  month,
  day,
  hour,
  minute,
  second,
  fractionalSecondDigits,
  timeZoneName,
  dayPeriod,
  dateStyle,
  timeStyle,
) => {
  const options: Intl.DateTimeFormatOptions = {};
  mapIfSome(options, "calendar", calendar, (value) => value);
  mapIfSome(options, "numberingSystem", numberingSystem, (value) => value);
  setIfSome(options, "hour12", hour12);
  mapIfSome(options, "hourCycle", hourCycle, toHourCycle);
  mapIfSome(options, "timeZone", timeZone, (value) => value);
  mapIfSome(options, "weekday", weekday, toLabelStyle);
  mapIfSome(options, "era", era, toLabelStyle);
  mapIfSome(options, "year", year, toNumericWidth);
  mapIfSome(options, "month", month, toMonth);
  mapIfSome(options, "day", day, toNumericWidth);
  mapIfSome(options, "hour", hour, toNumericWidth);
  mapIfSome(options, "minute", minute, toNumericWidth);
  mapIfSome(options, "second", second, toNumericWidth);
  mapIfSome(
    options,
    "fractionalSecondDigits",
    fractionalSecondDigits,
    toFractionalSecondDigits,
  );
  mapIfSome(options, "timeZoneName", timeZoneName, toTimeZoneName);
  mapIfSome(options, "dayPeriod", dayPeriod, toLabelStyle);
  mapIfSome(options, "dateStyle", dateStyle, toStyle);
  mapIfSome(options, "timeStyle", timeStyle, toStyle);
  try {
    return Result$Ok(new Intl.DateTimeFormat(toArray(locales), options));
  } catch {
    return Result$Error(undefined);
  }
};

export const format: typeof $dateTimeFormat.do_format = (
  formatter,
  unixSeconds,
) => {
  return formatter.format(dateFromUnixSeconds(unixSeconds));
};

export const format_to_parts: typeof $dateTimeFormat.do_format_to_parts = (
  formatter,
  unixSeconds,
) => {
  return fromArrayMapped(
    formatter.formatToParts(dateFromUnixSeconds(unixSeconds)),
    toPart,
  );
};

export const format_range: typeof $dateTimeFormat.do_format_range = (
  formatter,
  fromSeconds,
  toSeconds,
) => {
  return formatter.formatRange(
    dateFromUnixSeconds(fromSeconds),
    dateFromUnixSeconds(toSeconds),
  );
};

export const format_range_to_parts:
  typeof $dateTimeFormat.do_format_range_to_parts = (
    formatter,
    fromSeconds,
    toSeconds,
  ) => {
    return fromArrayMapped(
      formatter.formatRangeToParts(
        dateFromUnixSeconds(fromSeconds),
        dateFromUnixSeconds(toSeconds),
      ),
      toRangePart,
    );
  };

export const resolved_locale: typeof $dateTimeFormat.resolved_locale = (
  formatter,
) => {
  return formatter.resolvedOptions().locale;
};

export const supported_locales_of: typeof $dateTimeFormat.supported_locales_of =
  (locales) => {
    return fromArray(Intl.DateTimeFormat.supportedLocalesOf(toArray(locales)));
  };
