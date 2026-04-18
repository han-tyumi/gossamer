import * as $textEncoder from "$/gossamer/gossamer/text_encoder.mjs";
import { fromEncoding } from "~/gossamer/encoding.ts";

const sharedEncoder = new TextEncoder();

export const encoding: typeof $textEncoder.encoding = () => {
  return fromEncoding(sharedEncoder.encoding);
};

export const encode: typeof $textEncoder.encode = (
  input,
) => {
  return sharedEncoder.encode(input);
};

export const encode_into: typeof $textEncoder.encode_into = (
  input,
  dest: Uint8Array,
) => {
  const result = sharedEncoder.encodeInto(input, dest);
  return $textEncoder.EncodeIntoResult$EncodeIntoResult(
    result.read,
    result.written,
  );
};
