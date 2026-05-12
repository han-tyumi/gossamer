import type { BitArray } from "$/prelude.mjs";
import type * as $decompressionStream from "$/gossamer/gossamer/compression/decompression_stream.mjs";
import { Result$Error, Result$Ok } from "$/prelude.mjs";
import { toCompressionFormat } from "~/gossamer/compression/compression_stream.ffi.ts";
import { fromBitArrayStream, toBitArrayStream } from "~/utils/bit_array.ffi.ts";

const wrappedReadables = new WeakMap<
  DecompressionStream,
  ReadableStream<BitArray>
>();
const wrappedWritables = new WeakMap<
  DecompressionStream,
  WritableStream<BitArray>
>();

export const new_: typeof $decompressionStream.new$ = (format) => {
  try {
    return Result$Ok(new DecompressionStream(toCompressionFormat(format)));
  } catch {
    return Result$Error(undefined);
  }
};

export const readable: typeof $decompressionStream.readable = (stream) => {
  let wrapped = wrappedReadables.get(stream);
  if (wrapped === undefined) {
    wrapped = toBitArrayStream(stream.readable);
    wrappedReadables.set(stream, wrapped);
  }
  return wrapped;
};

export const writable: typeof $decompressionStream.writable = (stream) => {
  let wrapped = wrappedWritables.get(stream);
  if (wrapped === undefined) {
    wrapped = fromBitArrayStream(stream.writable);
    wrappedWritables.set(stream, wrapped);
  }
  return wrapped;
};
