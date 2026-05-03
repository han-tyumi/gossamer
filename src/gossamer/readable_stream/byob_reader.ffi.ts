import * as $byobReader from "$/gossamer/gossamer/readable_stream/byob_reader.mjs";
import {
  ReadResult$Done,
  ReadResult$Value,
} from "$/gossamer/gossamer/readable_stream/read_result.mjs";
import type { List } from "$/prelude.mjs";
import {
  unwrap as unwrapTypedArray,
  wrap as wrapTypedArray,
} from "~/gossamer/typed_array.ffi.ts";
import { toArray } from "~/utils/list.ffi.ts";
import { toOption } from "~/utils/option.ffi.ts";
import { toResult } from "~/utils/result.ffi.ts";

function toByobReaderReadOptions(
  options: List<$byobReader.ByobReaderReadOption$>,
): Partial<ReadableStreamBYOBReaderReadOptions> {
  const result: Partial<ReadableStreamBYOBReaderReadOptions> = {};
  for (const option of toArray(options)) {
    if ($byobReader.ByobReaderReadOption$isMin(option)) {
      result.min = $byobReader.ByobReaderReadOption$Min$0(option);
    }
  }
  return result;
}

export const closed: typeof $byobReader.closed = (
  reader: ReadableStreamBYOBReader,
) => {
  return toResult.fromPromise(reader.closed.then(() => undefined));
};

export const cancel: typeof $byobReader.cancel = (
  reader: ReadableStreamBYOBReader,
  reason,
) => {
  return toResult.fromPromise(reader.cancel(reason).then(() => undefined));
};

export const read: typeof $byobReader.read = (
  reader: ReadableStreamBYOBReader,
  view,
  options,
) => {
  return toResult.fromPromise(
    reader
      .read(unwrapTypedArray(view), toByobReaderReadOptions(options))
      .then((result) => {
        if (result.done) {
          return ReadResult$Done(
            toOption(result.value ? wrapTypedArray(result.value) : null),
          );
        }
        return ReadResult$Value(wrapTypedArray(result.value));
      }),
  );
};

export const release_lock: typeof $byobReader.release_lock = (
  reader: ReadableStreamBYOBReader,
) => {
  return toResult.fromThrows(() => {
    reader.releaseLock();
    return reader;
  });
};
