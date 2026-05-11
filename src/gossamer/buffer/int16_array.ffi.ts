import type * as $int16Array from "$/gossamer/gossamer/buffer/int16_array.mjs";
import {
  checkArrayDetached,
  checkArrayRange,
  checkBufferAligned,
  checkBufferRangeAligned,
} from "~/utils/buffer_check.ffi.ts";
import { fromArray, toArray } from "~/utils/list.ffi.ts";
import { indexToResult, toResult } from "~/utils/result.ffi.ts";

export const new_: typeof $int16Array.new$ = () => new Int16Array();

export const from_length: typeof $int16Array.from_length = (length) =>
  new Int16Array(Math.max(0, length));

export const from_list: typeof $int16Array.from_list = (list) =>
  new Int16Array(toArray(list));

export const from_buffer: typeof $int16Array.from_buffer = (buffer) =>
  checkBufferAligned(buffer, 2, () => new Int16Array(buffer));

export const from_buffer_range: typeof $int16Array.from_buffer_range = (
  buffer,
  byteOffset,
  length,
) =>
  checkBufferRangeAligned(
    buffer,
    byteOffset,
    length,
    2,
    () => new Int16Array(buffer, byteOffset, length),
  );

export const buffer: typeof $int16Array.buffer = (array) =>
  array.buffer as ArrayBuffer;

export const bytes: typeof $int16Array.bytes = (array) =>
  checkArrayDetached(
    array,
    () => new Uint8Array(array.buffer, array.byteOffset, array.byteLength),
  );

export const byte_length: typeof $int16Array.byte_length = (array) =>
  array.byteLength;

export const byte_offset: typeof $int16Array.byte_offset = (array) =>
  array.byteOffset;

export const length: typeof $int16Array.length = (array) => array.length;

export const at: typeof $int16Array.at = (array, index) =>
  toResult(array.at(index));

export const with_: typeof $int16Array.with$ = (array, index, value) =>
  checkArrayRange(
    array,
    index < 0 ? array.length + index : index,
    1,
    () => array.with(index, value),
  );

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
  checkArrayRange(array, 0, values.length, () => {
    array.set(values);
  });

export const set_with_offset: typeof $int16Array.set_with_offset = (
  array,
  values,
  offset,
) =>
  checkArrayRange(array, offset, values.length, () => {
    array.set(values, offset);
  });

export const fill: typeof $int16Array.fill = (array, value) =>
  array.fill(value);

export const reverse: typeof $int16Array.reverse = (array) => array.reverse();

export const to_list: typeof $int16Array.to_list = (array) =>
  fromArray(Array.from(array));
