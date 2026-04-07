import type * as $writer from "$/gossamer/gossamer/writable_stream/writer.mjs";
import { toResult } from "~/utils/result.ts";

export type Writer$<T> = WritableStreamDefaultWriter<T>;

export const closed: typeof $writer.closed = (
  writer: WritableStreamDefaultWriter,
) => {
  return writer.closed.then(() => undefined);
};

export const desired_size: typeof $writer.desired_size = (
  writer: WritableStreamDefaultWriter,
) => {
  return toResult(writer.desiredSize);
};

export const ready: typeof $writer.ready = (
  writer: WritableStreamDefaultWriter,
) => {
  return writer.ready.then(() => undefined);
};

export const abort: typeof $writer.abort = (
  writer: WritableStreamDefaultWriter,
  reason,
) => {
  return writer.abort(reason).then(() => undefined);
};

export const close: typeof $writer.close = (
  writer: WritableStreamDefaultWriter,
) => {
  return writer.close().then(() => undefined);
};

export const release_lock: typeof $writer.release_lock = (
  writer: WritableStreamDefaultWriter,
) => {
  writer.releaseLock();
  return writer;
};

export const write: typeof $writer.write = <W>(
  writer: WritableStreamDefaultWriter<W>,
  chunk: W,
) => {
  return writer.write(chunk).then(() => undefined);
};
