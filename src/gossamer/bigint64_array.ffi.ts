import type * as $bigInt64Array from "$/gossamer/gossamer/bigint64_array.mjs";
import { fromArray, toArray } from "~/utils/list.ffi.ts";
import { indexToResult, toResult } from "~/utils/result.ffi.ts";

export const new_: typeof $bigInt64Array.new$ = () => new BigInt64Array();

export const from_length: typeof $bigInt64Array.from_length = (length) =>
  toResult.fromThrows(() => new BigInt64Array(length));

export const from_list: typeof $bigInt64Array.from_list = (list) =>
  new BigInt64Array(toArray(list));

export const from_buffer: typeof $bigInt64Array.from_buffer = (buffer) =>
  toResult.fromThrows(() => new BigInt64Array(buffer));

export const buffer: typeof $bigInt64Array.buffer = (array) =>
  array.buffer as ArrayBuffer;

export const byte_length: typeof $bigInt64Array.byte_length = (array) =>
  array.byteLength;

export const byte_offset: typeof $bigInt64Array.byte_offset = (array) =>
  array.byteOffset;

export const length: typeof $bigInt64Array.length = (array) => array.length;

export const at: typeof $bigInt64Array.at = (array, index) =>
  toResult(array.at(index));

export const with_: typeof $bigInt64Array.with$ = (array, index, value) =>
  toResult.fromThrows(() => array.with(index, value));

export const includes: typeof $bigInt64Array.includes = (array, value) =>
  array.includes(value);

export const index_of: typeof $bigInt64Array.index_of = (array, value) =>
  indexToResult(array.indexOf(value));

export const last_index_of: typeof $bigInt64Array.last_index_of = (
  array,
  value,
) => indexToResult(array.lastIndexOf(value));

export const slice: typeof $bigInt64Array.slice = (array) => array.slice();

export const slice_range: typeof $bigInt64Array.slice_range = (
  array,
  start,
  end,
) => array.slice(start, end);

export const subarray: typeof $bigInt64Array.subarray = (array, begin, end) =>
  array.subarray(begin, end);

export const set: typeof $bigInt64Array.set = (array, values) =>
  toResult.fromThrows(() => {
    array.set(values);
    return undefined;
  });

export const set_with_offset: typeof $bigInt64Array.set_with_offset = (
  array,
  values,
  offset,
) =>
  toResult.fromThrows(() => {
    array.set(values, offset);
    return undefined;
  });

export const fill: typeof $bigInt64Array.fill = (array, value) =>
  array.fill(value);

export const reverse: typeof $bigInt64Array.reverse = (array) =>
  array.reverse();

export const to_list: typeof $bigInt64Array.to_list = (array) =>
  fromArray(Array.from(array));
