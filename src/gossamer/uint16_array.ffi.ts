import type * as $uint16Array from "$/gossamer/gossamer/uint16_array.mjs";
import { fromArray, toArray } from "~/utils/list.ffi.ts";
import { indexToResult, toResult } from "~/utils/result.ffi.ts";

export const new_: typeof $uint16Array.new$ = () => new Uint16Array();

export const from_length: typeof $uint16Array.from_length = (length) =>
  toResult.fromThrows(() => new Uint16Array(length));

export const from_list: typeof $uint16Array.from_list = (list) =>
  new Uint16Array(toArray(list));

export const from_buffer: typeof $uint16Array.from_buffer = (buffer) =>
  toResult.fromThrows(() => new Uint16Array(buffer));

export const from_buffer_range: typeof $uint16Array.from_buffer_range = (
  buffer,
  byteOffset,
  length,
) => toResult.fromThrows(() => new Uint16Array(buffer, byteOffset, length));

export const buffer: typeof $uint16Array.buffer = (array) =>
  array.buffer as ArrayBuffer;

export const byte_length: typeof $uint16Array.byte_length = (array) =>
  array.byteLength;

export const byte_offset: typeof $uint16Array.byte_offset = (array) =>
  array.byteOffset;

export const length: typeof $uint16Array.length = (array) => array.length;

export const at: typeof $uint16Array.at = (array, index) =>
  toResult(array.at(index));

export const with_: typeof $uint16Array.with$ = (array, index, value) =>
  toResult.fromThrows(() => array.with(index, value));

export const includes: typeof $uint16Array.includes = (array, value) =>
  array.includes(value);

export const index_of: typeof $uint16Array.index_of = (array, value) =>
  indexToResult(array.indexOf(value));

export const last_index_of: typeof $uint16Array.last_index_of = (
  array,
  value,
) => indexToResult(array.lastIndexOf(value));

export const slice: typeof $uint16Array.slice = (array) => array.slice();

export const slice_range: typeof $uint16Array.slice_range = (
  array,
  start,
  end,
) => array.slice(start, end);

export const subarray: typeof $uint16Array.subarray = (array, begin, end) =>
  array.subarray(begin, end);

export const set: typeof $uint16Array.set = (array, values) =>
  toResult.fromThrows(() => {
    array.set(values);
    return undefined;
  });

export const set_with_offset: typeof $uint16Array.set_with_offset = (
  array,
  values,
  offset,
) =>
  toResult.fromThrows(() => {
    array.set(values, offset);
    return undefined;
  });

export const fill: typeof $uint16Array.fill = (array, value) =>
  array.fill(value);

export const reverse: typeof $uint16Array.reverse = (array) => array.reverse();

export const to_list: typeof $uint16Array.to_list = (array) =>
  fromArray(Array.from(array));
