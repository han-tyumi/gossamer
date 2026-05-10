import type * as $arrayBuffer from "$/gossamer/gossamer/buffer/array_buffer.mjs";
import * as $buffer from "$/gossamer/gossamer/buffer.mjs";
import { Result$Error, Result$Ok } from "$/prelude.mjs";

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
  if (arrayBuffer.detached) return Result$Error($buffer.BufferError$Detached());
  return Result$Ok(arrayBuffer.transfer());
};

export const resize: typeof $arrayBuffer.resize = (
  arrayBuffer: ArrayBuffer,
  newByteLength,
) => {
  if (arrayBuffer.detached) return Result$Error($buffer.BufferError$Detached());
  if (newByteLength > arrayBuffer.maxByteLength || !arrayBuffer.resizable) {
    return Result$Error(
      $buffer.BufferError$OutOfRange(newByteLength, arrayBuffer.maxByteLength),
    );
  }
  arrayBuffer.resize(newByteLength);
  return Result$Ok(undefined);
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
