import * as $readableStream from "$/gossamer/gossamer/stream/readable_stream.mjs";
import * as $stream from "$/gossamer/gossamer/stream.mjs";
import { BitArray$BitArray, Result$Error, Result$Ok } from "$/prelude.mjs";
import { fromBitArrayReadable } from "~/utils/bit_array.ffi.ts";
import { setIfSome } from "~/utils/option.ffi.ts";

function lockedError() {
  return Result$Error($stream.StreamLifecycleError$Locked());
}

function erroredError(reason: unknown) {
  return Result$Error($stream.StreamLifecycleError$Errored(reason));
}

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
  const source: UnderlyingDefaultSource = {};
  setIfSome(source, "start", $readableStream.Builder$Builder$start(builder));
  setIfSome(source, "pull", $readableStream.Builder$Builder$pull(builder));
  setIfSome(source, "cancel", $readableStream.Builder$Builder$cancel(builder));
  try {
    return Result$Ok(new ReadableStream(source));
  } catch (err) {
    return erroredError(err);
  }
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
  return stream.cancel(reason).then(
    () => Result$Ok(undefined),
    (err) => erroredError(err),
  );
};

export const get_reader: typeof $readableStream.get_reader = (
  stream: ReadableStream,
) => {
  if (stream.locked) return lockedError();
  try {
    return Result$Ok(stream.getReader());
  } catch (err) {
    return erroredError(err);
  }
};

export const pipe_through: typeof $readableStream.pipe_through = (
  stream: ReadableStream,
  [readable, writable]: [ReadableStream, WritableStream],
  options,
) => {
  if (stream.locked || writable.locked) return lockedError();
  try {
    return Result$Ok(
      stream.pipeThrough({ readable, writable }, fromPipeOptions(options)),
    );
  } catch (err) {
    return erroredError(err);
  }
};

export const pipe_to: typeof $readableStream.pipe_to = (
  stream: ReadableStream,
  destination: WritableStream,
  options,
) => {
  if (stream.locked || destination.locked) {
    return Promise.resolve(lockedError());
  }
  return stream.pipeTo(destination, fromPipeOptions(options)).then(
    () => Result$Ok(undefined),
    (err) => erroredError(err),
  );
};

export const tee: typeof $readableStream.tee = (stream: ReadableStream) => {
  if (stream.locked) return lockedError();
  try {
    return Result$Ok(stream.tee() as [ReadableStream, ReadableStream]);
  } catch (err) {
    return erroredError(err);
  }
};

export const async_iterator: typeof $readableStream.async_iterator = <T>(
  stream: ReadableStream<T>,
) => {
  return stream.values();
};

export const read_text: typeof $readableStream.read_text = async (stream) => {
  if (stream.locked) return lockedError();
  try {
    return Result$Ok(await new Response(fromBitArrayReadable(stream)).text());
  } catch (err) {
    return erroredError(err);
  }
};

export const read_bytes: typeof $readableStream.read_bytes = async (stream) => {
  if (stream.locked) return lockedError();
  try {
    const buffer = await new Response(fromBitArrayReadable(stream))
      .arrayBuffer();
    return Result$Ok(BitArray$BitArray(new Uint8Array(buffer)));
  } catch (err) {
    return erroredError(err);
  }
};
