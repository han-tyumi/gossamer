import {
  add,
  type Duration$,
  nanoseconds as durationNanoseconds,
  seconds as durationSeconds,
  to_seconds_and_nanoseconds as durationToSecondsAndNanoseconds,
} from "$/gleam_time/gleam/time/duration.mjs";
import {
  from_unix_seconds_and_nanoseconds,
  type Timestamp$,
  to_unix_seconds_and_nanoseconds,
} from "$/gleam_time/gleam/time/timestamp.mjs";

export function msToTimestamp(ms: number): Timestamp$ {
  const seconds = Math.floor(ms / 1000);
  const nanoseconds = (ms - seconds * 1000) * 1_000_000;
  return from_unix_seconds_and_nanoseconds(seconds, nanoseconds);
}

export function timestampToMs(timestamp: Timestamp$): number {
  const [seconds, nanoseconds] = to_unix_seconds_and_nanoseconds(timestamp);
  return seconds * 1000 + nanoseconds / 1_000_000;
}

export function msToDuration(ms: number): Duration$ {
  const wholeSeconds = Math.floor(ms / 1000);
  const remainderMs = ms - wholeSeconds * 1000;
  const ns = Math.round(remainderMs * 1_000_000);
  return add(durationSeconds(wholeSeconds), durationNanoseconds(ns));
}

export function durationToMs(duration: Duration$): number {
  const [seconds, nanoseconds] = durationToSecondsAndNanoseconds(duration);
  return seconds * 1000 + nanoseconds / 1_000_000;
}
