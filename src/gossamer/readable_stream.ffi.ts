import type * as $readableStream from "$/gossamer/gossamer/readable_stream.mjs";
import { toStreamPipeOptions } from "~/gossamer/readable_stream/stream_pipe_option.ts";
import { toUnderlyingSource } from "~/gossamer/readable_stream/underlying_source.ts";
import { toArray } from "~/utils/list.ts";

export type ReadableStream$<T> = ReadableStream<T>;

export const new_: typeof $readableStream.new$ = (source) => {
  return new ReadableStream(toUnderlyingSource(toArray(source)));
};

export const from: typeof $readableStream.from = (iterable) => {
  return ReadableStream.from(iterable);
};

export const is_locked: typeof $readableStream.is_locked = (
  stream: ReadableStream,
) => {
  return stream.locked;
};

export const cancel: typeof $readableStream.cancel = (
  stream: ReadableStream,
  reason,
) => {
  return stream.cancel(reason).then(() => undefined);
};

export const get_reader: typeof $readableStream.get_reader = (
  stream: ReadableStream,
) => {
  return stream.getReader();
};

export const get_byob_reader: typeof $readableStream.get_byob_reader = (
  stream: ReadableStream,
) => {
  return stream.getReader({ mode: "byob" });
};

export const pipe_through: typeof $readableStream.pipe_through = (
  stream: ReadableStream,
  [readable, writable]: [ReadableStream, WritableStream],
  options,
) => {
  return stream.pipeThrough(
    { readable, writable },
    toStreamPipeOptions(options),
  );
};

export const pipe_to: typeof $readableStream.pipe_to = (
  stream: ReadableStream,
  destination: WritableStream,
  options,
) => {
  return stream.pipeTo(
    destination,
    toStreamPipeOptions(options),
  ).then(() => undefined);
};

export const tee: typeof $readableStream.tee = (
  stream: ReadableStream,
) => {
  return stream.tee();
};

export const async_iterator: typeof $readableStream.async_iterator = <T>(
  stream: ReadableStream<T>,
) => {
  return stream.values();
};
