import * as $performanceEntry from "$/gossamer/gossamer/performance_entry.mjs";
import { kind_from_name } from "$/gossamer/gossamer/performance_entry.mjs";
import { fromArray, fromArrayMapped } from "~/utils/list.ffi.ts";
import { toOption } from "~/utils/option.ffi.ts";
import { msToDuration } from "~/utils/time.ffi.ts";

interface ServerTimingShape {
  name: string;
  duration: number;
  description: string;
}

function projectServerTiming(
  st: ServerTimingShape,
): $performanceEntry.ServerTiming$ {
  return $performanceEntry.ServerTiming$ServerTiming(
    st.name,
    msToDuration(st.duration),
    st.description,
  );
}

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
    case "resource": {
      // @ts-expect-error narrowing to PerformanceResourceTiming.
      const r: PerformanceResourceTiming = entry;
      return $performanceEntry.PerformanceEntry$ResourceEntry(
        name,
        startTime,
        duration,
        r.initiatorType,
        toOption(r.nextHopProtocol),
        msToDuration(r.workerStart),
        msToDuration(r.redirectStart),
        msToDuration(r.redirectEnd),
        msToDuration(r.fetchStart),
        msToDuration(r.domainLookupStart),
        msToDuration(r.domainLookupEnd),
        msToDuration(r.connectStart),
        msToDuration(r.connectEnd),
        msToDuration(r.secureConnectionStart),
        msToDuration(r.requestStart),
        msToDuration(r.responseStart),
        msToDuration(r.responseEnd),
        r.transferSize,
        r.encodedBodySize,
        r.decodedBodySize,
        r.responseStatus,
        r.contentType ?? "",
        r.deliveryType ?? "",
        r.renderBlockingStatus ?? "",
        msToDuration(r.firstInterimResponseStart ?? 0),
        msToDuration(r.finalResponseHeadersStart ?? 0),
        r.serverTiming
          ? fromArrayMapped([...r.serverTiming], projectServerTiming)
          : fromArray([]),
      );
    }
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
