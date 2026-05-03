import type * as $float32Array from "$/gossamer/gossamer/float32_array.mjs";
import { fromArray, toArray } from "~/utils/list.ffi.ts";
import { indexToResult, toResult } from "~/utils/result.ffi.ts";

export const new_: typeof $float32Array.new$ = () => new Float32Array();

export const from_length: typeof $float32Array.from_length = (length) =>
  toResult.fromThrows(() => new Float32Array(length));

export const from_list: typeof $float32Array.from_list = (list) =>
  new Float32Array(toArray(list));

export const from_buffer: typeof $float32Array.from_buffer = (buffer) =>
  toResult.fromThrows(() => new Float32Array(buffer));

export const buffer: typeof $float32Array.buffer = (array) =>
  array.buffer as ArrayBuffer;

export const byte_length: typeof $float32Array.byte_length = (array) =>
  array.byteLength;

export const byte_offset: typeof $float32Array.byte_offset = (array) =>
  array.byteOffset;

export const length: typeof $float32Array.length = (array) => array.length;

export const at: typeof $float32Array.at = (array, index) =>
  toResult(array.at(index));

export const with_: typeof $float32Array.with$ = (array, index, value) =>
  toResult.fromThrows(() => array.with(index, value));

export const includes: typeof $float32Array.includes = (array, value) =>
  array.includes(value);

export const index_of: typeof $float32Array.index_of = (array, value) =>
  indexToResult(array.indexOf(value));

export const last_index_of: typeof $float32Array.last_index_of = (
  array,
  value,
) => indexToResult(array.lastIndexOf(value));

export const slice: typeof $float32Array.slice = (array) => array.slice();

export const slice_range: typeof $float32Array.slice_range = (
  array,
  start,
  end,
) => array.slice(start, end);

export const subarray: typeof $float32Array.subarray = (array, begin, end) =>
  array.subarray(begin, end);

export const set: typeof $float32Array.set = (array, values) =>
  toResult.fromThrows(() => {
    array.set(values);
    return undefined;
  });

export const set_with_offset: typeof $float32Array.set_with_offset = (
  array,
  values,
  offset,
) =>
  toResult.fromThrows(() => {
    array.set(values, offset);
    return undefined;
  });

export const fill: typeof $float32Array.fill = (array, value) =>
  array.fill(value);

export const reverse: typeof $float32Array.reverse = (array) => array.reverse();

export const to_list: typeof $float32Array.to_list = (array) =>
  fromArray(Array.from(array));
