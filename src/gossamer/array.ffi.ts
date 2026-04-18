import * as $order from "$/gleam_stdlib/gleam/order.mjs";
import type { Order$ } from "$/gleam_stdlib/gleam/order.mjs";
import type * as $array from "$/gossamer/gossamer/array.mjs";
import { fromArray, toArray } from "~/utils/list.ffi.ts";
import { indexToResult, toResult } from "~/utils/result.ffi.ts";

export type Array$<T> = Array<T>;

function toCompareFn<T>(
  compare: (a: T, b: T) => Order$,
): (a: T, b: T) => number {
  return (a, b) => {
    const result = compare(a, b);
    if ($order.Order$isLt(result)) return -1;
    if ($order.Order$isGt(result)) return 1;
    return 0;
  };
}

export const new_: typeof $array.new$ = () => [];

export const from_list: typeof $array.from_list = (list) => toArray(list);

export const from_list_mapped: typeof $array.from_list_mapped = (
  list,
  mapper,
) => toArray(list).map((value) => mapper(value));

export const length: typeof $array.length = (array) => array.length;

export const at: typeof $array.at = (array, index) => toResult(array.at(index));

export const includes: typeof $array.includes = (array, value) =>
  array.includes(value);

export const includes_from: typeof $array.includes_from = (
  array,
  value,
  index,
) => array.includes(value, index);

export const index_of: typeof $array.index_of = (array, value) =>
  indexToResult(array.indexOf(value));

export const index_of_from: typeof $array.index_of_from = (
  array,
  value,
  index,
) => indexToResult(array.indexOf(value, index));

export const last_index_of: typeof $array.last_index_of = (array, value) =>
  indexToResult(array.lastIndexOf(value));

export const last_index_of_from: typeof $array.last_index_of_from = (
  array,
  value,
  index,
) => indexToResult(array.lastIndexOf(value, index));

export const find: typeof $array.find = (array, predicate) =>
  toResult(array.find((value) => predicate(value)));

export const index_find: typeof $array.index_find = (array, predicate) =>
  toResult(array.find((value, index) => predicate(value, index)));

export const find_index: typeof $array.find_index = (array, predicate) =>
  indexToResult(array.findIndex((value) => predicate(value)));

export const index_find_index: typeof $array.index_find_index = (
  array,
  predicate,
) => indexToResult(array.findIndex((value, index) => predicate(value, index)));

export const find_last: typeof $array.find_last = (array, predicate) =>
  toResult(array.findLast((value) => predicate(value)));

export const index_find_last: typeof $array.index_find_last = (
  array,
  predicate,
) => toResult(array.findLast((value, index) => predicate(value, index)));

export const find_last_index: typeof $array.find_last_index = (
  array,
  predicate,
) => indexToResult(array.findLastIndex((value) => predicate(value)));

export const index_find_last_index: typeof $array.index_find_last_index = (
  array,
  predicate,
) =>
  indexToResult(
    array.findLastIndex((value, index) => predicate(value, index)),
  );

export const every: typeof $array.every = (array, predicate) =>
  array.every((value) => predicate(value));

export const index_every: typeof $array.index_every = (array, predicate) =>
  array.every((value, index) => predicate(value, index));

export const some: typeof $array.some = (array, predicate) =>
  array.some((value) => predicate(value));

export const index_some: typeof $array.index_some = (array, predicate) =>
  array.some((value, index) => predicate(value, index));

export const slice: typeof $array.slice = (array) => array.slice();

export const slice_from: typeof $array.slice_from = (array, start) =>
  array.slice(start);

export const slice_range: typeof $array.slice_range = (array, start, end) =>
  array.slice(start, end);

export const map: typeof $array.map = (array, callback) =>
  array.map((value) => callback(value));

export const index_map: typeof $array.index_map = (array, callback) =>
  array.map((value, index) => callback(value, index));

export const filter: typeof $array.filter = (array, predicate) =>
  array.filter((value) => predicate(value));

export const index_filter: typeof $array.index_filter = (array, predicate) =>
  array.filter((value, index) => predicate(value, index));

export const flat: typeof $array.flat = (array) => array.flat(1);

export const flat_map: typeof $array.flat_map = (array, callback) =>
  array.flatMap((value) => callback(value));

export const concat: typeof $array.concat = (array, other) =>
  array.concat(other);

export const to_reversed: typeof $array.to_reversed = (array) =>
  array.toReversed();

export const to_sorted: typeof $array.to_sorted = (array, compare) =>
  array.toSorted(toCompareFn(compare));

export const with_: typeof $array.with$ = (array, index, value) =>
  array.with(index, value);

export const to_spliced: typeof $array.to_spliced = (array, start, count) =>
  array.toSpliced(start, count);

export const to_spliced_with: typeof $array.to_spliced_with = (
  array,
  start,
  count,
  items,
) => array.toSpliced(start, count, ...toArray(items));

export const push: typeof $array.push = (array, value) => {
  array.push(value);
  return array;
};

export const unshift: typeof $array.unshift = (array, value) => {
  array.unshift(value);
  return array;
};

export const reverse: typeof $array.reverse = (array) => array.reverse();

export const sort: typeof $array.sort = (array, compare) =>
  array.sort(toCompareFn(compare));

export const fill: typeof $array.fill = (array, value) => array.fill(value);

export const fill_range: typeof $array.fill_range = (
  array,
  value,
  start,
  end,
) => array.fill(value, start, end);

export const copy_within: typeof $array.copy_within = (array, target, start) =>
  array.copyWithin(target, start);

export const copy_within_range: typeof $array.copy_within_range = (
  array,
  target,
  start,
  end,
) => array.copyWithin(target, start, end);

export const pop: typeof $array.pop = (array) => toResult(array.pop());

export const shift: typeof $array.shift = (array) => toResult(array.shift());

export const splice: typeof $array.splice = (array, start, count) =>
  array.splice(start, count);

export const splice_with: typeof $array.splice_with = (
  array,
  start,
  count,
  items,
) => array.splice(start, count, ...toArray(items));

export const for_each: typeof $array.for_each = (array, callback) => {
  array.forEach((value) => callback(value));
};

export const index_for_each: typeof $array.index_for_each = (
  array,
  callback,
) => {
  array.forEach((value, index) => callback(value, index));
};

export const reduce: typeof $array.reduce = (array, initial, callback) =>
  array.reduce((acc, value) => callback(acc, value), initial);

export const reduce_right: typeof $array.reduce_right = (
  array,
  initial,
  callback,
) => array.reduceRight((acc, value) => callback(acc, value), initial);

export const index_reduce: typeof $array.index_reduce = (
  array,
  initial,
  callback,
) => array.reduce((acc, value, index) => callback(acc, value, index), initial);

export const index_reduce_right: typeof $array.index_reduce_right = (
  array,
  initial,
  callback,
) =>
  array.reduceRight(
    (acc, value, index) => callback(acc, value, index),
    initial,
  );

export const join: typeof $array.join = (array, separator) =>
  array.join(separator);

export const to_string: typeof $array.to_string = (array) => array.toString();

export const to_list: typeof $array.to_list = (array) => fromArray(array);

export const keys: typeof $array.keys = (array) => array.keys();

export const values: typeof $array.values = (array) => array.values();

export const entries: typeof $array.entries = (array) => array.entries();
