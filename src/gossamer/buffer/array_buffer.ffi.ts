import type * as $arrayBuffer from "$/gossamer/gossamer/buffer/array_buffer.mjs";
import { toResult } from "~/utils/result.ffi.ts";

export const new_: typeof $arrayBuffer.new$ = (byteLength) => {
  return new ArrayBuffer(Math.max(0, byteLength));
};

export const new_resizable: typeof $arrayBuffer.new_resizable = (
  byteLength,
  maxByteLength,
) => {
  const clampedByteLength = Math.max(0, byteLength);
  const clampedMax = Math.max(clampedByteLength, maxByteLength);
  return new ArrayBuffer(clampedByteLength, { maxByteLength: clampedMax });
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
  return toResult.fromThrows(() => arrayBuffer.transfer());
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
