import { to_milliseconds } from "$/gleam_time/gleam/time/duration.mjs";
import type { Timestamp$ } from "$/gleam_time/gleam/time/timestamp.mjs";
import type * as $time_extra from "$/gossamer/gossamer/time_extra.mjs";
import { timestampToMs } from "~/utils/time.ffi.ts";

function timestampToDate(timestamp: Timestamp$): Date {
  return new Date(timestampToMs(timestamp));
}

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
