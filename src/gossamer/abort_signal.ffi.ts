import type * as $abortSignal from "$/gossamer/gossamer/abort_signal.mjs";
import { Result$Error, Result$Ok } from "$/prelude.mjs";
import { toArray } from "~/utils/list.ffi.ts";
import { durationToMs } from "~/utils/time.ffi.ts";

export const new_: typeof $abortSignal.new$ = () => {
  const controller = new AbortController();
  return [controller.signal, (reason) => {
    controller.abort(reason);
    return undefined;
  }];
};

export const abort: typeof $abortSignal.abort = (reason) => {
  return AbortSignal.abort(reason);
};

export const any: typeof $abortSignal.any = (signals) => {
  return AbortSignal.any(toArray(signals));
};

export const timeout: typeof $abortSignal.timeout = (duration) => {
  return AbortSignal.timeout(Math.max(0, durationToMs(duration)));
};

export const is_aborted: typeof $abortSignal.is_aborted = (signal) => {
  return signal.aborted;
};

export const reason: typeof $abortSignal.reason = (signal) => {
  if (signal.reason === undefined) {
    return Result$Error(undefined);
  }
  return Result$Ok(signal.reason);
};

export const set_on_abort: typeof $abortSignal.set_on_abort = (
  signal,
  handler,
) => {
  signal.onabort = () => handler(signal);
};
