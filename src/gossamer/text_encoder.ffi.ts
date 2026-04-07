import type * as $textEncoder from "$/gossamer/gossamer/text_encoder.mjs";
import { EncodeIntoResult$EncodeIntoResult } from "$/gossamer/gossamer/text_encoder/encode_into_result.mjs";

const sharedEncoder = new TextEncoder();

export const encoding: typeof $textEncoder.encoding = () => {
  return sharedEncoder.encoding;
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
  return EncodeIntoResult$EncodeIntoResult(result.read, result.written);
};
