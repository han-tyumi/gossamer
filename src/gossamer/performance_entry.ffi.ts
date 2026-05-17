import * as $performanceEntry from "$/gossamer/gossamer/performance_entry.mjs";
import { toOption } from "~/utils/option.ffi.ts";
import { msToDuration } from "~/utils/time.ffi.ts";

export function toEntryTypeString(
  entryType: $performanceEntry.EntryType$,
): string {
  if ($performanceEntry.EntryType$isMark(entryType)) return "mark";
  if ($performanceEntry.EntryType$isMeasure(entryType)) return "measure";
  if ($performanceEntry.EntryType$isResource(entryType)) return "resource";
  if ($performanceEntry.EntryType$isNavigation(entryType)) return "navigation";
  if ($performanceEntry.EntryType$isPaint(entryType)) return "paint";
  if ($performanceEntry.EntryType$isLongTask(entryType)) return "longtask";
  if ($performanceEntry.EntryType$isEvent(entryType)) return "event";
  if ($performanceEntry.EntryType$isFirstInput(entryType)) return "first-input";
  if ($performanceEntry.EntryType$isLargestContentfulPaint(entryType)) {
    return "largest-contentful-paint";
  }
  if ($performanceEntry.EntryType$isLayoutShift(entryType)) {
    return "layout-shift";
  }
  if ($performanceEntry.EntryType$isTaskAttribution(entryType)) {
    return "taskattribution";
  }
  if ($performanceEntry.EntryType$isVisibilityState(entryType)) {
    return "visibility-state";
  }
  if ($performanceEntry.EntryType$isElement(entryType)) return "element";
  if ($performanceEntry.EntryType$isBackForwardCacheRestoration(entryType)) {
    return "back-forward-cache-restoration";
  }
  if ($performanceEntry.EntryType$isDns(entryType)) return "dns";
  if ($performanceEntry.EntryType$isFunction(entryType)) return "function";
  if ($performanceEntry.EntryType$isGc(entryType)) return "gc";
  if ($performanceEntry.EntryType$isHttp(entryType)) return "http";
  if ($performanceEntry.EntryType$isHttp2(entryType)) return "http2";
  if ($performanceEntry.EntryType$isNet(entryType)) return "net";
  return $performanceEntry.EntryType$Other$0(entryType);
}

export function fromEntryTypeString(
  value: string,
): $performanceEntry.EntryType$ {
  switch (value) {
    case "mark":
      return $performanceEntry.EntryType$Mark();
    case "measure":
      return $performanceEntry.EntryType$Measure();
    case "resource":
      return $performanceEntry.EntryType$Resource();
    case "navigation":
      return $performanceEntry.EntryType$Navigation();
    case "paint":
      return $performanceEntry.EntryType$Paint();
    case "longtask":
      return $performanceEntry.EntryType$LongTask();
    case "event":
      return $performanceEntry.EntryType$Event();
    case "first-input":
      return $performanceEntry.EntryType$FirstInput();
    case "largest-contentful-paint":
      return $performanceEntry.EntryType$LargestContentfulPaint();
    case "layout-shift":
      return $performanceEntry.EntryType$LayoutShift();
    case "taskattribution":
      return $performanceEntry.EntryType$TaskAttribution();
    case "visibility-state":
      return $performanceEntry.EntryType$VisibilityState();
    case "element":
      return $performanceEntry.EntryType$Element();
    case "back-forward-cache-restoration":
      return $performanceEntry.EntryType$BackForwardCacheRestoration();
    case "dns":
      return $performanceEntry.EntryType$Dns();
    case "function":
      return $performanceEntry.EntryType$Function();
    case "gc":
      return $performanceEntry.EntryType$Gc();
    case "http":
      return $performanceEntry.EntryType$Http();
    case "http2":
      return $performanceEntry.EntryType$Http2();
    case "net":
      return $performanceEntry.EntryType$Net();
    default:
      return $performanceEntry.EntryType$Other(value);
  }
}

export const info: typeof $performanceEntry.info = (entry) => {
  return $performanceEntry.Info$Info(
    entry.name,
    fromEntryTypeString(entry.entryType),
    msToDuration(entry.startTime),
    msToDuration(entry.duration),
    toOption((entry as PerformanceMark).detail),
  );
};

export const to_json: typeof $performanceEntry.to_json = (entry) => {
  return entry.toJSON();
};
