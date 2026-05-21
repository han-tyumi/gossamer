import { kind_to_name } from "$/gossamer/gossamer/performance_entry.mjs";
import type * as $performance from "$/gossamer/gossamer/performance.mjs";
import { project } from "~/gossamer/performance_entry.ffi.ts";
import { fromArrayMapped } from "~/utils/list.ffi.ts";
import { msToDuration, msToTimestamp } from "~/utils/time.ffi.ts";

export const now: typeof $performance.now = () => {
  return msToDuration(performance.now());
};

export const time_origin: typeof $performance.time_origin = () => {
  return msToTimestamp(performance.timeOrigin);
};

export const clear_marks: typeof $performance.clear_marks = () => {
  performance.clearMarks();
};

export const clear_mark: typeof $performance.clear_mark = (name) => {
  performance.clearMarks(name);
};

export const clear_measures: typeof $performance.clear_measures = () => {
  performance.clearMeasures();
};

export const clear_measure: typeof $performance.clear_measure = (name) => {
  performance.clearMeasures(name);
};

export const entries: typeof $performance.entries = () => {
  return fromArrayMapped(performance.getEntries(), project);
};

export const entries_by_name: typeof $performance.entries_by_name = (name) => {
  return fromArrayMapped(performance.getEntriesByName(name), project);
};

export const entries_by_kind: typeof $performance.entries_by_kind = (kind) => {
  return fromArrayMapped(
    performance.getEntriesByType(kind_to_name(kind)),
    project,
  );
};
