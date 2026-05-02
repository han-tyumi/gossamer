import type * as $weakMap from "$/gossamer/gossamer/weak_map.mjs";
import { toArray } from "~/utils/list.ffi.ts";
import { toResult } from "~/utils/result.ffi.ts";

export const new_: typeof $weakMap.new$ = () => new WeakMap();

export const from_list: typeof $weakMap.from_list = (entries) => {
  // @ts-expect-error: K is unconstrained Gleam-side; the constructor
  // throws TypeError on invalid keys, surfaced via toResult.fromThrows.
  return toResult.fromThrows(() => new WeakMap(toArray(entries)));
};

export const get: typeof $weakMap.get = (map, key) => {
  // @ts-expect-error: K is unconstrained Gleam-side; .get returns
  // undefined for invalid keys, mapped to Error(Nil) by toResult.
  return toResult(map.get(key));
};

export const has: typeof $weakMap.has = (map, key) => {
  // @ts-expect-error: K is unconstrained Gleam-side; .has returns
  // false for invalid keys.
  return map.has(key);
};

export const set: typeof $weakMap.set = (map, key, value) => {
  return toResult.fromThrows(() => {
    // @ts-expect-error: K is unconstrained Gleam-side; .set throws
    // TypeError on invalid keys, surfaced via toResult.fromThrows.
    map.set(key, value);
    return map;
  });
};

export const delete_: typeof $weakMap.delete$ = (map, key) => {
  // @ts-expect-error: K is unconstrained Gleam-side; .delete returns
  // false for invalid keys (no-op).
  map.delete(key);
  return map;
};
