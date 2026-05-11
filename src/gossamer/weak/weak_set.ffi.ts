import type * as $weakSet from "$/gossamer/gossamer/weak/weak_set.mjs";
import * as $weak from "$/gossamer/gossamer/weak.mjs";
import { Result$Error, Result$Ok } from "$/prelude.mjs";
import { toArray } from "~/utils/list.ffi.ts";

function invalidTarget() {
  return Result$Error($weak.WeakKeyError$InvalidTarget());
}

export const new_: typeof $weakSet.new$ = () => new WeakSet();

export const from_list: typeof $weakSet.from_list = (values) => {
  try {
    // @ts-expect-error: V is unconstrained Gleam-side; the constructor
    // validates values and throws TypeError on invalid ones.
    return Result$Ok(new WeakSet(toArray(values)));
  } catch {
    return invalidTarget();
  }
};

export const has: typeof $weakSet.has = (set, value) => {
  // @ts-expect-error: V is unconstrained Gleam-side; .has returns
  // false for invalid values.
  return set.has(value);
};

export const add: typeof $weakSet.add = (set, value) => {
  try {
    // @ts-expect-error: V is unconstrained Gleam-side; .add throws
    // TypeError on invalid values.
    set.add(value);
    return Result$Ok(set);
  } catch {
    return invalidTarget();
  }
};

export const delete_: typeof $weakSet.delete$ = (set, value) => {
  // @ts-expect-error: V is unconstrained Gleam-side; .delete returns
  // false for invalid values (no-op).
  set.delete(value);
  return set;
};
