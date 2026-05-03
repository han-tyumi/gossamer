import type * as $uint8ClampedArray from "$/gossamer/gossamer/uint8_clamped_array.mjs";
import { fromArray, toArray } from "~/utils/list.ffi.ts";
import { indexToResult, toResult } from "~/utils/result.ffi.ts";

export const new_: typeof $uint8ClampedArray.new$ = () =>
  new Uint8ClampedArray();

export const from_length: typeof $uint8ClampedArray.from_length = (length) =>
  toResult.fromThrows(() => new Uint8ClampedArray(length));

export const from_list: typeof $uint8ClampedArray.from_list = (list) =>
  new Uint8ClampedArray(toArray(list));

export const from_buffer: typeof $uint8ClampedArray.from_buffer = (buffer) =>
  new Uint8ClampedArray(buffer);

export const buffer: typeof $uint8ClampedArray.buffer = (array) =>
  array.buffer as ArrayBuffer;

export const byte_length: typeof $uint8ClampedArray.byte_length = (array) =>
  array.byteLength;

export const byte_offset: typeof $uint8ClampedArray.byte_offset = (array) =>
  array.byteOffset;

export const length: typeof $uint8ClampedArray.length = (array) => array.length;

export const at: typeof $uint8ClampedArray.at = (array, index) =>
  toResult(array.at(index));

export const with_: typeof $uint8ClampedArray.with$ = (array, index, value) =>
  toResult.fromThrows(() => array.with(index, value));

export const includes: typeof $uint8ClampedArray.includes = (array, value) =>
  array.includes(value);

export const index_of: typeof $uint8ClampedArray.index_of = (array, value) =>
  indexToResult(array.indexOf(value));

export const last_index_of: typeof $uint8ClampedArray.last_index_of = (
  array,
  value,
) => indexToResult(array.lastIndexOf(value));

export const slice: typeof $uint8ClampedArray.slice = (array) => array.slice();

export const slice_range: typeof $uint8ClampedArray.slice_range = (
  array,
  start,
  end,
) => array.slice(start, end);

export const subarray: typeof $uint8ClampedArray.subarray = (
  array,
  begin,
  end,
) => array.subarray(begin, end);

export const set: typeof $uint8ClampedArray.set = (array, values) =>
  toResult.fromThrows(() => {
    array.set(values);
    return undefined;
  });

export const set_with_offset: typeof $uint8ClampedArray.set_with_offset = (
  array,
  values,
  offset,
) =>
  toResult.fromThrows(() => {
    array.set(values, offset);
    return undefined;
  });

export const fill: typeof $uint8ClampedArray.fill = (array, value) =>
  array.fill(value);

export const reverse: typeof $uint8ClampedArray.reverse = (array) =>
  array.reverse();

export const to_list: typeof $uint8ClampedArray.to_list = (array) =>
  fromArray(Array.from(array));
