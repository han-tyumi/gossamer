import type * as $uint32Array from "$/gossamer/gossamer/uint32_array.mjs";
import { fromArray, toArray } from "~/utils/list.ffi.ts";
import { indexToResult, toResult } from "~/utils/result.ffi.ts";

export const new_: typeof $uint32Array.new$ = () => new Uint32Array();

export const from_length: typeof $uint32Array.from_length = (length) =>
  toResult.fromThrows(() => new Uint32Array(length));

export const from_list: typeof $uint32Array.from_list = (list) =>
  new Uint32Array(toArray(list));

export const from_buffer: typeof $uint32Array.from_buffer = (buffer) =>
  toResult.fromThrows(() => new Uint32Array(buffer));

export const buffer: typeof $uint32Array.buffer = (array) =>
  array.buffer as ArrayBuffer;

export const byte_length: typeof $uint32Array.byte_length = (array) =>
  array.byteLength;

export const byte_offset: typeof $uint32Array.byte_offset = (array) =>
  array.byteOffset;

export const length: typeof $uint32Array.length = (array) => array.length;

export const at: typeof $uint32Array.at = (array, index) =>
  toResult(array.at(index));

export const with_: typeof $uint32Array.with$ = (array, index, value) =>
  toResult.fromThrows(() => array.with(index, value));

export const includes: typeof $uint32Array.includes = (array, value) =>
  array.includes(value);

export const index_of: typeof $uint32Array.index_of = (array, value) =>
  indexToResult(array.indexOf(value));

export const last_index_of: typeof $uint32Array.last_index_of = (
  array,
  value,
) => indexToResult(array.lastIndexOf(value));

export const slice: typeof $uint32Array.slice = (array) => array.slice();

export const slice_range: typeof $uint32Array.slice_range = (
  array,
  start,
  end,
) => array.slice(start, end);

export const subarray: typeof $uint32Array.subarray = (array, begin, end) =>
  array.subarray(begin, end);

export const set: typeof $uint32Array.set = (array, values) =>
  toResult.fromThrows(() => {
    array.set(values);
    return undefined;
  });

export const set_with_offset: typeof $uint32Array.set_with_offset = (
  array,
  values,
  offset,
) =>
  toResult.fromThrows(() => {
    array.set(values, offset);
    return undefined;
  });

export const fill: typeof $uint32Array.fill = (array, value) =>
  array.fill(value);

export const reverse: typeof $uint32Array.reverse = (array) => array.reverse();

export const to_list: typeof $uint32Array.to_list = (array) =>
  fromArray(Array.from(array));
