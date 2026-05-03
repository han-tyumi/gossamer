import type * as $int16Array from "$/gossamer/gossamer/int16_array.mjs";
import { fromArray, toArray } from "~/utils/list.ffi.ts";
import { indexToResult, toResult } from "~/utils/result.ffi.ts";

export const new_: typeof $int16Array.new$ = () => new Int16Array();

export const from_length: typeof $int16Array.from_length = (length) =>
  toResult.fromThrows(() => new Int16Array(length));

export const from_list: typeof $int16Array.from_list = (list) =>
  new Int16Array(toArray(list));

export const from_buffer: typeof $int16Array.from_buffer = (buffer) =>
  toResult.fromThrows(() => new Int16Array(buffer));

export const buffer: typeof $int16Array.buffer = (array) =>
  array.buffer as ArrayBuffer;

export const byte_length: typeof $int16Array.byte_length = (array) =>
  array.byteLength;

export const byte_offset: typeof $int16Array.byte_offset = (array) =>
  array.byteOffset;

export const length: typeof $int16Array.length = (array) => array.length;

export const at: typeof $int16Array.at = (array, index) =>
  toResult(array.at(index));

export const with_: typeof $int16Array.with$ = (array, index, value) =>
  toResult.fromThrows(() => array.with(index, value));

export const includes: typeof $int16Array.includes = (array, value) =>
  array.includes(value);

export const index_of: typeof $int16Array.index_of = (array, value) =>
  indexToResult(array.indexOf(value));

export const last_index_of: typeof $int16Array.last_index_of = (array, value) =>
  indexToResult(array.lastIndexOf(value));

export const slice: typeof $int16Array.slice = (array) => array.slice();

export const slice_range: typeof $int16Array.slice_range = (
  array,
  start,
  end,
) => array.slice(start, end);

export const subarray: typeof $int16Array.subarray = (array, begin, end) =>
  array.subarray(begin, end);

export const set: typeof $int16Array.set = (array, values) =>
  toResult.fromThrows(() => {
    array.set(values);
    return undefined;
  });

export const set_with_offset: typeof $int16Array.set_with_offset = (
  array,
  values,
  offset,
) =>
  toResult.fromThrows(() => {
    array.set(values, offset);
    return undefined;
  });

export const fill: typeof $int16Array.fill = (array, value) =>
  array.fill(value);

export const reverse: typeof $int16Array.reverse = (array) => array.reverse();

export const to_list: typeof $int16Array.to_list = (array) =>
  fromArray(Array.from(array));
