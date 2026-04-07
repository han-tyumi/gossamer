import type * as $compressionStream from "$/gossamer/gossamer/compression_stream.mjs";
import { toCompressionFormat } from "~/gossamer/compression_format.ts";

export type CompressionStream$ = CompressionStream;

export const new_: typeof $compressionStream.new$ = (format) => {
  return new CompressionStream(toCompressionFormat(format));
};

export const readable: typeof $compressionStream.readable = (stream) => {
  return stream.readable;
};

export const writable: typeof $compressionStream.writable = (stream) => {
  return stream.writable as unknown as WritableStream<Uint8Array>;
};
