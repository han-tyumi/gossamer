import type * as $reader from "$/gossamer/gossamer/readable_stream/reader.mjs";
import { toReadResult } from "~/gossamer/readable_stream/read_result.ts";
import { toResult } from "~/utils/result.ts";

export type Reader$<T> = ReadableStreamDefaultReader<T>;

export const closed: typeof $reader.closed = (
  reader: ReadableStreamDefaultReader,
) => {
  return toResult.fromPromise(reader.closed.then(() => undefined));
};

export const cancel: typeof $reader.cancel = (
  reader: ReadableStreamDefaultReader,
  reason,
) => {
  return toResult.fromPromise(reader.cancel(reason).then(() => undefined));
};

export const read: typeof $reader.read = (
  reader: ReadableStreamDefaultReader,
) => {
  return toResult.fromPromise(
    reader.read().then((result) => toReadResult(result)),
  );
};

export const release_lock: typeof $reader.release_lock = (
  reader: ReadableStreamDefaultReader,
) => {
  return toResult.fromThrows(() => {
    reader.releaseLock();
    return reader;
  });
};
