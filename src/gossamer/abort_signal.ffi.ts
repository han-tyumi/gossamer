import type * as $abortSignal from "$/gossamer/gossamer/abort_signal.mjs";
import { toArray } from "~/utils/list.ffi.ts";
import { toResult } from "~/utils/result.ffi.ts";
import { durationToMs } from "~/utils/time.ffi.ts";

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
  return toResult(signal.reason);
};

export const on_abort: typeof $abortSignal.on_abort = (signal, handler) => {
  signal.onabort = () => handler();
};
