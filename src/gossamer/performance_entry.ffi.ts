import * as $performanceEntry from "$/gossamer/gossamer/performance_entry.mjs";
import { toResult } from "~/utils/result.ffi.ts";

export type PerformanceEntryRef$ = PerformanceEntry;

export function toPerformanceEntry(
  entry: PerformanceEntry,
): $performanceEntry.PerformanceEntry$ {
  return $performanceEntry.PerformanceEntry$PerformanceEntry(
    entry.name,
    entry.entryType,
    entry.startTime,
    entry.duration,
    entry,
  );
}

function ref(
  entry: $performanceEntry.PerformanceEntry$,
): PerformanceEntry {
  return $performanceEntry.PerformanceEntry$PerformanceEntry$ref(entry);
}

export const detail: typeof $performanceEntry.detail = (entry) => {
  return toResult((ref(entry) as PerformanceMark).detail);
};

export const to_json: typeof $performanceEntry.to_json = (entry) => {
  return ref(entry).toJSON();
};
