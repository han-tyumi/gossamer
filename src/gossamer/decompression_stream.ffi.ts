import type * as $decompressionStream from "$/gossamer/gossamer/decompression_stream.mjs";
import { toCompressionFormat } from "~/gossamer/compression_format.ts";
import { toResult } from "~/utils/result.ts";

export type DecompressionStream$ = DecompressionStream;

export const new_: typeof $decompressionStream.new$ = (format) => {
  return toResult.fromThrows(() => new DecompressionStream(toCompressionFormat(format)));
};

export const readable: typeof $decompressionStream.readable = (stream) => {
  return stream.readable;
};

export const writable: typeof $decompressionStream.writable = (stream) => {
  return stream.writable as unknown as WritableStream<Uint8Array>;
};
