import * as $readableStream from "$/gossamer/gossamer/readable_stream.mjs";
import {
  fromBitArrayReadable,
  toBitArrayResult,
} from "~/utils/bit_array.ffi.ts";
import { setIfSome } from "~/utils/option.ffi.ts";
import { toResult } from "~/utils/result.ffi.ts";

function fromPipeOptions(
  options: $readableStream.PipeOptions$,
): StreamPipeOptions {
  const result: StreamPipeOptions = {
    preventAbort: $readableStream.PipeOptions$PipeOptions$prevent_abort(
      options,
    ),
    preventCancel: $readableStream.PipeOptions$PipeOptions$prevent_cancel(
      options,
    ),
    preventClose: $readableStream.PipeOptions$PipeOptions$prevent_close(
      options,
    ),
  };
  setIfSome(
    result,
    "signal",
    $readableStream.PipeOptions$PipeOptions$signal(options),
  );
  return result;
}

export const build: typeof $readableStream.build = (builder) => {
  return toResult.fromThrows(() => {
    const source: UnderlyingDefaultSource = {};
    setIfSome(
      source,
      "start",
      $readableStream.Builder$Builder$start(builder),
    );
    setIfSome(
      source,
      "pull",
      $readableStream.Builder$Builder$pull(builder),
    );
    setIfSome(
      source,
      "cancel",
      $readableStream.Builder$Builder$cancel(builder),
    );
    return new ReadableStream(source);
  });
};

export const from_pull: typeof $readableStream.from_pull = (pull) => {
  return new ReadableStream({ pull });
};

export const from_iterator: typeof $readableStream.from_iterator = (
  iterator,
) => {
  if (typeof ReadableStream.from !== "function") {
    throw new Error(
      "readable_stream.from_iterator is unavailable on Bun - see https://github.com/oven-sh/bun/issues/3700",
    );
  }
  return ReadableStream.from(iterator);
};

export const from_async_iterator: typeof $readableStream.from_async_iterator = (
  iterator,
) => {
  if (typeof ReadableStream.from !== "function") {
    throw new Error(
      "readable_stream.from_async_iterator is unavailable on Bun - see https://github.com/oven-sh/bun/issues/3700",
    );
  }
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

export const pipe_through: typeof $readableStream.pipe_through = (
  stream: ReadableStream,
  [readable, writable]: [ReadableStream, WritableStream],
  options,
) => {
  return toResult.fromThrows(() =>
    stream.pipeThrough(
      { readable, writable },
      fromPipeOptions(options),
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
      fromPipeOptions(options),
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

export const read_text: typeof $readableStream.read_text = (stream) => {
  return toResult.fromAsync(() =>
    new Response(fromBitArrayReadable(stream)).text()
  );
};

export const read_bytes: typeof $readableStream.read_bytes = (stream) => {
  return toBitArrayResult(() =>
    new Response(fromBitArrayReadable(stream)).arrayBuffer()
  );
};
