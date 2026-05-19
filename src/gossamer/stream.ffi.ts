import type * as $stream from "$/gossamer/gossamer/stream.mjs";

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
