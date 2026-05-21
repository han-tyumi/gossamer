import * as $mark from "$/gossamer/gossamer/performance/mark.mjs";
import { fromArrayMapped } from "~/utils/list.ffi.ts";
import { setIfSome, toOption } from "~/utils/option.ffi.ts";
import { durationToMs, msToDuration } from "~/utils/time.ffi.ts";

function projectMark(entry: PerformanceEntry): $mark.Mark$ {
  return $mark.Mark$Mark(
    entry.name,
    msToDuration(entry.startTime),
    // @ts-expect-error PerformanceMark adds detail.
    toOption(entry.detail),
  );
}

export const record: typeof $mark.do_record = (name, startTime, detail) => {
  const options: PerformanceMarkOptions = {
    startTime: Math.max(0, durationToMs(startTime)),
  };
  setIfSome(options, "detail", detail);
  performance.mark(name, options);
};

export const entries: typeof $mark.entries = () => {
  return fromArrayMapped(performance.getEntriesByType("mark"), projectMark);
};

export const entries_by_name: typeof $mark.entries_by_name = (name) => {
  return fromArrayMapped(
    performance.getEntriesByName(name, "mark"),
    projectMark,
  );
};
