import type * as $gossamer from "$/gossamer/gossamer.mjs";
import { Result$Error, Result$Ok } from "$/prelude.mjs";
import { durationToMs } from "~/utils/time.ffi.ts";

export const decode_base64: typeof $gossamer.decode_base64 = (encoded) => {
  try {
    return Result$Ok(globalThis.atob(encoded));
  } catch {
    return Result$Error(undefined);
  }
};

export const encode_base64: typeof $gossamer.encode_base64 = (data) => {
  try {
    return Result$Ok(globalThis.btoa(data));
  } catch {
    return Result$Error(undefined);
  }
};

export const clear_interval: typeof $gossamer.clear_interval = (id) => {
  globalThis.clearInterval(id);
};

export const clear_timeout: typeof $gossamer.clear_timeout = (id) => {
  globalThis.clearTimeout(id);
};

export const queue_microtask: typeof $gossamer.queue_microtask = (func) => {
  globalThis.queueMicrotask(func);
};

// Node's `setTimeout`/`setInterval` return a `Timeout` object whose
// `Symbol.toPrimitive` is the numeric id. Coerce to a number so the Gleam
// `Int` type holds an actual integer on every runtime. `clearInterval` /
// `clearTimeout` accept the numeric id on Node.

export const set_interval: typeof $gossamer.set_interval = (
  delay,
  callback,
) => {
  return Number(
    globalThis.setInterval(callback, Math.max(0, durationToMs(delay))),
  );
};

export const set_timeout: typeof $gossamer.set_timeout = (delay, callback) => {
  return Number(
    globalThis.setTimeout(callback, Math.max(0, durationToMs(delay))),
  );
};

export const user_agent: typeof $gossamer.user_agent = () => {
  return globalThis.navigator.userAgent;
};
