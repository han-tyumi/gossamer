import type * as $textDecoder from "$/gossamer/gossamer/text_decoder.mjs";
import { toTextDecoderOptions } from "~/gossamer/text_decoder/text_decoder_option.ts";

export type TextDecoder$ = TextDecoder;

const sharedDecoder = new TextDecoder();

export const new_: typeof $textDecoder.new$ = () => {
  return new TextDecoder();
};

export const new_with: typeof $textDecoder.new_with = (label, options) => {
  return new TextDecoder(
    label,
    toTextDecoderOptions(options),
  );
};

export const encoding: typeof $textDecoder.encoding = (
  decoder: TextDecoder,
) => {
  return decoder.encoding;
};

export const fatal: typeof $textDecoder.fatal = (decoder: TextDecoder) => {
  return decoder.fatal;
};

export const ignore_bom: typeof $textDecoder.ignore_bom = (
  decoder: TextDecoder,
) => {
  return decoder.ignoreBOM;
};

export const decode_chunk: typeof $textDecoder.decode_chunk = (
  decoder: TextDecoder,
  input: ArrayBuffer,
) => {
  return decoder.decode(input, { stream: true });
};

export const flush: typeof $textDecoder.flush = (decoder: TextDecoder) => {
  return decoder.decode();
};

export const decode: typeof $textDecoder.decode = (
  input: ArrayBuffer,
) => {
  return sharedDecoder.decode(input);
};

export const decode_with: typeof $textDecoder.decode_with = (
  input: ArrayBuffer,
  label,
  options,
) => {
  return new TextDecoder(label, toTextDecoderOptions(options)).decode(input);
};
