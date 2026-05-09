import type { BitArray } from "$/prelude.mjs";
import * as $compressionStream from "$/gossamer/gossamer/compression_stream.mjs";
import { fromBitArrayStream, toBitArrayStream } from "~/utils/bit_array.ffi.ts";
import { toResult } from "~/utils/result.ffi.ts";

export function toCompressionFormat(
  format: $compressionStream.CompressionFormat$,
): CompressionFormat {
  if ($compressionStream.CompressionFormat$isDeflate(format)) return "deflate";
  if ($compressionStream.CompressionFormat$isDeflateRaw(format)) {
    return "deflate-raw";
  }
  if ($compressionStream.CompressionFormat$isGzip(format)) return "gzip";
  if ($compressionStream.CompressionFormat$isOther(format)) {
    return $compressionStream.CompressionFormat$Other$0(
      format,
    ) as CompressionFormat;
  }
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
