import type * as $date from "$/gossamer/gossamer/date.mjs";
import { Result$Error, Result$Ok } from "$/prelude.mjs";
import { toResult } from "~/utils/result.ffi.ts";

export type Date$ = Date;

function isValid(date: Date): boolean {
  return !Number.isNaN(date.getTime());
}

export const new_: typeof $date.new$ = () => {
  return new Date();
};

export const from_time: typeof $date.from_time = (time) => {
  return new Date(time);
};

export const from_string: typeof $date.from_string = (string) => {
  const date = new Date(string);
  return isValid(date) ? Result$Ok(date) : Result$Error(undefined);
};

export const now: typeof $date.now = () => {
  return Date.now();
};

export const parse: typeof $date.parse = (string) => {
  const time = Date.parse(string);
  return Number.isNaN(time) ? Result$Error(undefined) : Result$Ok(time);
};

export const time: typeof $date.time = (date) => date.getTime();
export const full_year: typeof $date.full_year = (date) => date.getFullYear();
export const month: typeof $date.month = (date) => date.getMonth();
export const date: typeof $date.date = (d) => d.getDate();
export const day: typeof $date.day = (date) => date.getDay();
export const hours: typeof $date.hours = (date) => date.getHours();
export const minutes: typeof $date.minutes = (date) => date.getMinutes();
export const seconds: typeof $date.seconds = (date) => date.getSeconds();
export const milliseconds: typeof $date.milliseconds = (date) =>
  date.getMilliseconds();

export const utc_full_year: typeof $date.utc_full_year = (date) =>
  date.getUTCFullYear();
export const utc_month: typeof $date.utc_month = (date) => date.getUTCMonth();
export const utc_date: typeof $date.utc_date = (d) => d.getUTCDate();
export const utc_day: typeof $date.utc_day = (date) => date.getUTCDay();
export const utc_hours: typeof $date.utc_hours = (date) => date.getUTCHours();
export const utc_minutes: typeof $date.utc_minutes = (date) =>
  date.getUTCMinutes();
export const utc_seconds: typeof $date.utc_seconds = (date) =>
  date.getUTCSeconds();
export const utc_milliseconds: typeof $date.utc_milliseconds = (date) =>
  date.getUTCMilliseconds();

export const timezone_offset: typeof $date.timezone_offset = (date) =>
  date.getTimezoneOffset();

export const set_time: typeof $date.set_time = (date, time) => {
  date.setTime(time);
  return date;
};

export const set_full_year: typeof $date.set_full_year = (date, year) => {
  date.setFullYear(year);
  return date;
};

export const set_month: typeof $date.set_month = (date, month) => {
  date.setMonth(month);
  return date;
};

export const set_date: typeof $date.set_date = (d, day) => {
  d.setDate(day);
  return d;
};

export const set_hours: typeof $date.set_hours = (date, hours) => {
  date.setHours(hours);
  return date;
};

export const set_minutes: typeof $date.set_minutes = (date, minutes) => {
  date.setMinutes(minutes);
  return date;
};

export const set_seconds: typeof $date.set_seconds = (date, seconds) => {
  date.setSeconds(seconds);
  return date;
};

export const set_milliseconds: typeof $date.set_milliseconds = (
  date,
  milliseconds,
) => {
  date.setMilliseconds(milliseconds);
  return date;
};

export const set_utc_full_year: typeof $date.set_utc_full_year = (
  date,
  year,
) => {
  date.setUTCFullYear(year);
  return date;
};

export const set_utc_month: typeof $date.set_utc_month = (date, month) => {
  date.setUTCMonth(month);
  return date;
};

export const set_utc_date: typeof $date.set_utc_date = (d, day) => {
  d.setUTCDate(day);
  return d;
};

export const set_utc_hours: typeof $date.set_utc_hours = (date, hours) => {
  date.setUTCHours(hours);
  return date;
};

export const set_utc_minutes: typeof $date.set_utc_minutes = (
  date,
  minutes,
) => {
  date.setUTCMinutes(minutes);
  return date;
};

export const set_utc_seconds: typeof $date.set_utc_seconds = (
  date,
  seconds,
) => {
  date.setUTCSeconds(seconds);
  return date;
};

export const set_utc_milliseconds: typeof $date.set_utc_milliseconds = (
  date,
  milliseconds,
) => {
  date.setUTCMilliseconds(milliseconds);
  return date;
};

export const to_string: typeof $date.to_string = (date) => date.toString();

export const to_date_string: typeof $date.to_date_string = (date) =>
  date.toDateString();

export const to_time_string: typeof $date.to_time_string = (date) =>
  date.toTimeString();

export const to_iso_string: typeof $date.to_iso_string = (date) => {
  return toResult.fromThrows(() => date.toISOString());
};

export const to_utc_string: typeof $date.to_utc_string = (date) =>
  date.toUTCString();

export const to_json: typeof $date.to_json = (date) => {
  return toResult.fromThrows(() => date.toJSON());
};

export const to_locale_string: typeof $date.to_locale_string = (date) =>
  date.toLocaleString();

export const to_locale_date_string: typeof $date.to_locale_date_string = (
  date,
) => date.toLocaleDateString();

export const to_locale_time_string: typeof $date.to_locale_time_string = (
  date,
) => date.toLocaleTimeString();
