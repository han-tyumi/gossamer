import type * as $float64Array from "$/gossamer/gossamer/float64_array.mjs";
import { fromArray, toArray } from "~/utils/list.ffi.ts";
import { indexToResult, toResult } from "~/utils/result.ffi.ts";

export const new_: typeof $float64Array.new$ = () => new Float64Array();

export const from_length: typeof $float64Array.from_length = (length) =>
  toResult.fromThrows(() => new Float64Array(length));

export const from_list: typeof $float64Array.from_list = (list) =>
  new Float64Array(toArray(list));

export const from_buffer: typeof $float64Array.from_buffer = (buffer) =>
  toResult.fromThrows(() => new Float64Array(buffer));

export const buffer: typeof $float64Array.buffer = (array) =>
  array.buffer as ArrayBuffer;

export const byte_length: typeof $float64Array.byte_length = (array) =>
  array.byteLength;

export const byte_offset: typeof $float64Array.byte_offset = (array) =>
  array.byteOffset;

export const length: typeof $float64Array.length = (array) => array.length;

export const at: typeof $float64Array.at = (array, index) =>
  toResult(array.at(index));

export const with_: typeof $float64Array.with$ = (array, index, value) =>
  toResult.fromThrows(() => array.with(index, value));

export const includes: typeof $float64Array.includes = (array, value) =>
  array.includes(value);

export const index_of: typeof $float64Array.index_of = (array, value) =>
  indexToResult(array.indexOf(value));

export const last_index_of: typeof $float64Array.last_index_of = (
  array,
  value,
) => indexToResult(array.lastIndexOf(value));

export const slice: typeof $float64Array.slice = (array) => array.slice();

export const slice_range: typeof $float64Array.slice_range = (
  array,
  start,
  end,
) => array.slice(start, end);

export const subarray: typeof $float64Array.subarray = (array, begin, end) =>
  array.subarray(begin, end);

export const set: typeof $float64Array.set = (array, values) =>
  toResult.fromThrows(() => {
    array.set(values);
    return undefined;
  });

export const set_with_offset: typeof $float64Array.set_with_offset = (
  array,
  values,
  offset,
) =>
  toResult.fromThrows(() => {
    array.set(values, offset);
    return undefined;
  });

export const fill: typeof $float64Array.fill = (array, value) =>
  array.fill(value);

export const reverse: typeof $float64Array.reverse = (array) => array.reverse();

export const to_list: typeof $float64Array.to_list = (array) =>
  fromArray(Array.from(array));
