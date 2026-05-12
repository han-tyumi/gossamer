import type * as $arrayBuffer from "$/gossamer/gossamer/buffer/array_buffer.mjs";
import { BitArray$BitArray } from "$/prelude.mjs";

export const new_: typeof $arrayBuffer.new$ = (byteLength) => {
  return new ArrayBuffer(Math.max(0, byteLength));
};

export const byte_length: typeof $arrayBuffer.byte_length = (
  arrayBuffer: ArrayBuffer,
) => {
  return arrayBuffer.byteLength;
};

export const is_view: typeof $arrayBuffer.is_view = (value) => {
  return ArrayBuffer.isView(value);
};

export const to_bit_array: typeof $arrayBuffer.to_bit_array = (
  arrayBuffer: ArrayBuffer,
) => {
  return BitArray$BitArray(new Uint8Array(arrayBuffer));
};
