import type * as $byobReader from "$/gossamer/gossamer/readable_stream/byob_reader.mjs";
import { toArrayBufferViewType } from "~/gossamer/array_buffer_view.ts";
import { toByobReaderReadOptions } from "~/gossamer/readable_stream/byob_reader_read_option.ts";
import { toReadResult } from "~/gossamer/readable_stream/read_result.ts";

export type ByobReader$<_T> = ReadableStreamBYOBReader;

export const closed: typeof $byobReader.closed = (
  reader: ReadableStreamBYOBReader,
) => {
  return reader.closed.then(() => undefined);
};

export const cancel: typeof $byobReader.cancel = (
  reader: ReadableStreamBYOBReader,
  reason,
) => {
  return reader.cancel(reason).then(() => undefined);
};

// TODO(@han-tyumi): Revisit BYOB reader types - the ArrayBufferView/ArrayBufferLike
// conversions are complex and require casts. May need to rethink how these are exposed.
export const read: typeof $byobReader.read = ((
  reader: ReadableStreamBYOBReader,
  view: { buffer: ArrayBufferLike; byte_length: number; byte_offset: number },
  options: Parameters<typeof $byobReader.read>[2],
) => {
  return reader.read({
    buffer: view.buffer as ArrayBuffer,
    byteLength: view.byte_length,
    byteOffset: view.byte_offset,
  }, toByobReaderReadOptions(options)).then((result) => {
    const newValue = result.value
      ? toArrayBufferViewType(result.value)
      : result.value;
    return toReadResult({ done: result.done, value: newValue });
  });
}) as typeof $byobReader.read;

export const release_lock: typeof $byobReader.release_lock = (
  reader: ReadableStreamBYOBReader,
) => {
  reader.releaseLock();
  return reader;
};
