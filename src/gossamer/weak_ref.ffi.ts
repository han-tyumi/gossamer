import type * as $weakRef from "$/gossamer/gossamer/weak_ref.mjs";
import { toResult } from "~/utils/result.ffi.ts";

export const new_: typeof $weakRef.new$ = (target) => {
  // @ts-expect-error: T is unconstrained Gleam-side; the constructor
  // throws TypeError on invalid targets, surfaced via toResult.fromThrows.
  return toResult.fromThrows(() => new WeakRef(target));
};

export const deref: typeof $weakRef.deref = (ref) => {
  return toResult(ref.deref());
};
