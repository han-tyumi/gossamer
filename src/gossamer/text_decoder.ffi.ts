import * as $textDecoder from "$/gossamer/gossamer/text_decoder.mjs";
import { fromEncoding } from "~/gossamer/encoding.ffi.ts";
import { toBufferSource } from "~/utils/bit_array.ffi.ts";
import { toResult } from "~/utils/result.ffi.ts";

function fromBuilder(builder: $textDecoder.Builder$): {
  label: string;
  options: TextDecoderOptions;
} {
  return {
    label: $textDecoder.Builder$Builder$label(builder),
    options: {
      fatal: $textDecoder.Builder$Builder$fatal(builder),
      ignoreBOM: $textDecoder.Builder$Builder$ignore_bom(builder),
    },
  };
}

export const build: typeof $textDecoder.build = (builder) => {
  const { label, options } = fromBuilder(builder);
  return toResult.fromThrows(() => new TextDecoder(label, options));
};

export const encoding: typeof $textDecoder.encoding = (decoder) => {
  return fromEncoding(decoder.encoding);
};

export const is_fatal: typeof $textDecoder.is_fatal = (decoder) =>
  decoder.fatal;

export const is_ignore_bom: typeof $textDecoder.is_ignore_bom = (decoder) =>
  decoder.ignoreBOM;

export const decode_chunk: typeof $textDecoder.decode_chunk = (
  decoder,
  input,
) => {
  return toResult.fromThrows(() =>
    decoder.decode(toBufferSource(input), { stream: true })
  );
};

export const flush: typeof $textDecoder.flush = (decoder) => {
  return toResult.fromThrows(() => decoder.decode());
};

export const decode: typeof $textDecoder.decode = (input, builder) => {
  const { label, options } = fromBuilder(builder);
  return toResult.fromThrows(() =>
    new TextDecoder(label, options).decode(toBufferSource(input))
  );
};
