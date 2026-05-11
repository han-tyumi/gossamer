import type { BitArray } from "$/prelude.mjs";
import * as $encoding from "$/gossamer/gossamer/encoding.mjs";
import * as $textDecoderStream from "$/gossamer/gossamer/encoding/text_decoder_stream.mjs";
import { Result$Error, Result$Ok } from "$/prelude.mjs";
import { fromEncoding } from "~/gossamer/encoding.ffi.ts";
import { fromBitArrayStream } from "~/utils/bit_array.ffi.ts";

const wrappedWritables = new WeakMap<
  TextDecoderStream,
  WritableStream<BitArray>
>();

export const build: typeof $textDecoderStream.build = (builder) => {
  const label = $textDecoderStream.Builder$Builder$label(builder);
  const options: TextDecoderOptions = {
    fatal: $textDecoderStream.Builder$Builder$fatal(builder),
    ignoreBOM: $textDecoderStream.Builder$Builder$ignore_bom(builder),
  };
  try {
    return Result$Ok(new TextDecoderStream(label, options));
  } catch {
    return Result$Error($encoding.DecoderError$UnsupportedEncoding(label));
  }
};

export const readable: typeof $textDecoderStream.readable = (decoder) => {
  return decoder.readable;
};

export const writable: typeof $textDecoderStream.writable = (decoder) => {
  let wrapped = wrappedWritables.get(decoder);
  if (wrapped === undefined) {
    wrapped = fromBitArrayStream(decoder.writable);
    wrappedWritables.set(decoder, wrapped);
  }
  return wrapped;
};

export const encoding: typeof $textDecoderStream.encoding = (decoder) => {
  return fromEncoding(decoder.encoding);
};

export const is_fatal: typeof $textDecoderStream.is_fatal = (decoder) => {
  return decoder.fatal;
};

export const is_ignore_bom: typeof $textDecoderStream.is_ignore_bom = (
  decoder,
) => {
  return decoder.ignoreBOM;
};
