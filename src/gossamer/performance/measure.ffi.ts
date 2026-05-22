import * as $measure from "$/gossamer/gossamer/performance/measure.mjs";
import { Option$None } from "$/gleam_stdlib/gleam/option.mjs";
import { fromArrayMapped } from "~/utils/list.ffi.ts";
import { setIfSome, toOption } from "~/utils/option.ffi.ts";
import { durationToMs, msToDuration } from "~/utils/time.ffi.ts";

function projectMeasure(entry: PerformanceEntry): $measure.Measure$ {
  return $measure.Measure$Measure(
    entry.name,
    msToDuration(entry.startTime),
    msToDuration(entry.duration),
    // @ts-expect-error PerformanceMeasure adds detail.
    toOption(entry.detail),
  );
}

export const from_raw: typeof $measure.do_from_raw = (raw) => {
  return projectMeasure(raw as PerformanceEntry);
};

export const between: typeof $measure.between = (name, from, to) => {
  const startMs = Math.max(0, durationToMs(from));
  const endMs = Math.max(0, durationToMs(to));
  return $measure.Measure$Measure(
    name,
    msToDuration(startMs),
    msToDuration(Math.max(0, endMs - startMs)),
    Option$None(),
  );
};

export const record: typeof $measure.do_record = (
  name,
  startTime,
  duration,
  detail,
) => {
  const options: PerformanceMeasureOptions = {
    start: Math.max(0, durationToMs(startTime)),
    duration: durationToMs(duration),
  };
  setIfSome(options, "detail", detail);
  performance.measure(name, options);
};

export const entries: typeof $measure.entries = () => {
  return fromArrayMapped(
    performance.getEntriesByType("measure"),
    projectMeasure,
  );
};

export const entries_by_name: typeof $measure.entries_by_name = (name) => {
  return fromArrayMapped(
    performance.getEntriesByName(name, "measure"),
    projectMeasure,
  );
};
