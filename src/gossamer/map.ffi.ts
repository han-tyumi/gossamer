import type * as $map from "$/gossamer/gossamer/map.mjs";
import { toArray } from "~/utils/list.ffi.ts";
import { toResult } from "~/utils/result.ffi.ts";

export type Map$<K, V> = Map<K, V>;

export const new_: typeof $map.new$ = <K, V>() => {
  return new Map<K, V>();
};

export const from_list: typeof $map.from_list = <K, V>(
  entries: Parameters<typeof $map.from_list<K, V>>[0],
) => {
  return new Map<K, V>(toArray(entries));
};

export const size: typeof $map.size = (map) => {
  return map.size;
};

export const get: typeof $map.get = (map, key) => {
  return toResult(map.get(key));
};

export const has: typeof $map.has = (map, key) => {
  return map.has(key);
};

export const set: typeof $map.set = (map, key, value) => {
  map.set(key, value);
  return map;
};

export const delete_: typeof $map.delete$ = (map, key) => {
  map.delete(key);
  return map;
};

export const clear: typeof $map.clear = (map) => {
  map.clear();
  return map;
};

export const keys: typeof $map.keys = (map) => {
  return map.keys();
};

export const values: typeof $map.values = (map) => {
  return map.values();
};

export const entries: typeof $map.entries = (map) => {
  return map.entries();
};

export const for_each: typeof $map.for_each = (map, callback) => {
  map.forEach((value, key) => callback(key, value));
};
