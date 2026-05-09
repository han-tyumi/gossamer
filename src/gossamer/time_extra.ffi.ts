import { to_milliseconds } from "$/gleam_time/gleam/time/duration.mjs";
import {
  type Timestamp$,
  to_unix_seconds_and_nanoseconds,
} from "$/gleam_time/gleam/time/timestamp.mjs";
import type * as $time_extra from "$/gossamer/gossamer/time_extra.mjs";

function timestampToMs(timestamp: Timestamp$): number {
  const [seconds, nanoseconds] = to_unix_seconds_and_nanoseconds(timestamp);
  return seconds * 1000 + nanoseconds / 1_000_000;
}

function timestampToDate(timestamp: Timestamp$): Date {
  return new Date(timestampToMs(timestamp));
}

export const to_locale_string: typeof $time_extra.to_locale_string = (
  timestamp,
) => {
  return timestampToDate(timestamp).toLocaleString();
};

export const to_locale_date_string: typeof $time_extra.to_locale_date_string = (
  timestamp,
) => {
  return timestampToDate(timestamp).toLocaleDateString();
};

export const to_locale_time_string: typeof $time_extra.to_locale_time_string = (
  timestamp,
) => {
  return timestampToDate(timestamp).toLocaleTimeString();
};

export const to_utc_string: typeof $time_extra.to_utc_string = (timestamp) => {
  return timestampToDate(timestamp).toUTCString();
};

export const day_of_week: typeof $time_extra.day_of_week = (
  timestamp,
  offset,
) => {
  const adjusted = timestampToMs(timestamp) + to_milliseconds(offset);
  return new Date(adjusted).getUTCDay();
};
