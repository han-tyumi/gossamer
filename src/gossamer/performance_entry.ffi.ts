import * as $performanceEntry from "$/gossamer/gossamer/performance_entry.mjs";
import { toOption } from "~/utils/option.ffi.ts";
import { msToDuration } from "~/utils/time.ffi.ts";

export function kindFromString(value: string): $performanceEntry.Kind$ {
  switch (value) {
    case "mark":
      return $performanceEntry.Kind$Mark();
    case "measure":
      return $performanceEntry.Kind$Measure();
    case "resource":
      return $performanceEntry.Kind$Resource();
    case "navigation":
      return $performanceEntry.Kind$Navigation();
    case "paint":
      return $performanceEntry.Kind$Paint();
    case "longtask":
      return $performanceEntry.Kind$LongTask();
    case "event":
      return $performanceEntry.Kind$Event();
    case "first-input":
      return $performanceEntry.Kind$FirstInput();
    case "largest-contentful-paint":
      return $performanceEntry.Kind$LargestContentfulPaint();
    case "layout-shift":
      return $performanceEntry.Kind$LayoutShift();
    case "taskattribution":
      return $performanceEntry.Kind$TaskAttribution();
    case "visibility-state":
      return $performanceEntry.Kind$VisibilityState();
    case "element":
      return $performanceEntry.Kind$Element();
    case "back-forward-cache-restoration":
      return $performanceEntry.Kind$BackForwardCacheRestoration();
    case "dns":
      return $performanceEntry.Kind$Dns();
    case "function":
      return $performanceEntry.Kind$Function();
    case "gc":
      return $performanceEntry.Kind$Gc();
    case "http":
      return $performanceEntry.Kind$Http();
    case "http2":
      return $performanceEntry.Kind$Http2();
    case "net":
      return $performanceEntry.Kind$Net();
    default:
      return $performanceEntry.Kind$Other(value);
  }
}

export function kindToString(kind: $performanceEntry.Kind$): string {
  if ($performanceEntry.Kind$isMark(kind)) return "mark";
  if ($performanceEntry.Kind$isMeasure(kind)) return "measure";
  if ($performanceEntry.Kind$isResource(kind)) return "resource";
  if ($performanceEntry.Kind$isNavigation(kind)) return "navigation";
  if ($performanceEntry.Kind$isPaint(kind)) return "paint";
  if ($performanceEntry.Kind$isLongTask(kind)) return "longtask";
  if ($performanceEntry.Kind$isEvent(kind)) return "event";
  if ($performanceEntry.Kind$isFirstInput(kind)) return "first-input";
  if ($performanceEntry.Kind$isLargestContentfulPaint(kind)) {
    return "largest-contentful-paint";
  }
  if ($performanceEntry.Kind$isLayoutShift(kind)) return "layout-shift";
  if ($performanceEntry.Kind$isTaskAttribution(kind)) return "taskattribution";
  if ($performanceEntry.Kind$isVisibilityState(kind)) return "visibility-state";
  if ($performanceEntry.Kind$isElement(kind)) return "element";
  if ($performanceEntry.Kind$isBackForwardCacheRestoration(kind)) {
    return "back-forward-cache-restoration";
  }
  if ($performanceEntry.Kind$isDns(kind)) return "dns";
  if ($performanceEntry.Kind$isFunction(kind)) return "function";
  if ($performanceEntry.Kind$isGc(kind)) return "gc";
  if ($performanceEntry.Kind$isHttp(kind)) return "http";
  if ($performanceEntry.Kind$isHttp2(kind)) return "http2";
  if ($performanceEntry.Kind$isNet(kind)) return "net";
  return $performanceEntry.Kind$Other$0(kind);
}

export function project(
  entry: PerformanceEntry,
): $performanceEntry.PerformanceEntry$ {
  return $performanceEntry.PerformanceEntry$PerformanceEntry(
    kindFromString(entry.entryType),
    entry.name,
    msToDuration(entry.startTime),
    msToDuration(entry.duration),
    // @ts-expect-error detail is defined on Mark/Measure/Gc subclasses only.
    toOption(entry.detail),
    entry,
  );
}
