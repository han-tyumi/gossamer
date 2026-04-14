import type * as $set from "$/gossamer/gossamer/set.mjs";
import { fromArray, toArray } from "~/utils/list.ts";

export type Set$<T> = Set<T>;

export const new_: typeof $set.new$ = <T>() => {
  return new Set<T>();
};

export const from_list: typeof $set.from_list = <T>(
  values: Parameters<typeof $set.from_list<T>>[0],
) => {
  return new Set<T>(toArray(values));
};

export const size: typeof $set.size = (set) => {
  return set.size;
};

export const add: typeof $set.add = (set, value) => {
  set.add(value);
  return set;
};

export const has: typeof $set.has = (set, value) => {
  return set.has(value);
};

export const delete_: typeof $set.delete$ = (set, value) => {
  return set.delete(value);
};

export const clear: typeof $set.clear = (set) => {
  set.clear();
  return set;
};

export const values: typeof $set.values = (set) => {
  return fromArray(Array.from(set.values()));
};

export const entries: typeof $set.entries = (set) => {
  return fromArray(Array.from(set.entries()));
};

export const for_each: typeof $set.for_each = (set, callback) => {
  set.forEach((value) => callback(value));
};

export const difference: typeof $set.difference = (set, other) => {
  return set.difference(other);
};

export const intersection: typeof $set.intersection = (set, other) => {
  return set.intersection(other);
};

export const union: typeof $set.union = (set, other) => {
  return set.union(other);
};

export const symmetric_difference: typeof $set.symmetric_difference = (
  set,
  other,
) => {
  return set.symmetricDifference(other);
};

export const is_disjoint_from: typeof $set.is_disjoint_from = (set, other) => {
  return set.isDisjointFrom(other);
};

export const is_subset_of: typeof $set.is_subset_of = (set, other) => {
  return set.isSubsetOf(other);
};

export const is_superset_of: typeof $set.is_superset_of = (set, other) => {
  return set.isSupersetOf(other);
};
