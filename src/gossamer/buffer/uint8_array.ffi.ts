import * as $uint8Array from "$/gossamer/gossamer/buffer/uint8_array.mjs";
import * as $buffer from "$/gossamer/gossamer/buffer.mjs";
import * as $order from "$/gleam_stdlib/gleam/order.mjs";
import type { Order$ } from "$/gleam_stdlib/gleam/order.mjs";
import { BitArray$BitArray, Result$Error, Result$Ok } from "$/prelude.mjs";
import { jsIteratorAsYielder } from "~/gossamer/iteration.ffi.ts";
import { toUint8Array } from "~/utils/bit_array.ffi.ts";
import { checkArrayRange } from "~/utils/buffer_check.ffi.ts";
import { fromArray, toArray } from "~/utils/list.ffi.ts";
import { indexToResult, toResult } from "~/utils/result.ffi.ts";

export const new_: typeof $uint8Array.new$ = () => {
  return new Uint8Array();
};

export const from_length: typeof $uint8Array.from_length = (length) => {
  return new Uint8Array(Math.max(0, length));
};

export const from_list: typeof $uint8Array.from_list = (list) => {
  return new Uint8Array(toArray(list));
};

export const from_list_mapped: typeof $uint8Array.from_list_mapped = (
  list,
  mapper,
) => {
  return Uint8Array.from(toArray(list), mapper);
};

export const from_buffer: typeof $uint8Array.from_buffer = (buffer) => {
  return new Uint8Array(buffer);
};

export const from_buffer_range: typeof $uint8Array.from_buffer_range = (
  buffer,
  byteOffset,
  length,
) => {
  if (byteOffset < 0 || byteOffset + length > buffer.byteLength) {
    return Result$Error(
      $buffer.BufferError$OutOfRange(byteOffset + length, buffer.byteLength),
    );
  }
  return Result$Ok(new Uint8Array(buffer, byteOffset, length));
};

export const buffer: typeof $uint8Array.buffer = (array) => {
  return array.buffer as ArrayBuffer;
};

export const byte_length: typeof $uint8Array.byte_length = (array) => {
  return array.byteLength;
};

export const byte_offset: typeof $uint8Array.byte_offset = (array) => {
  return array.byteOffset;
};

export const length: typeof $uint8Array.length = (array) => {
  return array.length;
};

export const at: typeof $uint8Array.at = (array, index) => {
  return toResult(array.at(index));
};

export const includes: typeof $uint8Array.includes = (array, value) => {
  return array.includes(value);
};

export const includes_from: typeof $uint8Array.includes_from = (
  array,
  value,
  index,
) => {
  return array.includes(value, index);
};

export const index_of: typeof $uint8Array.index_of = (array, value) => {
  return indexToResult(array.indexOf(value));
};

export const index_of_from: typeof $uint8Array.index_of_from = (
  array,
  value,
  index,
) => {
  return indexToResult(array.indexOf(value, index));
};

export const last_index_of: typeof $uint8Array.last_index_of = (
  array,
  value,
) => {
  return indexToResult(array.lastIndexOf(value));
};

export const last_index_of_from: typeof $uint8Array.last_index_of_from = (
  array,
  value,
  index,
) => {
  return indexToResult(array.lastIndexOf(value, index));
};

export const slice: typeof $uint8Array.slice = (array) => {
  return array.slice();
};

export const slice_from: typeof $uint8Array.slice_from = (array, start) => {
  return array.slice(start);
};

export const slice_range: typeof $uint8Array.slice_range = (
  array,
  start,
  end,
) => {
  return array.slice(start, end);
};

export const subarray: typeof $uint8Array.subarray = (array, begin, end) => {
  return array.subarray(begin, end);
};

export const set: typeof $uint8Array.set = (array, values) =>
  checkArrayRange(array, 0, values.length, () => {
    array.set(values);
  });

export const set_with_offset: typeof $uint8Array.set_with_offset = (
  array,
  values,
  offset,
) =>
  checkArrayRange(array, offset, values.length, () => {
    array.set(values, offset);
  });

export const copy_within: typeof $uint8Array.copy_within = (
  array,
  target,
  start,
) => {
  return array.copyWithin(target, start);
};

export const copy_within_range: typeof $uint8Array.copy_within_range = (
  array,
  target,
  start,
  end,
) => {
  return array.copyWithin(target, start, end);
};

export const fill: typeof $uint8Array.fill = (array, value) => {
  return array.fill(value);
};

export const fill_range: typeof $uint8Array.fill_range = (
  array,
  value,
  start,
  end,
) => {
  return array.fill(value, start, end);
};

export const reverse: typeof $uint8Array.reverse = (array) => {
  return array.reverse();
};

export const with_: typeof $uint8Array.with$ = (array, index, value) =>
  checkArrayRange(
    array,
    index < 0 ? array.length + index : index,
    1,
    () => array.with(index, value),
  );

export const join: typeof $uint8Array.join = (array, separator) => {
  return array.join(separator);
};

export const every: typeof $uint8Array.every = (array, predicate) => {
  return array.every((value) => predicate(value));
};

export const index_every: typeof $uint8Array.index_every = (
  array,
  predicate,
) => {
  return array.every((value, index) => predicate(value, index));
};

export const some: typeof $uint8Array.some = (array, predicate) => {
  return array.some((value) => predicate(value));
};

export const index_some: typeof $uint8Array.index_some = (array, predicate) => {
  return array.some((value, index) => predicate(value, index));
};

