import type { BitArray } from "$/prelude.mjs";
import type * as $compressionStream from "$/gossamer/gossamer/compression_stream.mjs";
import { toCompressionFormat } from "~/gossamer/compression_format.ffi.ts";
import { fromBitArrayStream, toBitArrayStream } from "~/utils/bit_array.ffi.ts";
import { toResult } from "~/utils/result.ffi.ts";

const wrappedReadables = new WeakMap<
  CompressionStream,
  ReadableStream<BitArray>
>();
const wrappedWritables = new WeakMap<
  CompressionStream,
  WritableStream<BitArray>
>();

export const new_: typeof $compressionStream.new$ = (format) => {
  return toResult.fromThrows(() =>
    new CompressionStream(toCompressionFormat(format))
  );
};

export const readable: typeof $compressionStream.readable = (stream) => {
  let wrapped = wrappedReadables.get(stream);
  if (wrapped === undefined) {
    wrapped = toBitArrayStream(stream.readable);
    wrappedReadables.set(stream, wrapped);
  }
  return wrapped;
};

export const writable: typeof $compressionStream.writable = (stream) => {
  let wrapped = wrappedWritables.get(stream);
  if (wrapped === undefined) {
    wrapped = fromBitArrayStream(stream.writable);
    wrappedWritables.set(stream, wrapped);
  }
  return wrapped;
};
