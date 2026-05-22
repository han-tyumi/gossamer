import * as $performanceEntry from "$/gossamer/gossamer/performance_entry.mjs";
import { kind_from_name } from "$/gossamer/gossamer/performance_entry.mjs";
import { msToDuration } from "~/utils/time.ffi.ts";

export function project(
  entry: PerformanceEntry,
): $performanceEntry.PerformanceEntry$ {
  return $performanceEntry.PerformanceEntry$PerformanceEntry(
    entry.name,
    msToDuration(entry.startTime),
    msToDuration(entry.duration),
    kind_from_name(entry.entryType),
    entry,
  );
}
