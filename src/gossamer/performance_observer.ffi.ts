import type * as $performanceObserver from "$/gossamer/gossamer/performance_observer.mjs";
import {
  fromEntryTypeString,
  toEntryTypeString,
} from "~/gossamer/performance_entry.ffi.ts";
import { fromArray, fromArrayMapped, toArray } from "~/utils/list.ffi.ts";

export const observe: typeof $performanceObserver.observe = (
  entryTypes,
  handler,
) => {
  const observer = new PerformanceObserver((list) => {
    handler(fromArray(list.getEntries()), observer);
  });
  observer.observe({
    // @ts-expect-error TS narrows entryTypes to a literal union.
    entryTypes: toArray(entryTypes).map(toEntryTypeString),
  });
  return observer;
};

export const observe_buffered: typeof $performanceObserver.observe_buffered = (
  entryType,
  handler,
) => {
  const observer = new PerformanceObserver((list) => {
    handler(fromArray(list.getEntries()), observer);
  });
  observer.observe({
    // @ts-expect-error TS narrows type to a literal union.
    type: toEntryTypeString(entryType),
    buffered: true,
  });
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
    return fromArrayMapped(
      [...PerformanceObserver.supportedEntryTypes],
      fromEntryTypeString,
    );
  };
