import type * as $performance from "$/gossamer/gossamer/performance.mjs";
import { fromArray } from "~/utils/list.ffi.ts";
import { toResult } from "~/utils/result.ffi.ts";

export const now: typeof $performance.now = () => {
  return performance.now();
};

export const time_origin: typeof $performance.time_origin = () => {
  return performance.timeOrigin;
};

export const mark: typeof $performance.mark = (name) => {
  return toResult.fromThrows(() => performance.mark(name));
};

export const measure: typeof $performance.measure = (
  name,
  startMark,
  endMark,
) => {
  return toResult.fromThrows(() =>
    performance.measure(name, startMark, endMark)
  );
};

export const clear_marks: typeof $performance.clear_marks = () => {
  performance.clearMarks();
};

export const clear_measures: typeof $performance.clear_measures = () => {
  performance.clearMeasures();
};

export const get_entries: typeof $performance.get_entries = () => {
  return fromArray(performance.getEntries());
};

export const get_entries_by_name: typeof $performance.get_entries_by_name = (
  name,
) => {
  return fromArray(performance.getEntriesByName(name));
};

export const get_entries_by_type: typeof $performance.get_entries_by_type = (
  entryType,
) => {
  return fromArray(performance.getEntriesByType(entryType));
};

export const to_json: typeof $performance.to_json = () => {
  return performance.toJSON();
};
