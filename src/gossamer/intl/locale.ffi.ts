import * as $locale from "$/gossamer/gossamer/intl/locale.mjs";
import { Result$Error, Result$Ok } from "$/prelude.mjs";
import {
  fromCaseFirst,
  fromHourCycle,
  toCaseFirst,
  toHourCycle,
} from "~/utils/intl.ffi.ts";
import { fromArray, fromArrayMapped } from "~/utils/list.ffi.ts";
import {
  mapIfSome,
  mapOption,
  setIfSome,
  toOption,
} from "~/utils/option.ffi.ts";

function fromTextDirection(value: string): $locale.TextDirection$ {
  return value === "rtl"
    ? $locale.TextDirection$Rtl()
    : $locale.TextDirection$Ltr();
}

export const build: typeof $locale.do_build = (
  tag,
  calendar,
  case_first,
  collation,
  hour_cycle,
  language,
  numbering_system,
  numeric,
  region,
  script,
) => {
  const options: Intl.LocaleOptions = {};
  setIfSome(options, "calendar", calendar);
  mapIfSome(options, "caseFirst", case_first, toCaseFirst);
  setIfSome(options, "collation", collation);
  mapIfSome(options, "hourCycle", hour_cycle, toHourCycle);
  setIfSome(options, "language", language);
  setIfSome(options, "numberingSystem", numbering_system);
  setIfSome(options, "numeric", numeric);
  setIfSome(options, "region", region);
  setIfSome(options, "script", script);
  try {
    return Result$Ok(new Intl.Locale(tag, options));
  } catch {
    return Result$Error(undefined);
  }
};

export const info: typeof $locale.info = (locale) =>
  $locale.Info$Info(
    locale.baseName,
    locale.language,
    toOption(locale.script),
    toOption(locale.region),
    toOption(locale.calendar),
    mapOption(locale.caseFirst, fromCaseFirst),
    toOption(locale.collation),
    mapOption(locale.hourCycle, fromHourCycle),
    toOption(locale.numberingSystem),
    locale.numeric ?? false,
  );

export const calendars: typeof $locale.calendars = (locale) =>
  fromArray(locale.getCalendars());

export const collations: typeof $locale.collations = (locale) =>
  fromArray(locale.getCollations());

export const hour_cycles: typeof $locale.hour_cycles = (locale) =>
  fromArrayMapped(locale.getHourCycles(), fromHourCycle);

export const numbering_systems: typeof $locale.numbering_systems = (locale) =>
  fromArray(locale.getNumberingSystems());

export const time_zones: typeof $locale.time_zones = (locale) => {
  const zones = locale.getTimeZones();
  return zones === undefined
    ? Result$Error(undefined)
    : Result$Ok(fromArray(zones));
};

export const text_direction: typeof $locale.text_direction = (locale) =>
  fromTextDirection(locale.getTextInfo().direction ?? "ltr");

export const week_info: typeof $locale.week_info = (locale) => {
  const info = locale.getWeekInfo();
  return $locale.WeekInfo$WeekInfo(info.firstDay, fromArray(info.weekend));
};

export const maximize: typeof $locale.maximize = (locale) => locale.maximize();

export const minimize: typeof $locale.minimize = (locale) => locale.minimize();

export const to_string: typeof $locale.to_string = (locale) =>
  locale.toString();
