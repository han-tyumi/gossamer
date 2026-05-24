import {
  fold as dict_fold,
  from_list as dict_from_list,
} from "$/gleam_stdlib/gleam/dict.mjs";
import type * as $map from "$/gossamer/gossamer/map.mjs";
import { jsIteratorAsYielder } from "~/utils/iteration.ffi.ts";
import { fromArray, toArray } from "~/utils/list.ffi.ts";
import { toResult } from "~/utils/result.ffi.ts";

export const new_: typeof $map.new$ = <K, V>() => {
  return new Map<K, V>();
};

export const from_list: typeof $map.from_list = <K, V>(
  entries: Parameters<typeof $map.from_list<K, V>>[0],
) => {
  return new Map<K, V>(toArray(entries));
};

export const from_dict: typeof $map.from_dict = <K, V>(
  dict: Parameters<typeof $map.from_dict<K, V>>[0],
) => {
  const map = new Map<K, V>();
  dict_fold(dict, undefined, (_acc: unknown, key: K, value: V) => {
    map.set(key, value);
    return undefined;
  });
  return map;
};

export const to_dict: typeof $map.to_dict = (map) => {
  return dict_from_list(fromArray(Array.from(map.entries())));
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

export const keys: typeof $map.keys = (map) => {
  return jsIteratorAsYielder(map.keys());
};

export const values: typeof $map.values = (map) => {
  return jsIteratorAsYielder(map.values());
};

export const entries: typeof $map.entries = (map) => {
  return jsIteratorAsYielder(map.entries());
};
