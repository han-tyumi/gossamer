import type * as $textDecoderStream from "$/gossamer/gossamer/text_decoder_stream.mjs";
import { toTextDecoderOptions } from "~/gossamer/text_decoder/text_decoder_option.ts";

export type TextDecoderStream$ = TextDecoderStream;

export const new_: typeof $textDecoderStream.new$ = () => {
  return new TextDecoderStream();
};

export const new_with: typeof $textDecoderStream.new_with = (
  label,
  options,
) => {
  return new TextDecoderStream(label, toTextDecoderOptions(options));
};

export const readable: typeof $textDecoderStream.readable = (
  decoder: TextDecoderStream,
) => {
  return decoder.readable;
};

export const writable: typeof $textDecoderStream.writable = (
  decoder: TextDecoderStream,
) => {
  return decoder.writable;
};

export const encoding: typeof $textDecoderStream.encoding = (
  decoder: TextDecoderStream,
) => {
  return decoder.encoding;
};

export const fatal: typeof $textDecoderStream.fatal = (
  decoder: TextDecoderStream,
) => {
  return decoder.fatal;
};

export const ignore_bom: typeof $textDecoderStream.ignore_bom = (
  decoder: TextDecoderStream,
) => {
  return decoder.ignoreBOM;
};
