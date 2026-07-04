import {
  kind_from_name,
  kind_to_name,
} from "$/gossamer/gossamer/performance_entry.mjs";
import * as $performanceObserver from "$/gossamer/gossamer/performance_observer.mjs";
import { project } from "~/gossamer/performance_entry.ffi.ts";
import { fromArrayMapped, toArray } from "~/utils/list.ffi.ts";

export const observe: typeof $performanceObserver.observe = (
  entryKinds,
  handler,
) => {
  const observer = new PerformanceObserver(
    // @ts-expect-error PerformanceObserverCallback in TS lib lacks the options arg.
    (list, _observer, options) => {
      handler(
        $performanceObserver.Batch$Batch(
          fromArrayMapped(list.getEntries(), project),
          options?.droppedEntriesCount ?? 0,
        ),
        observer,
      );
    },
  );
  observer.observe({
    entryTypes: toArray(entryKinds).map(kind_to_name),
  });
  return observer;
};

export const observe_buffered: typeof $performanceObserver.observe_buffered = (
  entryKind,
  handler,
) => {
  const observer = new PerformanceObserver(
    // @ts-expect-error PerformanceObserverCallback in TS lib lacks the options arg.
    (list, _observer, options) => {
      handler(
        $performanceObserver.Batch$Batch(
          fromArrayMapped(list.getEntries(), project),
          options?.droppedEntriesCount ?? 0,
        ),
        observer,
      );
    },
  );
  observer.observe({
    type: kind_to_name(entryKind),
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
  return fromArrayMapped(observer.takeRecords(), project);
};

export const supported_entry_types:
  typeof $performanceObserver.supported_entry_types = () => {
    return fromArrayMapped(
      [...PerformanceObserver.supportedEntryTypes],
      kind_from_name,
    );
  };
