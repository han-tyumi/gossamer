import {
  fold as dict_fold,
  from_list as dict_from_list,
} from "$/gleam_stdlib/gleam/dict.mjs";
import type * as $map from "$/gossamer/gossamer/map.mjs";
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
