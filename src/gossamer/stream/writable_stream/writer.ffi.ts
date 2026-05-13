import type * as $writer from "$/gossamer/gossamer/stream/writable_stream/writer.mjs";
import * as $stream from "$/gossamer/gossamer/stream.mjs";
import { Result$Error, Result$Ok } from "$/prelude.mjs";
import { toResult } from "~/utils/result.ffi.ts";

function erroredError(reason: unknown) {
  return Result$Error($stream.StreamLifecycleError$Errored(reason));
}

function releasedError() {
  return Result$Error($stream.StreamLifecycleError$Released());
}

export const closed: typeof $writer.closed = (
  writer: WritableStreamDefaultWriter,
) => {
  return writer.closed.then(
    () => Result$Ok(undefined),
    (err) => erroredError(err),
  );
};

export const desired_size: typeof $writer.desired_size = (
  writer: WritableStreamDefaultWriter,
) => {
  return toResult(writer.desiredSize);
};

export const ready: typeof $writer.ready = (
  writer: WritableStreamDefaultWriter,
) => {
  return writer.ready.then(
    () => Result$Ok(undefined),
    (err) => erroredError(err),
  );
};

export const abort: typeof $writer.abort = (
  writer: WritableStreamDefaultWriter,
  reason,
) => {
  return writer.abort(reason).then(
    () => Result$Ok(undefined),
    (err) => erroredError(err),
  );
};

export const close: typeof $writer.close = (
  writer: WritableStreamDefaultWriter,
) => {
  return writer.close().then(
    () => Result$Ok(undefined),
    (err) => erroredError(err),
  );
};

export const release_lock: typeof $writer.release_lock = (
  writer: WritableStreamDefaultWriter,
) => {
  try {
    writer.releaseLock();
    return Result$Ok(undefined);
  } catch {
    return releasedError();
  }
};

export const write: typeof $writer.write = <W>(
  writer: WritableStreamDefaultWriter<W>,
  chunk: W,
) => {
  return writer.write(chunk).then(
    () => Result$Ok(undefined),
    (err) => erroredError(err),
  );
};
