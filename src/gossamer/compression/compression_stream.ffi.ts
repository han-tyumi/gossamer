import type { BitArray } from "$/prelude.mjs";
import * as $compression from "$/gossamer/gossamer/compression.mjs";
import type * as $compressionStream from "$/gossamer/gossamer/compression/compression_stream.mjs";
import { fromBitArrayStream, toBitArrayStream } from "~/utils/bit_array.ffi.ts";

export function toCompressionFormat(
  format: $compression.CompressionFormat$,
): CompressionFormat {
  if ($compression.CompressionFormat$isDeflate(format)) return "deflate";
  if ($compression.CompressionFormat$isDeflateRaw(format)) {
    return "deflate-raw";
  }
  if ($compression.CompressionFormat$isGzip(format)) return "gzip";
  return "brotli";
}

const wrappedReadables = new WeakMap<
  CompressionStream,
  ReadableStream<BitArray>
>();
const wrappedWritables = new WeakMap<
  CompressionStream,
  WritableStream<BitArray>
>();

export const new_: typeof $compressionStream.new$ = (format) => {
  return new CompressionStream(toCompressionFormat(format));
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
