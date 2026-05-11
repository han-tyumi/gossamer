import type * as $weakRef from "$/gossamer/gossamer/weak/weak_ref.mjs";
import * as $weak from "$/gossamer/gossamer/weak.mjs";
import { Result$Error, Result$Ok } from "$/prelude.mjs";
import { toResult } from "~/utils/result.ffi.ts";

export const new_: typeof $weakRef.new$ = (target) => {
  try {
    // @ts-expect-error: target is unconstrained Gleam-side; the constructor
    // validates and throws TypeError on invalid targets.
    return Result$Ok(new WeakRef(target));
  } catch {
    return Result$Error($weak.WeakKeyError$InvalidTarget());
  }
};

export const deref: typeof $weakRef.deref = (ref) => {
  return toResult(ref.deref());
};
