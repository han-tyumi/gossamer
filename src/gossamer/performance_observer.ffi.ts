import type * as $performanceObserver from "$/gossamer/gossamer/performance_observer.mjs";
import { fromArray, toArray } from "~/utils/list.ffi.ts";

export const observe: typeof $performanceObserver.observe = (
  entryTypes,
  handler,
) => {
  const observer = new PerformanceObserver((list) => {
    handler(fromArray(list.getEntries()));
  });
  // @ts-expect-error TS narrows EntryType to a literal union.
  observer.observe({ entryTypes: toArray(entryTypes) });
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
  return fromArray(observer.takeRecords());
};

export const supported_entry_types:
  typeof $performanceObserver.supported_entry_types = () => {
    return fromArray([...PerformanceObserver.supportedEntryTypes]);
  };
