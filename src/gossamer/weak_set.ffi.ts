import type * as $weakSet from "$/gossamer/gossamer/weak_set.mjs";
import { toArray } from "~/utils/list.ffi.ts";
import { toResult } from "~/utils/result.ffi.ts";

export const new_: typeof $weakSet.new$ = () => new WeakSet();

export const from_list: typeof $weakSet.from_list = (values) => {
  // @ts-expect-error: V is unconstrained Gleam-side; the constructor
  // throws TypeError on invalid values, surfaced via toResult.fromThrows.
  return toResult.fromThrows(() => new WeakSet(toArray(values)));
};

export const has: typeof $weakSet.has = (set, value) => {
  // @ts-expect-error: V is unconstrained Gleam-side; .has returns
  // false for invalid values.
  return set.has(value);
};

export const add: typeof $weakSet.add = (set, value) => {
  return toResult.fromThrows(() => {
    // @ts-expect-error: V is unconstrained Gleam-side; .add throws
    // TypeError on invalid values, surfaced via toResult.fromThrows.
    set.add(value);
    return set;
  });
};

export const delete_: typeof $weakSet.delete$ = (set, value) => {
  // @ts-expect-error: V is unconstrained Gleam-side; .delete returns
  // false for invalid values (no-op).
  set.delete(value);
  return set;
};
