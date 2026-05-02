import * as $performanceEntry from "$/gossamer/gossamer/performance_entry.mjs";
import { toResult } from "~/utils/result.ffi.ts";

export const to_fields: typeof $performanceEntry.to_fields = (entry) => {
  return $performanceEntry.Fields$Fields(
    entry.name,
    entry.entryType,
    entry.startTime,
    entry.duration,
  );
};

export const name: typeof $performanceEntry.name = (entry) => {
  return entry.name;
};

export const entry_type: typeof $performanceEntry.entry_type = (entry) => {
  return entry.entryType;
};

export const start_time: typeof $performanceEntry.start_time = (entry) => {
  return entry.startTime;
};

export const duration: typeof $performanceEntry.duration = (entry) => {
  return entry.duration;
};

export const detail: typeof $performanceEntry.detail = (entry) => {
  return toResult((entry as PerformanceMark).detail);
};

export const to_json: typeof $performanceEntry.to_json = (entry) => {
  return entry.toJSON();
};
