import * as $readableStream from "$/gossamer/gossamer/readable_stream.mjs";
import type { List } from "$/prelude.mjs";
import { toArray } from "~/utils/list.ffi.ts";
import { toResult } from "~/utils/result.ffi.ts";

export type ReadableStream$<T> = ReadableStream<T>;

function toUnderlyingSource<T>(
  options: $readableStream.UnderlyingSource$<T>[],
): UnderlyingDefaultSource<T> {
  const result: UnderlyingDefaultSource<T> = {};
  for (const option of options) {
    if ($readableStream.UnderlyingSource$isStart(option)) {
      result.start = $readableStream.UnderlyingSource$Start$0(option);
    } else if ($readableStream.UnderlyingSource$isPull(option)) {
      result.pull = $readableStream.UnderlyingSource$Pull$0(option);
    } else if ($readableStream.UnderlyingSource$isCancel(option)) {
      result.cancel = $readableStream.UnderlyingSource$Cancel$0(option);
    }
  }
  return result;
}

function toStreamPipeOptions(
  options: List<$readableStream.StreamPipeOption$>,
): Partial<StreamPipeOptions> {
  const result: Partial<StreamPipeOptions> = {};
  for (const option of toArray(options)) {
    if ($readableStream.StreamPipeOption$isPreventAbort(option)) {
      result.preventAbort = true;
    } else if ($readableStream.StreamPipeOption$isPreventCancel(option)) {
      result.preventCancel = true;
    } else if ($readableStream.StreamPipeOption$isPreventClose(option)) {
      result.preventClose = true;
    } else if ($readableStream.StreamPipeOption$isSignal(option)) {
      result.signal = $readableStream.StreamPipeOption$Signal$0(option);
    }
  }
  return result;
}

export const new_: typeof $readableStream.new$ = (source) => {
  return toResult.fromThrows(() =>
    new ReadableStream(toUnderlyingSource(toArray(source)))
  );
};

export const from_iterator: typeof $readableStream.from_iterator = (
  iterator,
) => {
  return ReadableStream.from(iterator);
};

export const from_async_iterator: typeof $readableStream.from_async_iterator = (
  iterator,
) => {
  return ReadableStream.from(iterator);
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
  return toResult.fromPromise(stream.cancel(reason).then(() => undefined));
};

export const get_reader: typeof $readableStream.get_reader = (
  stream: ReadableStream,
) => {
  return toResult.fromThrows(() => stream.getReader());
};

export const get_byob_reader: typeof $readableStream.get_byob_reader = (
  stream: ReadableStream,
) => {
  return toResult.fromThrows(() => stream.getReader({ mode: "byob" }));
};

export const pipe_through: typeof $readableStream.pipe_through = (
  stream: ReadableStream,
  [readable, writable]: [ReadableStream, WritableStream],
  options,
) => {
  return toResult.fromThrows(() =>
    stream.pipeThrough(
      { readable, writable },
      toStreamPipeOptions(options),
    )
  );
};

export const pipe_to: typeof $readableStream.pipe_to = (
  stream: ReadableStream,
  destination: WritableStream,
  options,
) => {
  return toResult.fromPromise(
    stream.pipeTo(
      destination,
      toStreamPipeOptions(options),
    ).then(() => undefined),
  );
};

export const tee: typeof $readableStream.tee = (
  stream: ReadableStream,
) => {
  return toResult.fromThrows(() => stream.tee());
};

export const async_iterator: typeof $readableStream.async_iterator = <T>(
  stream: ReadableStream<T>,
) => {
  return stream.values();
};
