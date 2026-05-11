import type * as $weakMap from "$/gossamer/gossamer/weak/weak_map.mjs";
import * as $weak from "$/gossamer/gossamer/weak.mjs";
import { Result$Error, Result$Ok } from "$/prelude.mjs";
import { toArray } from "~/utils/list.ffi.ts";
import { toResult } from "~/utils/result.ffi.ts";

function invalidTarget() {
  return Result$Error($weak.WeakKeyError$InvalidTarget());
}

export const new_: typeof $weakMap.new$ = () => new WeakMap();

export const from_list: typeof $weakMap.from_list = (entries) => {
  try {
    // @ts-expect-error: K is unconstrained Gleam-side; the constructor
    // validates keys and throws TypeError on invalid ones.
    return Result$Ok(new WeakMap(toArray(entries)));
  } catch {
    return invalidTarget();
  }
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
  try {
    // @ts-expect-error: K is unconstrained Gleam-side; .set throws
    // TypeError on invalid keys.
    map.set(key, value);
    return Result$Ok(map);
  } catch {
    return invalidTarget();
  }
};

export const delete_: typeof $weakMap.delete$ = (map, key) => {
  // @ts-expect-error: K is unconstrained Gleam-side; .delete returns
  // false for invalid keys (no-op).
  map.delete(key);
  return map;
};
