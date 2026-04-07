import type * as $abortSignal from "$/gossamer/gossamer/abort_signal.mjs";
import { toArray } from "~/utils/list.ts";

export type AbortSignal$ = AbortSignal;

export const abort: typeof $abortSignal.abort = (reason) => {
  return AbortSignal.abort(reason);
};

export const any: typeof $abortSignal.any = (signals) => {
  return AbortSignal.any(toArray(signals));
};

export const timeout: typeof $abortSignal.timeout = (milliseconds) => {
  return AbortSignal.timeout(milliseconds);
};
