import type * as $writableStream from "$/gossamer/gossamer/writable_stream.mjs";
import { toUnderlyingSink } from "~/gossamer/writable_stream/underlying_sink.ts";
import { toArray } from "~/utils/list.ts";

export type WritableStream$<T> = WritableStream<T>;

export const new_: typeof $writableStream.new$ = (sink) => {
  return new WritableStream(toUnderlyingSink(toArray(sink)));
};

export const locked: typeof $writableStream.locked = (
  stream: WritableStream,
) => {
  return stream.locked;
};

export const abort: typeof $writableStream.abort = (
  stream: WritableStream,
  reason,
) => {
  return stream.abort(reason).then(() => undefined);
};

export const close: typeof $writableStream.close = (
  stream: WritableStream,
) => {
  return stream.close().then(() => undefined);
};

export const get_writer: typeof $writableStream.get_writer = (
  stream: WritableStream,
) => {
  return stream.getWriter();
};
