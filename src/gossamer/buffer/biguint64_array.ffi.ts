import type * as $bigUint64Array from "$/gossamer/gossamer/buffer/biguint64_array.mjs";
import {
  checkArrayRange,
  checkBufferAligned,
  checkBufferRangeAligned,
} from "~/utils/buffer_check.ffi.ts";
import { fromArray, toArray } from "~/utils/list.ffi.ts";
import { indexToResult, toResult } from "~/utils/result.ffi.ts";

export const new_: typeof $bigUint64Array.new$ = () => new BigUint64Array();

export const from_length: typeof $bigUint64Array.from_length = (length) =>
  new BigUint64Array(Math.max(0, length));

export const from_list: typeof $bigUint64Array.from_list = (list) =>
  new BigUint64Array(toArray(list));

export const from_buffer: typeof $bigUint64Array.from_buffer = (buffer) =>
  checkBufferAligned(buffer, 8, () => new BigUint64Array(buffer));

export const from_buffer_range: typeof $bigUint64Array.from_buffer_range = (
  buffer,
  byteOffset,
  length,
) =>
  checkBufferRangeAligned(
    buffer,
    byteOffset,
    length,
    8,
    () => new BigUint64Array(buffer, byteOffset, length),
  );

export const buffer: typeof $bigUint64Array.buffer = (array) =>
  array.buffer as ArrayBuffer;

export const bytes: typeof $bigUint64Array.bytes = (array) =>
  new Uint8Array(array.buffer, array.byteOffset, array.byteLength);

export const byte_length: typeof $bigUint64Array.byte_length = (array) =>
  array.byteLength;

export const byte_offset: typeof $bigUint64Array.byte_offset = (array) =>
  array.byteOffset;

export const length: typeof $bigUint64Array.length = (array) => array.length;

export const at: typeof $bigUint64Array.at = (array, index) =>
  toResult(array.at(index));

export const with_: typeof $bigUint64Array.with$ = (array, index, value) =>
  checkArrayRange(
    array,
    index < 0 ? array.length + index : index,
    1,
    () => array.with(index, value),
  );

export const includes: typeof $bigUint64Array.includes = (array, value) =>
  array.includes(value);

export const index_of: typeof $bigUint64Array.index_of = (array, value) =>
  indexToResult(array.indexOf(value));

export const last_index_of: typeof $bigUint64Array.last_index_of = (
  array,
  value,
) => indexToResult(array.lastIndexOf(value));

export const slice: typeof $bigUint64Array.slice = (array) => array.slice();

export const slice_range: typeof $bigUint64Array.slice_range = (
  array,
  start,
  end,
) => array.slice(start, end);

export const subarray: typeof $bigUint64Array.subarray = (array, begin, end) =>
  array.subarray(begin, end);

export const set: typeof $bigUint64Array.set = (array, values) =>
  checkArrayRange(array, 0, values.length, () => {
    array.set(values);
  });

export const set_with_offset: typeof $bigUint64Array.set_with_offset = (
  array,
  values,
  offset,
) =>
  checkArrayRange(array, offset, values.length, () => {
    array.set(values, offset);
  });

export const fill: typeof $bigUint64Array.fill = (array, value) =>
  array.fill(value);

export const reverse: typeof $bigUint64Array.reverse = (array) =>
  array.reverse();

export const to_list: typeof $bigUint64Array.to_list = (array) =>
  fromArray(Array.from(array));
