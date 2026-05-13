import type * as $reader from "$/gossamer/gossamer/stream/readable_stream/reader.mjs";
import * as $stream from "$/gossamer/gossamer/stream.mjs";
import { Result$Error, Result$Ok } from "$/prelude.mjs";
import { toReadResult } from "~/gossamer/stream/readable_stream/read_result.ffi.ts";

function erroredError(reason: unknown) {
  return Result$Error($stream.StreamLifecycleError$Errored(reason));
}

function releasedError() {
  return Result$Error($stream.StreamLifecycleError$Released());
}

export const closed: typeof $reader.closed = (
  reader: ReadableStreamDefaultReader,
) => {
  return reader.closed.then(
    () => Result$Ok(undefined),
    (err) => erroredError(err),
  );
};

export const cancel: typeof $reader.cancel = (
  reader: ReadableStreamDefaultReader,
  reason,
) => {
  return reader.cancel(reason).then(
    () => Result$Ok(undefined),
    (err) => erroredError(err),
  );
};

export const read: typeof $reader.read = (
  reader: ReadableStreamDefaultReader,
) => {
  return reader.read().then(
    (result) => Result$Ok(toReadResult(result)),
    (err) => erroredError(err),
  );
};

export const release_lock: typeof $reader.release_lock = (
  reader: ReadableStreamDefaultReader,
) => {
  try {
    reader.releaseLock();
    return Result$Ok(undefined);
  } catch {
    return releasedError();
  }
};
