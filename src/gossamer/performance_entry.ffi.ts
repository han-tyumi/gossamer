import * as $performanceEntry from "$/gossamer/gossamer/performance_entry.mjs";
import { kind_from_name } from "$/gossamer/gossamer/performance_entry.mjs";
import { toOption } from "~/utils/option.ffi.ts";
import { msToDuration } from "~/utils/time.ffi.ts";

export function project(
  entry: PerformanceEntry,
): $performanceEntry.PerformanceEntry$ {
  const name = entry.name;
  const startTime = msToDuration(entry.startTime);
  const duration = msToDuration(entry.duration);
  switch (entry.entryType) {
    case "mark":
      return $performanceEntry.PerformanceEntry$MarkEntry(
        name,
        startTime,
        duration,
        // @ts-expect-error PerformanceMark adds detail dynamically.
        toOption(entry.detail),
      );
    case "measure":
      return $performanceEntry.PerformanceEntry$MeasureEntry(
        name,
        startTime,
        duration,
        // @ts-expect-error PerformanceMeasure adds detail dynamically.
        toOption(entry.detail),
      );
    default:
      return $performanceEntry.PerformanceEntry$OtherEntry(
        name,
        startTime,
        duration,
        kind_from_name(entry.entryType),
        entry,
      );
  }
}
