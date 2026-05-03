import type * as $int32Array from "$/gossamer/gossamer/int32_array.mjs";
import { fromArray, toArray } from "~/utils/list.ffi.ts";
import { indexToResult, toResult } from "~/utils/result.ffi.ts";

export const new_: typeof $int32Array.new$ = () => new Int32Array();

export const from_length: typeof $int32Array.from_length = (length) =>
  toResult.fromThrows(() => new Int32Array(length));

export const from_list: typeof $int32Array.from_list = (list) =>
  new Int32Array(toArray(list));

export const from_buffer: typeof $int32Array.from_buffer = (buffer) =>
  toResult.fromThrows(() => new Int32Array(buffer));

export const buffer: typeof $int32Array.buffer = (array) =>
  array.buffer as ArrayBuffer;

export const byte_length: typeof $int32Array.byte_length = (array) =>
  array.byteLength;

export const byte_offset: typeof $int32Array.byte_offset = (array) =>
  array.byteOffset;

export const length: typeof $int32Array.length = (array) => array.length;

export const at: typeof $int32Array.at = (array, index) =>
  toResult(array.at(index));

export const with_: typeof $int32Array.with$ = (array, index, value) =>
  toResult.fromThrows(() => array.with(index, value));

export const includes: typeof $int32Array.includes = (array, value) =>
  array.includes(value);

export const index_of: typeof $int32Array.index_of = (array, value) =>
  indexToResult(array.indexOf(value));

export const last_index_of: typeof $int32Array.last_index_of = (array, value) =>
  indexToResult(array.lastIndexOf(value));

export const slice: typeof $int32Array.slice = (array) => array.slice();

export const slice_range: typeof $int32Array.slice_range = (
  array,
  start,
  end,
) => array.slice(start, end);

export const subarray: typeof $int32Array.subarray = (array, begin, end) =>
  array.subarray(begin, end);

export const set: typeof $int32Array.set = (array, values) =>
  toResult.fromThrows(() => {
    array.set(values);
    return undefined;
  });

export const set_with_offset: typeof $int32Array.set_with_offset = (
  array,
  values,
  offset,
) =>
  toResult.fromThrows(() => {
    array.set(values, offset);
    return undefined;
  });

export const fill: typeof $int32Array.fill = (array, value) =>
  array.fill(value);

export const reverse: typeof $int32Array.reverse = (array) => array.reverse();

export const to_list: typeof $int32Array.to_list = (array) =>
  fromArray(Array.from(array));
