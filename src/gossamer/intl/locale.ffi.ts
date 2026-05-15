import * as $locale from "$/gossamer/gossamer/intl/locale.mjs";
import { Result$Error, Result$Ok } from "$/prelude.mjs";
import {
  fromCaseFirst,
  fromHourCycle,
  toCaseFirst,
  toHourCycle,
} from "~/utils/intl.ffi.ts";
import { fromArray, fromArrayMapped } from "~/utils/list.ffi.ts";
import { mapIfSome, setIfSome, toOption } from "~/utils/option.ffi.ts";

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

export const base_name: typeof $locale.base_name = (locale) => locale.baseName;

export const language: typeof $locale.language = (locale) => locale.language;

export const script: typeof $locale.script = (locale) =>
  toOption(locale.script);

export const region: typeof $locale.region = (locale) =>
  toOption(locale.region);

export const calendar: typeof $locale.calendar = (locale) =>
  toOption(locale.calendar);

export const case_first: typeof $locale.case_first = (locale) => {
  const value = locale.caseFirst;
  if (value === undefined) return toOption(undefined);
  return toOption(fromCaseFirst(value));
};

export const collation: typeof $locale.collation = (locale) =>
  toOption(locale.collation);

export const hour_cycle: typeof $locale.hour_cycle = (locale) => {
  const value = locale.hourCycle;
  if (value === undefined) return toOption(undefined);
  return toOption(fromHourCycle(value));
};

export const numbering_system: typeof $locale.numbering_system = (locale) =>
  toOption(locale.numberingSystem);

export const numeric: typeof $locale.numeric = (locale) =>
  locale.numeric ?? false;

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
  return zones === undefined ? toOption(undefined) : toOption(fromArray(zones));
};

export const text_info: typeof $locale.text_info = (locale) => {
  const info = locale.getTextInfo();
  return $locale.TextInfo$TextInfo(fromTextDirection(info.direction ?? "ltr"));
};

export const week_info: typeof $locale.week_info = (locale) => {
  const info = locale.getWeekInfo();
  return $locale.WeekInfo$WeekInfo(info.firstDay, fromArray(info.weekend));
};

export const maximize: typeof $locale.maximize = (locale) => locale.maximize();

export const minimize: typeof $locale.minimize = (locale) => locale.minimize();

export const to_string: typeof $locale.to_string = (locale) =>
  locale.toString();
