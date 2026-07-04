import * as $dateTimeFormat from "$/gossamer/gossamer/intl/date_time_format.mjs";
import { Result$Error, Result$Ok } from "$/prelude.mjs";
import {
  fromHourCycle,
  fromLabelStyle,
  fromRangeSource,
  supportedLocalesOf,
  toHourCycle,
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

function fromNumericWidth(value: string): $dateTimeFormat.NumericWidth$ {
  return value === "2-digit"
    ? $dateTimeFormat.NumericWidth$TwoDigit()
    : $dateTimeFormat.NumericWidth$Numeric();
}

function fromMonth(value: string): $dateTimeFormat.Month$ {
  switch (value) {
    case "2-digit":
      return $dateTimeFormat.Month$MonthTwoDigit();
    case "long":
      return $dateTimeFormat.Month$MonthLong();
    case "short":
      return $dateTimeFormat.Month$MonthShort();
    case "narrow":
      return $dateTimeFormat.Month$MonthNarrow();
    default:
      return $dateTimeFormat.Month$MonthNumeric();
  }
}

function fromFractionalSecondDigits(
  value: number,
): $dateTimeFormat.FractionalSecondDigits$ {
  switch (value) {
    case 2:
      return $dateTimeFormat.FractionalSecondDigits$FractionalSeconds2();
    case 3:
      return $dateTimeFormat.FractionalSecondDigits$FractionalSeconds3();
    default:
      return $dateTimeFormat.FractionalSecondDigits$FractionalSeconds1();
  }
}

function fromTimeZoneName(value: string): $dateTimeFormat.TimeZoneName$ {
  switch (value) {
    case "long":
      return $dateTimeFormat.TimeZoneName$TimeZoneLong();
    case "shortOffset":
      return $dateTimeFormat.TimeZoneName$TimeZoneShortOffset();
    case "longOffset":
      return $dateTimeFormat.TimeZoneName$TimeZoneLongOffset();
    case "shortGeneric":
      return $dateTimeFormat.TimeZoneName$TimeZoneShortGeneric();
    case "longGeneric":
      return $dateTimeFormat.TimeZoneName$TimeZoneLongGeneric();
    default:
      return $dateTimeFormat.TimeZoneName$TimeZoneShort();
  }
}

function fromStyle(value: string): $dateTimeFormat.Style$ {
  switch (value) {
    case "full":
      return $dateTimeFormat.Style$StyleFull();
    case "long":
      return $dateTimeFormat.Style$StyleLong();
    case "medium":
      return $dateTimeFormat.Style$StyleMedium();
    default:
      return $dateTimeFormat.Style$StyleShort();
  }
}

function fromPartKind(type: string): $dateTimeFormat.PartKind$ {
  switch (type) {
    case "literal":
      return $dateTimeFormat.PartKind$Literal();
    case "era":
      return $dateTimeFormat.PartKind$Era();
    case "year":
      return $dateTimeFormat.PartKind$Year();
    case "relatedYear":
      return $dateTimeFormat.PartKind$RelatedYear();
    case "yearName":
      return $dateTimeFormat.PartKind$YearName();
    case "month":
      return $dateTimeFormat.PartKind$Month();
    case "day":
      return $dateTimeFormat.PartKind$Day();
    case "weekday":
      return $dateTimeFormat.PartKind$Weekday();
    case "hour":
      return $dateTimeFormat.PartKind$Hour();
    case "minute":
      return $dateTimeFormat.PartKind$Minute();
    case "second":
      return $dateTimeFormat.PartKind$Second();
    case "fractionalSecond":
      return $dateTimeFormat.PartKind$FractionalSecond();
    case "dayPeriod":
      return $dateTimeFormat.PartKind$DayPeriod();
    case "timeZoneName":
      return $dateTimeFormat.PartKind$TimeZoneName();
    default:
      throw new Error(
        `gossamer.intl.date_time_format: runtime returned unexpected DateTimeFormat part type: ${type}`,
      );
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
  locale_matcher,
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
  mapIfSome(options, "localeMatcher", locale_matcher, toLocaleMatcher);
  setIfSome(options, "calendar", calendar);
  setIfSome(options, "numberingSystem", numberingSystem);
  setIfSome(options, "hour12", hour12);
  mapIfSome(options, "hourCycle", hourCycle, toHourCycle);
  setIfSome(options, "timeZone", timeZone);
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

export const resolved_options: typeof $dateTimeFormat.resolved_options = (
  formatter,
) => {
  const resolved = formatter.resolvedOptions();
  return $dateTimeFormat.ResolvedOptions$ResolvedOptions(
    resolved.locale,
    resolved.calendar,
    resolved.numberingSystem,
    resolved.timeZone,
    mapOption(resolved.hourCycle, fromHourCycle),
    toOption(resolved.hour12),
    mapOption(resolved.weekday, fromLabelStyle),
    mapOption(resolved.era, fromLabelStyle),
    mapOption(resolved.year, fromNumericWidth),
    mapOption(resolved.month, fromMonth),
    mapOption(resolved.day, fromNumericWidth),
    mapOption(resolved.hour, fromNumericWidth),
    mapOption(resolved.minute, fromNumericWidth),
    mapOption(resolved.second, fromNumericWidth),
    mapOption(resolved.fractionalSecondDigits, fromFractionalSecondDigits),
    mapOption(resolved.timeZoneName, fromTimeZoneName),
    mapOption(resolved.dayPeriod, fromLabelStyle),
    mapOption(resolved.dateStyle, fromStyle),
    mapOption(resolved.timeStyle, fromStyle),
  );
};

export const supported_locales_of: typeof $dateTimeFormat.supported_locales_of =
  (locales) => {
    return supportedLocalesOf(Intl.DateTimeFormat.supportedLocalesOf, locales);
  };
