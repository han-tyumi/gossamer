import * as $encoding from "$/gossamer/gossamer/encoding.mjs";
import type * as $textDecoder from "$/gossamer/gossamer/encoding/text_decoder.mjs";
import { Result$Error, Result$Ok } from "$/prelude.mjs";
import { fromEncoding } from "~/gossamer/encoding.ffi.ts";
import { toBufferSource } from "~/utils/bit_array.ffi.ts";

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

export const build: typeof $textDecoder.do_build = (
  label,
  fatal,
  ignore_bom,
) => {
  return constructDecoder(label, { fatal, ignoreBOM: ignore_bom });
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

export const decode: typeof $textDecoder.do_decode = (
  input,
  label,
  fatal,
  ignore_bom,
) => {
  let decoder;
  try {
    decoder = new TextDecoder(label, { fatal, ignoreBOM: ignore_bom });
  } catch {
    return Result$Error($encoding.DecoderError$UnsupportedEncoding(label));
  }
  return decodeBytes(decoder, toBufferSource(input));
};
