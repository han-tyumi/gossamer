import type * as $uint8Array from "$/gossamer/gossamer/buffer/uint8_array.mjs";
import { BitArray$BitArray, Result$Error, Result$Ok } from "$/prelude.mjs";
import { toUint8Array } from "~/utils/bit_array.ffi.ts";
import { fromArray, toArray } from "~/utils/list.ffi.ts";
import { toResult } from "~/utils/result.ffi.ts";

export const new_: typeof $uint8Array.new$ = () => {
  return new Uint8Array();
};

export const from_list: typeof $uint8Array.from_list = (list) => {
  return new Uint8Array(toArray(list));
};

export const from_buffer: typeof $uint8Array.from_buffer = (buffer) => {
  return new Uint8Array(buffer);
};

export const from_buffer_range: typeof $uint8Array.from_buffer_range = (
  buffer,
  byteOffset,
  length,
) => {
  if (byteOffset < 0 || byteOffset + length > buffer.byteLength) {
    return Result$Error(undefined);
  }
  return Result$Ok(new Uint8Array(buffer, byteOffset, length));
};

export const from_bit_array: typeof $uint8Array.from_bit_array = toUint8Array;

export const buffer: typeof $uint8Array.buffer = (array) => {
  return array.buffer as ArrayBuffer;
};

export const length: typeof $uint8Array.length = (array) => {
  return array.length;
};

export const at: typeof $uint8Array.at = (array, index) => {
  return toResult(array.at(index));
};

export const to_list: typeof $uint8Array.to_list = (array) => {
  return fromArray(Array.from(array));
};

export const to_bit_array: typeof $uint8Array.to_bit_array = (array) => {
  return BitArray$BitArray(array);
};
