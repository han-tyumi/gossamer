import * as $readableStream from "$/gossamer/gossamer/stream/readable_stream.mjs";
import * as $option from "$/gleam_stdlib/gleam/option.mjs";
import * as $stream from "$/gossamer/gossamer/stream.mjs";
import { BitArray$BitArray, Result$Error, Result$Ok } from "$/prelude.mjs";
import {
  asyncYielderAsJsAsyncIterator,
  jsAsyncIteratorAsAsyncYielder,
  yielderAsJsIterator,
} from "~/utils/iteration.ffi.ts";
import { fromBitArrayReadable } from "~/utils/bit_array.ffi.ts";
import { setIfSome } from "~/utils/option.ffi.ts";
import { fromQueuingStrategy } from "~/utils/queuing_strategy.ffi.ts";
import { ensureMethod } from "~/utils/runtime_gap.ffi.ts";

const BUN_STREAM_FROM_ISSUE = "https://github.com/oven-sh/bun/issues/3700";

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

export const build: typeof $readableStream.do_build = (
  start,
  pull,
  cancel,
  queuing_strategy,
) => {
  const source: UnderlyingDefaultSource = {};
  setIfSome(source, "start", start);
  setIfSome(source, "pull", pull);
  setIfSome(source, "cancel", cancel);
  const strategy = $option.Option$isNone(queuing_strategy)
    ? undefined
    : fromQueuingStrategy($option.Option$Some$0(queuing_strategy));
  try {
    return Result$Ok(new ReadableStream(source, strategy));
  } catch (err) {
    return erroredError(err);
  }
};

export const from_pull: typeof $readableStream.from_pull = (pull) => {
  return new ReadableStream({ pull });
};

export const from_yielder: typeof $readableStream.from_yielder = (yielder) => {
  ensureMethod(
    ReadableStream,
    "from",
    "readable_stream.from_yielder",
    BUN_STREAM_FROM_ISSUE,
  );
  return ReadableStream.from(yielderAsJsIterator(yielder));
};

export const from_async_yielder: typeof $readableStream.from_async_yielder = (
  yielder,
) => {
  ensureMethod(
    ReadableStream,
    "from",
    "readable_stream.from_async_yielder",
    BUN_STREAM_FROM_ISSUE,
  );
  return ReadableStream.from(asyncYielderAsJsAsyncIterator(yielder));
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
  const pipeOptions = fromPipeOptions(options);
  return stream.pipeTo(destination, pipeOptions).then(
    () => Result$Ok(undefined),
    (err) => {
      if (pipeOptions.signal?.aborted) {
        return Result$Error(
          $stream.StreamLifecycleError$Aborted(pipeOptions.signal.reason),
        );
      }
      return erroredError(err);
    },
  );
};

export const tee: typeof $readableStream.tee = (stream: ReadableStream) => {
  if (stream.locked) return lockedError();
  try {
    return Result$Ok(stream.tee());
  } catch (err) {
    return erroredError(err);
  }
};

export const async_yielder: typeof $readableStream.async_yielder = <T>(
  stream: ReadableStream<T>,
) => {
  return jsAsyncIteratorAsAsyncYielder(stream.values());
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
