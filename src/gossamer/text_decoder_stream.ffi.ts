import type * as $textDecoderStream from "$/gossamer/gossamer/text_decoder_stream.mjs";
import { fromEncoding } from "~/gossamer/encoding.ts";
import { toTextDecoderOptions } from "~/gossamer/text_decoder/text_decoder_option.ts";
import { toResult } from "~/utils/result.ts";

export type TextDecoderStream$ = TextDecoderStream;

export const new_: typeof $textDecoderStream.new$ = () => {
  return new TextDecoderStream();
};

export const new_with: typeof $textDecoderStream.new_with = (
  label,
  options,
) => {
  return toResult.fromThrows(
    () => new TextDecoderStream(label, toTextDecoderOptions(options)),
  );
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
  return fromEncoding(decoder.encoding);
};

export const is_fatal: typeof $textDecoderStream.is_fatal = (
  decoder: TextDecoderStream,
) => {
  return decoder.fatal;
};

export const is_ignore_bom: typeof $textDecoderStream.is_ignore_bom = (
  decoder: TextDecoderStream,
) => {
  return decoder.ignoreBOM;
};
