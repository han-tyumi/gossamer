import {
  fold as gleam_set_fold,
  from_list as gleam_set_from_list,
} from "$/gleam_stdlib/gleam/set.mjs";
import type * as $set from "$/gossamer/gossamer/set.mjs";
import { fromArray, toArray } from "~/utils/list.ffi.ts";

export const new_: typeof $set.new$ = <T>() => {
  return new Set<T>();
};

export const from_list: typeof $set.from_list = <T>(
  values: Parameters<typeof $set.from_list<T>>[0],
) => {
  return new Set<T>(toArray(values));
};

export const from_set: typeof $set.from_set = <T>(
  set: Parameters<typeof $set.from_set<T>>[0],
) => {
  const jsSet = new Set<T>();
  gleam_set_fold(set, undefined, (_acc: unknown, value: T) => {
    jsSet.add(value);
    return undefined;
  });
  return jsSet;
};

export const to_set: typeof $set.to_set = (set) => {
  return gleam_set_from_list(fromArray(Array.from(set.values())));
};
