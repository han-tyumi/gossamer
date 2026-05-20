import type * as $performance from "$/gossamer/gossamer/performance.mjs";
import { Result$Error, Result$Ok } from "$/prelude.mjs";
import { kindToString, project } from "~/gossamer/performance_entry.ffi.ts";
import { fromArrayMapped } from "~/utils/list.ffi.ts";
import { msToDuration, msToTimestamp } from "~/utils/time.ffi.ts";

export const now: typeof $performance.now = () => {
  return msToDuration(performance.now());
};

export const time_origin: typeof $performance.time_origin = () => {
  return msToTimestamp(performance.timeOrigin);
};

export const mark: typeof $performance.mark = (name) => {
  return project(performance.mark(name));
};

export const measure: typeof $performance.measure = (
  name,
  startMark,
  endMark,
) => {
  try {
    return Result$Ok(project(performance.measure(name, startMark, endMark)));
  } catch {
    return Result$Error(undefined);
  }
};

export const clear_marks: typeof $performance.clear_marks = () => {
  performance.clearMarks();
};

export const clear_measures: typeof $performance.clear_measures = () => {
  performance.clearMeasures();
};

export const entries: typeof $performance.entries = () => {
  return fromArrayMapped(performance.getEntries(), project);
};

export const entries_by_name: typeof $performance.entries_by_name = (
  name,
) => {
  return fromArrayMapped(performance.getEntriesByName(name), project);
};

export const entries_by_kind: typeof $performance.entries_by_kind = (
  kind,
) => {
  return fromArrayMapped(
    performance.getEntriesByType(kindToString(kind)),
    project,
  );
};
