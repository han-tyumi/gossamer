import type * as $textEncoderStream from "$/gossamer/gossamer/text_encoder_stream.mjs";
import { fromEncoding } from "~/gossamer/encoding.ffi.ts";

export const new_: typeof $textEncoderStream.new$ = () => {
  return new TextEncoderStream();
};

export const readable: typeof $textEncoderStream.readable = (
  encoder: TextEncoderStream,
) => {
  return encoder.readable;
};

export const writable: typeof $textEncoderStream.writable = (
  encoder: TextEncoderStream,
) => {
  return encoder.writable;
};

export const encoding: typeof $textEncoderStream.encoding = (
  encoder: TextEncoderStream,
) => {
  return fromEncoding(encoder.encoding);
};
