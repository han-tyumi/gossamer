import type * as $stream from "$/gossamer/gossamer/stream.mjs";
import {
  DesiredSize$Bounded,
  DesiredSize$Unbounded,
} from "$/gossamer/gossamer/stream.mjs";
import { Result$Error, Result$Ok } from "$/prelude.mjs";

// Coerces an arbitrary callback return into a Promise. Thenables pass
// through; everything else (including Gleam's `Nil` / JS `undefined`)
// becomes an immediately-resolved Promise. Stream Builders use this to
// accept lax callback shapes while preserving the runtime's "await the
// Promise before continuing" semantics.
export const as_promise: typeof $stream.as_promise = (value) => {
  if (
    value !== null &&
    typeof value === "object" &&
    "then" in value &&
    typeof value.then === "function"
  ) {
    return value;
  }
  return Promise.resolve(undefined);
};

// Maps a JS `desiredSize` (`number | null`) to `Result(DesiredSize, Nil)`:
// `null` (errored) becomes `Error(Nil)`, `Infinity` (an unlimited
// strategy) becomes `Ok(Unbounded)`, and a finite count becomes
// `Ok(Bounded(n))`.
export function toDesiredSize(value: number | null) {
  if (value === null) return Result$Error(undefined);
  return Result$Ok(
    Number.isFinite(value)
      ? DesiredSize$Bounded(value)
      : DesiredSize$Unbounded(),
  );
}
