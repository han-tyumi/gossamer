import * as $performanceEntry from "$/gossamer/gossamer/performance_entry.mjs";
import { toOption } from "~/utils/option.ffi.ts";
import { msToDuration } from "~/utils/time.ffi.ts";

export const info: typeof $performanceEntry.info = (entry) => {
  return $performanceEntry.Info$Info(
    entry.name,
    entry.entryType,
    msToDuration(entry.startTime),
    msToDuration(entry.duration),
    toOption((entry as PerformanceMark).detail),
  );
};

export const to_json: typeof $performanceEntry.to_json = (entry) => {
  return entry.toJSON();
};
