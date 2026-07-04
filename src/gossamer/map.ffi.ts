import {
  fold as dict_fold,
  from_list as dict_from_list,
} from "$/gleam_stdlib/gleam/dict.mjs";
import { from_list as yielder_from_list } from "$/gleam_yielder/gleam/yielder.mjs";
import type * as $map from "$/gossamer/gossamer/map.mjs";
import { Result$Error, Result$Ok } from "$/prelude.mjs";
import { fromArray, toArray } from "~/utils/list.ffi.ts";

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
  // Gate on presence rather than value shape: a stored Gleam Nil is
  // undefined at runtime and must still report Ok.
  if (!map.has(key)) return Result$Error(undefined);
  return Result$Ok(map.get(key));
};

export const has: typeof $map.has = (map, key) => {
  return map.has(key);
};

// Snapshot into a list-backed Yielder: wrapping the live JS iterator
// would drain it on first traversal, making the Yielder one-shot.

export const keys: typeof $map.keys = (map) => {
  return yielder_from_list(fromArray(Array.from(map.keys())));
};

export const values: typeof $map.values = (map) => {
  return yielder_from_list(fromArray(Array.from(map.values())));
};

export const entries: typeof $map.entries = (map) => {
  return yielder_from_list(fromArray(Array.from(map.entries())));
};
