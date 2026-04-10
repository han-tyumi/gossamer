import type * as $arrayBuffer from "$/gossamer/gossamer/array_buffer.mjs";
import { toResult } from "~/utils/result.ts";

export type ArrayBuffer$ = ArrayBuffer;

export const new_: typeof $arrayBuffer.new$ = (byteLength) => {
  return new ArrayBuffer(byteLength);
};

export const new_resizable: typeof $arrayBuffer.new_resizable = (
  byteLength,
  maxByteLength,
) => {
  return new ArrayBuffer(byteLength, { maxByteLength });
};

export const byte_length: typeof $arrayBuffer.byte_length = (
  arrayBuffer: ArrayBuffer,
) => {
  return arrayBuffer.byteLength;
};

export const max_byte_length: typeof $arrayBuffer.max_byte_length = (
  arrayBuffer: ArrayBuffer,
) => {
  return arrayBuffer.maxByteLength;
};

export const is_resizable: typeof $arrayBuffer.is_resizable = (
  arrayBuffer: ArrayBuffer,
) => {
  return arrayBuffer.resizable;
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

export const resize: typeof $arrayBuffer.resize = (
  arrayBuffer: ArrayBuffer,
  newByteLength,
) => {
  return toResult.fromThrows(() => {
    arrayBuffer.resize(newByteLength);
  });
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
