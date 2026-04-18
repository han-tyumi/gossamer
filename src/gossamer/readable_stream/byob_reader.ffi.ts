import * as $byobReader from "$/gossamer/gossamer/readable_stream/byob_reader.mjs";
import type { List } from "$/prelude.mjs";
import { toArrayBufferViewType } from "~/gossamer/array_buffer.ffi.ts";
import { toReadResult } from "~/gossamer/readable_stream/read_result.ffi.ts";
import { toArray } from "~/utils/list.ffi.ts";
import { toResult } from "~/utils/result.ffi.ts";

export type ByobReader$<_T> = ReadableStreamBYOBReader;

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

// TODO(@han-tyumi): Revisit BYOB reader types - the ArrayBufferView/ArrayBufferLike
// conversions are complex and require casts. May need to rethink how these are exposed.
export const read: typeof $byobReader.read = ((
  reader: ReadableStreamBYOBReader,
  view: { buffer: ArrayBufferLike; byte_length: number; byte_offset: number },
  options: Parameters<typeof $byobReader.read>[2],
) => {
  return toResult.fromPromise(
    reader.read({
      buffer: view.buffer as ArrayBuffer,
      byteLength: view.byte_length,
      byteOffset: view.byte_offset,
    }, toByobReaderReadOptions(options)).then((result) => {
      const newValue = result.value
        ? toArrayBufferViewType(result.value)
        : result.value;
      return toReadResult({ done: result.done, value: newValue });
    }),
  );
}) as typeof $byobReader.read;

export const release_lock: typeof $byobReader.release_lock = (
  reader: ReadableStreamBYOBReader,
) => {
  return toResult.fromThrows(() => {
    reader.releaseLock();
    return reader;
  });
};
