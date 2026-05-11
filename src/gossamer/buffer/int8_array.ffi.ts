import type * as $int8Array from "$/gossamer/gossamer/buffer/int8_array.mjs";
import * as $buffer from "$/gossamer/gossamer/buffer.mjs";
import { Result$Error, Result$Ok } from "$/prelude.mjs";
import {
  checkArrayDetached,
  checkArrayRange,
} from "~/utils/buffer_check.ffi.ts";
import { fromArray, toArray } from "~/utils/list.ffi.ts";
import { indexToResult, toResult } from "~/utils/result.ffi.ts";

export const new_: typeof $int8Array.new$ = () => new Int8Array();

export const from_length: typeof $int8Array.from_length = (length) =>
  new Int8Array(Math.max(0, length));

export const from_list: typeof $int8Array.from_list = (list) =>
  new Int8Array(toArray(list));

export const from_buffer: typeof $int8Array.from_buffer = (buffer) => {
  if (buffer.detached) return Result$Error($buffer.BufferError$Detached());
  return Result$Ok(new Int8Array(buffer));
};

export const from_buffer_range: typeof $int8Array.from_buffer_range = (
  buffer,
  byteOffset,
  length,
) => {
  if (buffer.detached) return Result$Error($buffer.BufferError$Detached());
  if (byteOffset < 0 || byteOffset + length > buffer.byteLength) {
    return Result$Error(
      $buffer.BufferError$OutOfRange(byteOffset + length, buffer.byteLength),
    );
  }
  return Result$Ok(new Int8Array(buffer, byteOffset, length));
};

export const buffer: typeof $int8Array.buffer = (array) =>
  array.buffer as ArrayBuffer;

export const bytes: typeof $int8Array.bytes = (array) =>
  checkArrayDetached(
    array,
    () => new Uint8Array(array.buffer, array.byteOffset, array.byteLength),
  );

export const byte_length: typeof $int8Array.byte_length = (array) =>
  array.byteLength;

export const byte_offset: typeof $int8Array.byte_offset = (array) =>
  array.byteOffset;

export const length: typeof $int8Array.length = (array) => array.length;

export const at: typeof $int8Array.at = (array, index) =>
  toResult(array.at(index));

export const with_: typeof $int8Array.with$ = (array, index, value) =>
  checkArrayRange(
    array,
    index < 0 ? array.length + index : index,
    1,
    () => array.with(index, value),
  );

export const includes: typeof $int8Array.includes = (array, value) =>
  array.includes(value);

export const index_of: typeof $int8Array.index_of = (array, value) =>
  indexToResult(array.indexOf(value));

export const last_index_of: typeof $int8Array.last_index_of = (array, value) =>
  indexToResult(array.lastIndexOf(value));

export const slice: typeof $int8Array.slice = (array) => array.slice();

export const slice_range: typeof $int8Array.slice_range = (
  array,
  start,
  end,
) => array.slice(start, end);

export const subarray: typeof $int8Array.subarray = (array, begin, end) =>
  array.subarray(begin, end);

export const set: typeof $int8Array.set = (array, values) =>
  checkArrayRange(array, 0, values.length, () => {
    array.set(values);
  });

export const set_with_offset: typeof $int8Array.set_with_offset = (
  array,
  values,
  offset,
) =>
  checkArrayRange(array, offset, values.length, () => {
    array.set(values, offset);
  });

export const fill: typeof $int8Array.fill = (array, value) => array.fill(value);

export const reverse: typeof $int8Array.reverse = (array) => array.reverse();

export const to_list: typeof $int8Array.to_list = (array) =>
  fromArray(Array.from(array));
