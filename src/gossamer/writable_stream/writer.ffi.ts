import type * as $writer from "$/gossamer/gossamer/writable_stream/writer.mjs";
import { toResult } from "~/utils/result.ffi.ts";

export type Writer$<T> = WritableStreamDefaultWriter<T>;

export const closed: typeof $writer.closed = (
  writer: WritableStreamDefaultWriter,
) => {
  return toResult.fromPromise(writer.closed.then(() => undefined));
};

export const desired_size: typeof $writer.desired_size = (
  writer: WritableStreamDefaultWriter,
) => {
  return toResult(writer.desiredSize);
};

export const ready: typeof $writer.ready = (
  writer: WritableStreamDefaultWriter,
) => {
  return toResult.fromPromise(writer.ready.then(() => undefined));
};

export const abort: typeof $writer.abort = (
  writer: WritableStreamDefaultWriter,
  reason,
) => {
  return toResult.fromPromise(writer.abort(reason).then(() => undefined));
};

export const close: typeof $writer.close = (
  writer: WritableStreamDefaultWriter,
) => {
  return toResult.fromPromise(writer.close().then(() => undefined));
};

export const release_lock: typeof $writer.release_lock = (
  writer: WritableStreamDefaultWriter,
) => {
  return toResult.fromThrows(() => {
    writer.releaseLock();
    return writer;
  });
};

export const write: typeof $writer.write = <W>(
  writer: WritableStreamDefaultWriter<W>,
  chunk: W,
) => {
  return toResult.fromPromise(writer.write(chunk).then(() => undefined));
};
