import type { BitArray } from "$/prelude.mjs";
import type * as $textEncoderStream from "$/gossamer/gossamer/encoding/text_encoder_stream.mjs";
import { fromEncoding } from "~/gossamer/encoding.ffi.ts";
import { toBitArrayStream } from "~/utils/bit_array.ffi.ts";

const wrappedReadables = new WeakMap<
  TextEncoderStream,
  ReadableStream<BitArray>
>();

export const new_: typeof $textEncoderStream.new$ = () => {
  return new TextEncoderStream();
};

export const readable: typeof $textEncoderStream.readable = (encoder) => {
  let wrapped = wrappedReadables.get(encoder);
  if (wrapped === undefined) {
    wrapped = toBitArrayStream(encoder.readable);
    wrappedReadables.set(encoder, wrapped);
  }
  return wrapped;
};

export const writable: typeof $textEncoderStream.writable = (encoder) => {
  return encoder.writable;
};

export const encoding: typeof $textEncoderStream.encoding = (encoder) => {
  return fromEncoding(encoder.encoding);
};
