import type * as $float16Array from "$/gossamer/gossamer/float16_array.mjs";
import { fromArray, toArray } from "~/utils/list.ffi.ts";
import { indexToResult, toResult } from "~/utils/result.ffi.ts";

export const new_: typeof $float16Array.new$ = () => new Float16Array();

export const from_length: typeof $float16Array.from_length = (length) =>
  toResult.fromThrows(() => new Float16Array(length));

export const from_list: typeof $float16Array.from_list = (list) =>
  new Float16Array(toArray(list));

export const from_buffer: typeof $float16Array.from_buffer = (buffer) =>
  toResult.fromThrows(() => new Float16Array(buffer));

export const from_buffer_range: typeof $float16Array.from_buffer_range = (
  buffer,
  byteOffset,
  length,
) => toResult.fromThrows(() => new Float16Array(buffer, byteOffset, length));

export const buffer: typeof $float16Array.buffer = (array) =>
  array.buffer as ArrayBuffer;

export const byte_length: typeof $float16Array.byte_length = (array) =>
  array.byteLength;

export const byte_offset: typeof $float16Array.byte_offset = (array) =>
  array.byteOffset;

export const length: typeof $float16Array.length = (array) => array.length;

export const at: typeof $float16Array.at = (array, index) =>
  toResult(array.at(index));

export const with_: typeof $float16Array.with$ = (array, index, value) =>
  toResult.fromThrows(() => array.with(index, value));

export const includes: typeof $float16Array.includes = (array, value) =>
  array.includes(value);

export const index_of: typeof $float16Array.index_of = (array, value) =>
  indexToResult(array.indexOf(value));

export const last_index_of: typeof $float16Array.last_index_of = (
  array,
  value,
) => indexToResult(array.lastIndexOf(value));

export const slice: typeof $float16Array.slice = (array) => array.slice();

export const slice_range: typeof $float16Array.slice_range = (
  array,
  start,
  end,
) => array.slice(start, end);

export const subarray: typeof $float16Array.subarray = (array, begin, end) =>
  array.subarray(begin, end);

export const set: typeof $float16Array.set = (array, values) =>
  toResult.fromThrows(() => {
    array.set(values);
    return undefined;
  });

export const set_with_offset: typeof $float16Array.set_with_offset = (
  array,
  values,
  offset,
) =>
  toResult.fromThrows(() => {
    array.set(values, offset);
    return undefined;
  });

export const fill: typeof $float16Array.fill = (array, value) =>
  array.fill(value);

export const reverse: typeof $float16Array.reverse = (array) => array.reverse();

export const to_list: typeof $float16Array.to_list = (array) =>
  fromArray(Array.from(array));
