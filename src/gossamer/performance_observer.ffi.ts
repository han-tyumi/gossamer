import * as $performanceObserver from "$/gossamer/gossamer/performance_observer.mjs";
import { fromArrayMapped, toArray } from "~/utils/list.ffi.ts";

function toEntryTypeString(entryType: $performanceObserver.EntryType$): string {
  if ($performanceObserver.EntryType$isMark(entryType)) return "mark";
  if ($performanceObserver.EntryType$isMeasure(entryType)) return "measure";
  if ($performanceObserver.EntryType$isResource(entryType)) return "resource";
  if ($performanceObserver.EntryType$isNavigation(entryType)) {
    return "navigation";
  }
  if ($performanceObserver.EntryType$isPaint(entryType)) return "paint";
  if ($performanceObserver.EntryType$isLongTask(entryType)) return "longtask";
  if ($performanceObserver.EntryType$isEvent(entryType)) return "event";
  if ($performanceObserver.EntryType$isFirstInput(entryType)) {
    return "first-input";
  }
  if ($performanceObserver.EntryType$isLargestContentfulPaint(entryType)) {
    return "largest-contentful-paint";
  }
  if ($performanceObserver.EntryType$isLayoutShift(entryType)) {
    return "layout-shift";
  }
  if ($performanceObserver.EntryType$isTaskAttribution(entryType)) {
    return "taskattribution";
  }
  if ($performanceObserver.EntryType$isVisibilityState(entryType)) {
    return "visibility-state";
  }
  if ($performanceObserver.EntryType$isElement(entryType)) return "element";
  if ($performanceObserver.EntryType$isBackForwardCacheRestoration(entryType)) {
    return "back-forward-cache-restoration";
  }
  if ($performanceObserver.EntryType$isDns(entryType)) return "dns";
  if ($performanceObserver.EntryType$isFunction(entryType)) return "function";
  if ($performanceObserver.EntryType$isGc(entryType)) return "gc";
  if ($performanceObserver.EntryType$isHttp(entryType)) return "http";
  if ($performanceObserver.EntryType$isHttp2(entryType)) return "http2";
  if ($performanceObserver.EntryType$isNet(entryType)) return "net";
  return $performanceObserver.EntryType$Other$0(entryType);
}

function fromEntryTypeString(
  value: string,
): $performanceObserver.EntryType$ {
  switch (value) {
    case "mark":
      return $performanceObserver.EntryType$Mark();
    case "measure":
      return $performanceObserver.EntryType$Measure();
    case "resource":
      return $performanceObserver.EntryType$Resource();
    case "navigation":
      return $performanceObserver.EntryType$Navigation();
    case "paint":
      return $performanceObserver.EntryType$Paint();
    case "longtask":
      return $performanceObserver.EntryType$LongTask();
    case "event":
      return $performanceObserver.EntryType$Event();
    case "first-input":
      return $performanceObserver.EntryType$FirstInput();
    case "largest-contentful-paint":
      return $performanceObserver.EntryType$LargestContentfulPaint();
    case "layout-shift":
      return $performanceObserver.EntryType$LayoutShift();
    case "taskattribution":
      return $performanceObserver.EntryType$TaskAttribution();
    case "visibility-state":
      return $performanceObserver.EntryType$VisibilityState();
    case "element":
      return $performanceObserver.EntryType$Element();
    case "back-forward-cache-restoration":
      return $performanceObserver.EntryType$BackForwardCacheRestoration();
    case "dns":
      return $performanceObserver.EntryType$Dns();
    case "function":
      return $performanceObserver.EntryType$Function();
    case "gc":
      return $performanceObserver.EntryType$Gc();
    case "http":
      return $performanceObserver.EntryType$Http();
    case "http2":
      return $performanceObserver.EntryType$Http2();
    case "net":
      return $performanceObserver.EntryType$Net();
    default:
      return $performanceObserver.EntryType$Other(value);
  }
}

export const observe: typeof $performanceObserver.observe = (
  entryTypes,
  handler,
) => {
  const observer = new PerformanceObserver((list) => {
    handler(fromArrayMapped(list.getEntries(), (e) => e));
  });
  // @ts-expect-error TS narrows entryTypes to a literal union.
  observer.observe({ entryTypes: toArray(entryTypes).map(toEntryTypeString) });
  return observer;
};

export const observe_buffered: typeof $performanceObserver.observe_buffered = (
  entryType,
  handler,
) => {
  const observer = new PerformanceObserver((list) => {
    handler(fromArrayMapped(list.getEntries(), (e) => e));
  });
  // @ts-expect-error TS narrows type to a literal union.
  observer.observe({ type: toEntryTypeString(entryType), buffered: true });
  return observer;
};

export const disconnect: typeof $performanceObserver.disconnect = (
  observer,
) => {
  observer.disconnect();
};

export const take_records: typeof $performanceObserver.take_records = (
  observer,
) => {
  return fromArrayMapped(observer.takeRecords(), (e) => e);
};

export const supported_entry_types:
  typeof $performanceObserver.supported_entry_types = () => {
    return fromArrayMapped(
      [...PerformanceObserver.supportedEntryTypes],
      fromEntryTypeString,
    );
  };
