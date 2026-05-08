import * as $textDecoder from "$/gossamer/gossamer/text_decoder.mjs";
import type { List } from "$/prelude.mjs";
import { fromEncoding } from "~/gossamer/encoding.ffi.ts";
import { toBufferSource } from "~/utils/bit_array.ffi.ts";
import { toArray } from "~/utils/list.ffi.ts";
import { toResult } from "~/utils/result.ffi.ts";

export function toTextDecoderOptions(
  options: List<$textDecoder.TextDecoderOption$>,
): Partial<TextDecoderOptions> {
  const result: Partial<TextDecoderOptions> = {};
  for (const option of toArray(options)) {
    if ($textDecoder.TextDecoderOption$isFatal(option)) {
      result.fatal = true;
    } else if ($textDecoder.TextDecoderOption$isIgnoreBom(option)) {
      result.ignoreBOM = true;
    }
  }
  return result;
}

export const new_: typeof $textDecoder.new$ = () => {
  return new TextDecoder();
};

export const new_with: typeof $textDecoder.new_with = (label, options) => {
  return toResult.fromThrows(
    () => new TextDecoder(label, toTextDecoderOptions(options)),
  );
};

export const encoding: typeof $textDecoder.encoding = (
  decoder: TextDecoder,
) => {
  return fromEncoding(decoder.encoding);
};

export const is_fatal: typeof $textDecoder.is_fatal = (
  decoder: TextDecoder,
) => {
  return decoder.fatal;
};

export const is_ignore_bom: typeof $textDecoder.is_ignore_bom = (
  decoder: TextDecoder,
) => {
  return decoder.ignoreBOM;
};

export const decode_chunk: typeof $textDecoder.decode_chunk = (
  decoder: TextDecoder,
  input,
) => {
  return toResult.fromThrows(() =>
    decoder.decode(toBufferSource(input), { stream: true })
  );
};

export const flush: typeof $textDecoder.flush = (decoder: TextDecoder) => {
  return toResult.fromThrows(() => decoder.decode());
};

export const decode: typeof $textDecoder.decode = (
  input,
  label,
  options,
) => {
  return toResult.fromThrows(() =>
    new TextDecoder(label, toTextDecoderOptions(options))
      .decode(toBufferSource(input))
  );
};
