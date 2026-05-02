import * as $writableStream from "$/gossamer/gossamer/writable_stream.mjs";
import { toArray } from "~/utils/list.ffi.ts";
import { toResult } from "~/utils/result.ffi.ts";

export type WritableStream$<T> = WritableStream<T>;

function toUnderlyingSink<T>(
  options: $writableStream.UnderlyingSink$<T>[],
): UnderlyingSink<T> {
  const result: UnderlyingSink<T> = {};
  for (const option of options) {
    if ($writableStream.UnderlyingSink$isStart(option)) {
      result.start = $writableStream.UnderlyingSink$Start$0(option);
    } else if ($writableStream.UnderlyingSink$isWrite(option)) {
      result.write = $writableStream.UnderlyingSink$Write$0(option);
    } else if ($writableStream.UnderlyingSink$isClose(option)) {
      result.close = $writableStream.UnderlyingSink$Close$0(option);
    } else if ($writableStream.UnderlyingSink$isAbort(option)) {
      result.abort = $writableStream.UnderlyingSink$Abort$0(option);
    }
  }
  return result;
}

export const new_: typeof $writableStream.new$ = (sink) => {
  return toResult.fromThrows(() =>
    new WritableStream(toUnderlyingSink(toArray(sink)))
  );
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
