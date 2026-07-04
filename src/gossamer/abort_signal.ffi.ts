import * as $abortSignal from "$/gossamer/gossamer/abort_signal.mjs";
import { Result$Error, Result$Ok } from "$/prelude.mjs";
import { toArray } from "~/utils/list.ffi.ts";
import { durationToMs } from "~/utils/time.ffi.ts";

function classify(rawReason: unknown) {
  if (rawReason instanceof DOMException) {
    if (rawReason.name === "TimeoutError") {
      return $abortSignal.AbortReason$Timeout();
    }
    if (rawReason.name === "AbortError") {
      return $abortSignal.AbortReason$Default();
    }
  }
  return $abortSignal.AbortReason$Reason(rawReason);
}

function abortController(
  controller: AbortController,
  reason: $abortSignal.AbortReason$,
): void {
  if ($abortSignal.AbortReason$isDefault(reason)) {
    controller.abort();
    return;
  }
  if ($abortSignal.AbortReason$isTimeout(reason)) {
    controller.abort(new DOMException("Signal timed out", "TimeoutError"));
    return;
  }
  controller.abort($abortSignal.AbortReason$Reason$value(reason));
}

export const new_: typeof $abortSignal.new$ = () => {
  const controller = new AbortController();
  return [controller.signal, (reason) => {
    abortController(controller, reason);
    return undefined;
  }];
};

export const abort: typeof $abortSignal.abort = (reason) => {
  const controller = new AbortController();
  abortController(controller, reason);
  return controller.signal;
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
  if (!signal.aborted) return Result$Error(undefined);
  return Result$Ok(classify(signal.reason));
};

export const on_abort: typeof $abortSignal.on_abort = (signal) => {
  if (signal.aborted) return Promise.resolve(classify(signal.reason));
  return new Promise((resolve) => {
    signal.addEventListener("abort", () => resolve(classify(signal.reason)), {
      once: true,
    });
  });
};