export const find: typeof $uint8Array.find = (array, predicate) => {
  return toResult(array.find((value) => predicate(value)));
};

export const index_find: typeof $uint8Array.index_find = (array, predicate) => {
  return toResult(array.find((value, index) => predicate(value, index)));
};

export const find_index: typeof $uint8Array.find_index = (array, predicate) => {
  return indexToResult(array.findIndex((value) => predicate(value)));
};

export const index_find_index: typeof $uint8Array.index_find_index = (
  array,
  predicate,
) => {
  return indexToResult(
    array.findIndex((value, index) => predicate(value, index)),
  );
};

export const find_last: typeof $uint8Array.find_last = (array, predicate) => {
  return toResult(array.findLast((value) => predicate(value)));
};

export const index_find_last: typeof $uint8Array.index_find_last = (
  array,
  predicate,
) => {
  return toResult(array.findLast((value, index) => predicate(value, index)));
};

export const find_last_index: typeof $uint8Array.find_last_index = (
  array,
  predicate,
) => {
  return indexToResult(array.findLastIndex((value) => predicate(value)));
};

export const index_find_last_index: typeof $uint8Array.index_find_last_index = (
  array,
  predicate,
) => {
  return indexToResult(
    array.findLastIndex((value, index) => predicate(value, index)),
  );
};

export const filter: typeof $uint8Array.filter = (array, predicate) => {
  return array.filter((value) => predicate(value));
};

export const index_filter: typeof $uint8Array.index_filter = (
  array,
  predicate,
) => {
  return array.filter((value, index) => predicate(value, index));
};

export const map: typeof $uint8Array.map = (array, callback) => {
  return array.map((value) => callback(value));
};

export const index_map: typeof $uint8Array.index_map = (array, callback) => {
  return array.map((value, index) => callback(value, index));
};

export const for_each: typeof $uint8Array.for_each = (array, callback) => {
  array.forEach((value) => callback(value));
};

export const index_for_each: typeof $uint8Array.index_for_each = (
  array,
  callback,
) => {
  array.forEach((value, index) => callback(value, index));
};

function toCompareFn(
  compare: (a: number, b: number) => Order$,
): (a: number, b: number) => number {
  return (a, b) => {
    const result = compare(a, b);
    if ($order.Order$isLt(result)) return -1;
    if ($order.Order$isGt(result)) return 1;
    return 0;
  };
}

export const sort: typeof $uint8Array.sort = (array, compare) => {
  return array.sort(toCompareFn(compare));
};

export const to_sorted: typeof $uint8Array.to_sorted = (array, compare) => {
  return array.toSorted(toCompareFn(compare));
};

export const to_reversed: typeof $uint8Array.to_reversed = (array) => {
  return array.toReversed();
};

export const reduce: typeof $uint8Array.reduce = (array, initial, callback) => {
  return array.reduce(
    (acc, value) => callback(acc, value),
    initial,
  );
};

export const reduce_right: typeof $uint8Array.reduce_right = (
  array,
  initial,
  callback,
) => {
  return array.reduceRight(
    (acc, value) => callback(acc, value),
    initial,
  );
};

export const index_reduce: typeof $uint8Array.index_reduce = (
  array,
  initial,
  callback,
) => {
  return array.reduce(
    (acc, value, index) => callback(acc, value, index),
    initial,
  );
};

export const index_reduce_right: typeof $uint8Array.index_reduce_right = (
  array,
  initial,
  callback,
) => {
  return array.reduceRight(
    (acc, value, index) => callback(acc, value, index),
    initial,
  );
};

export const keys: typeof $uint8Array.keys = (array) => {
  return jsIteratorAsYielder(array.keys());
};

export const values: typeof $uint8Array.values = (array) => {
  return jsIteratorAsYielder(array.values());
};

export const entries: typeof $uint8Array.entries = (array) => {
  return jsIteratorAsYielder(array.entries());
};

export const to_list: typeof $uint8Array.to_list = (array) => {
  return fromArray(Array.from(array));
};

export const to_base64: typeof $uint8Array.to_base64 = (array) => {
  return array.toBase64();
};

export const to_hex: typeof $uint8Array.to_hex = (array) => {
  return array.toHex();
};

function invalidEncoding(err: unknown) {
  const message = err instanceof Error ? err.message : String(err);
  return Result$Error($uint8Array.EncodingError$InvalidEncoding(message));
}

export const from_base64: typeof $uint8Array.from_base64 = (string) => {
  try {
    return Result$Ok(Uint8Array.fromBase64(string));
  } catch (err) {
    return invalidEncoding(err);
  }
};

export const from_hex: typeof $uint8Array.from_hex = (string) => {
  try {
    return Result$Ok(Uint8Array.fromHex(string));
  } catch (err) {
    return invalidEncoding(err);
  }
};

export const from_bit_array: typeof $uint8Array.from_bit_array = toUint8Array;

export const to_bit_array: typeof $uint8Array.to_bit_array = (array) => {
  return BitArray$BitArray(array);
};

export const set_from_base64: typeof $uint8Array.set_from_base64 = (
  array,
  string,
) => {
  try {
    const result = array.setFromBase64(string);
    return Result$Ok([result.read, result.written]);
  } catch (err) {
    return invalidEncoding(err);
  }
};

export const set_from_hex: typeof $uint8Array.set_from_hex = (
  array,
  string,
) => {
  try {
    const result = array.setFromHex(string);
    return Result$Ok([result.read, result.written]);
  } catch (err) {
    return invalidEncoding(err);
  }
};
