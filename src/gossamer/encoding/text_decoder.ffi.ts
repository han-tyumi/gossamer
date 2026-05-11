import * as $encoding from "$/gossamer/gossamer/encoding.mjs";
import * as $textDecoder from "$/gossamer/gossamer/encoding/text_decoder.mjs";
import { Result$Error, Result$Ok } from "$/prelude.mjs";
import { fromEncoding } from "~/gossamer/encoding.ffi.ts";
import { toBufferSource } from "~/utils/bit_array.ffi.ts";

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

function constructDecoder(label: string, options: TextDecoderOptions) {
  try {
    return Result$Ok(new TextDecoder(label, options));
  } catch {
    return Result$Error($encoding.DecoderError$UnsupportedEncoding(label));
  }
}

function decodeBytes(
  decoder: TextDecoder,
  input?: BufferSource,
  stream?: boolean,
) {
  try {
    return Result$Ok(decoder.decode(input, { stream }));
  } catch {
    return Result$Error($encoding.DecoderError$MalformedInput());
  }
}

export const build: typeof $textDecoder.build = (builder) => {
  const { label, options } = fromBuilder(builder);
  return constructDecoder(label, options);
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
) => decodeBytes(decoder, toBufferSource(input), true);

export const flush: typeof $textDecoder.flush = (decoder) =>
  decodeBytes(decoder);

export const decode: typeof $textDecoder.decode = (input, builder) => {
  const { label, options } = fromBuilder(builder);
  let decoder;
  try {
    decoder = new TextDecoder(label, options);
  } catch {
    return Result$Error($encoding.DecoderError$UnsupportedEncoding(label));
  }
  return decodeBytes(decoder, toBufferSource(input));
};
