import * as $writableStream from "$/gossamer/gossamer/writable_stream.mjs";
import { setIfSome } from "~/utils/option.ffi.ts";
import { toResult } from "~/utils/result.ffi.ts";

export const build: typeof $writableStream.build = (builder) => {
  return toResult.fromThrows(() => {
    const sink: UnderlyingSink = {};
    setIfSome(
      sink,
      "start",
      $writableStream.Builder$Builder$start(builder),
    );
    setIfSome(
      sink,
      "write",
      $writableStream.Builder$Builder$write(builder),
    );
    setIfSome(
      sink,
      "close",
      $writableStream.Builder$Builder$close(builder),
    );
    setIfSome(
      sink,
      "abort",
      $writableStream.Builder$Builder$abort(builder),
    );
    return new WritableStream(sink);
  });
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
  return toResult.fromPromise(stream.abort(reason).then(() => undefined));
};

export const close: typeof $writableStream.close = (
  stream: WritableStream,
) => {
  return toResult.fromPromise(stream.close().then(() => undefined));
};

export const get_writer: typeof $writableStream.get_writer = (
  stream: WritableStream,
) => {
  return toResult.fromThrows(() => stream.getWriter());
};
