import type * as $uint8Array from "$/gossamer/gossamer/uint8_array.mjs";
import * as $order from "$/gleam_stdlib/gleam/order.mjs";
import type { Order$ } from "$/gleam_stdlib/gleam/order.mjs";
import { fromArray, toArray } from "~/utils/list.ffi.ts";
import { indexToResult, toResult } from "~/utils/result.ffi.ts";

export type Uint8Array$ = Uint8Array;

export const new_: typeof $uint8Array.new$ = () => {
  return new Uint8Array();
};

export const from_length: typeof $uint8Array.from_length = (length) => {
  return toResult.fromThrows(() => new Uint8Array(length));
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

export const set: typeof $uint8Array.set = (array, values) => {
  return toResult.fromThrows(() => {
    array.set(values);
    return undefined;
  });
};

export const set_with_offset: typeof $uint8Array.set_with_offset = (
  array,
  values,
  offset,
) => {
  return toResult.fromThrows(() => {
    array.set(values, offset);
    return undefined;
  });
};

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

export const with_: typeof $uint8Array.with$ = (array, index, value) => {
  return toResult.fromThrows(() => array.with(index, value));
};

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
  return array.keys();
};

export const values: typeof $uint8Array.values = (array) => {
  return array.values();
};

export const entries: typeof $uint8Array.entries = (array) => {
  return array.entries();
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

export const from_base64: typeof $uint8Array.from_base64 = (string) => {
  return toResult.fromThrows(() => Uint8Array.fromBase64(string));
};

export const from_hex: typeof $uint8Array.from_hex = (string) => {
  return toResult.fromThrows(() => Uint8Array.fromHex(string));
};

export const set_from_base64: typeof $uint8Array.set_from_base64 = (
  array,
  string,
) => {
  return toResult.fromThrows(() => {
    const result = array.setFromBase64(string);
    return [result.read, result.written];
  });
};

export const set_from_hex: typeof $uint8Array.set_from_hex = (
  array,
  string,
) => {
  return toResult.fromThrows(() => {
    const result = array.setFromHex(string);
    return [result.read, result.written];
  });
};
