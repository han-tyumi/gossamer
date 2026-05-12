import type * as $arrayBuffer from "$/gossamer/gossamer/buffer/array_buffer.mjs";
import * as $buffer from "$/gossamer/gossamer/buffer.mjs";
import { BitArray$BitArray, Result$Error, Result$Ok } from "$/prelude.mjs";

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

export const slice: typeof $arrayBuffer.slice = (
  arrayBuffer: ArrayBuffer,
) => {
  return arrayBuffer.slice(0);
};

export const slice_from: typeof $arrayBuffer.slice_from = (
  arrayBuffer: ArrayBuffer,
  start,
) => {
  return arrayBuffer.slice(start);
};

export const slice_range: typeof $arrayBuffer.slice_range = (
  arrayBuffer: ArrayBuffer,
  start,
  end,
) => {
  return arrayBuffer.slice(start, end);
};

export const to_bit_array: typeof $arrayBuffer.to_bit_array = (
  arrayBuffer: ArrayBuffer,
) => {
  if (arrayBuffer.detached) return Result$Error($buffer.BufferError$Detached());
  return Result$Ok(BitArray$BitArray(new Uint8Array(arrayBuffer)));
};
