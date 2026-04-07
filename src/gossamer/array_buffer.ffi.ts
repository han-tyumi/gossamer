import type * as $arrayBuffer from "$/gossamer/gossamer/array_buffer.mjs";

export type ArrayBuffer$ = ArrayBuffer;

export const new_: typeof $arrayBuffer.new$ = (byteLength) => {
  return new ArrayBuffer(byteLength);
};

export const byte_length: typeof $arrayBuffer.byte_length = (
  arrayBuffer: ArrayBuffer,
) => {
  return arrayBuffer.byteLength;
};

export const is_view: typeof $arrayBuffer.is_view = (value) => {
  return ArrayBuffer.isView(value);
};

export const is_detached: typeof $arrayBuffer.is_detached = (
  arrayBuffer: ArrayBuffer,
) => {
  return arrayBuffer.detached;
};

export const transfer: typeof $arrayBuffer.transfer = (
  arrayBuffer: ArrayBuffer,
) => {
  return arrayBuffer.transfer();
};

export const slice: typeof $arrayBuffer.slice = (
  arrayBuffer: ArrayBuffer,
  begin,
) => {
  return arrayBuffer.slice(begin);
};

export const slice_with_end: typeof $arrayBuffer.slice_with_end = (
  arrayBuffer: ArrayBuffer,
  begin,
  end,
) => {
  return arrayBuffer.slice(begin, end);
};
