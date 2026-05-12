import * as $writableStream from "$/gossamer/gossamer/stream/writable_stream.mjs";
import * as $option from "$/gleam_stdlib/gleam/option.mjs";
import * as $stream from "$/gossamer/gossamer/stream.mjs";
import { Result$Error, Result$Ok } from "$/prelude.mjs";
import { setIfSome } from "~/utils/option.ffi.ts";
import { fromQueuingStrategy } from "~/utils/queuing_strategy.ffi.ts";

function lockedError() {
  return Result$Error($stream.StreamLifecycleError$Locked());
}

function erroredError(reason: unknown) {
  return Result$Error($stream.StreamLifecycleError$Errored(reason));
}

export const build: typeof $writableStream.build = (builder) => {
  const sink: UnderlyingSink = {};
  setIfSome(sink, "start", $writableStream.Builder$Builder$start(builder));
  setIfSome(sink, "write", $writableStream.Builder$Builder$write(builder));
  setIfSome(sink, "close", $writableStream.Builder$Builder$close(builder));
  setIfSome(sink, "abort", $writableStream.Builder$Builder$abort(builder));
  const strategyOption = $writableStream.Builder$Builder$queuing_strategy(
    builder,
  );
  const strategy = $option.Option$isNone(strategyOption)
    ? undefined
    : fromQueuingStrategy($option.Option$Some$0(strategyOption));
  try {
    return Result$Ok(new WritableStream(sink, strategy));
  } catch (err) {
    return erroredError(err);
  }
};

export const from_write: typeof $writableStream.from_write = (write) => {
  return new WritableStream({ write });
};

export const is_locked: typeof $writableStream.is_locked = (
  stream: WritableStream,
) => {
  return stream.locked;
};

export const abort: typeof $writableStream.abort = (
  stream: WritableStream,
  reason,
) => {
  return stream.abort(reason).then(
    () => Result$Ok(undefined),
    (err) => erroredError(err),
  );
};

export const close: typeof $writableStream.close = (stream: WritableStream) => {
  return stream.close().then(
    () => Result$Ok(undefined),
    (err) => erroredError(err),
  );
};

export const get_writer: typeof $writableStream.get_writer = (
  stream: WritableStream,
) => {
  if (stream.locked) return lockedError();
  try {
    return Result$Ok(stream.getWriter());
  } catch (err) {
    return erroredError(err);
  }
};
