import { to_milliseconds } from "$/gleam_time/gleam/time/duration.mjs";
import type { Timestamp$ } from "$/gleam_time/gleam/time/timestamp.mjs";
import * as $time_extra from "$/gossamer/gossamer/time_extra.mjs";
import { timestampToMs } from "~/utils/time.ffi.ts";

function timestampToDate(timestamp: Timestamp$): Date {
  return new Date(timestampToMs(timestamp));
}

function toWeekday(day: number): $time_extra.Weekday$ {
  switch (day) {
    case 0:
      return $time_extra.Weekday$Sunday();
    case 1:
      return $time_extra.Weekday$Monday();
    case 2:
      return $time_extra.Weekday$Tuesday();
    case 3:
      return $time_extra.Weekday$Wednesday();
    case 4:
      return $time_extra.Weekday$Thursday();
    case 5:
      return $time_extra.Weekday$Friday();
    default:
      return $time_extra.Weekday$Saturday();
  }
}

export const to_utc_string: typeof $time_extra.to_utc_string = (timestamp) => {
  return timestampToDate(timestamp).toUTCString();
};

export const day_of_week: typeof $time_extra.day_of_week = (
  timestamp,
  offset,
) => {
  const adjusted = timestampToMs(timestamp) + to_milliseconds(offset);
  return toWeekday(new Date(adjusted).getUTCDay());
};
