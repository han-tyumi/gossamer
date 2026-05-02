import * as $runtime from "$/gossamer/runtime.mjs";
import { toResult } from "~/utils/result.ffi.ts";

export const current: typeof $runtime.current = () => {
  if ("Deno" in globalThis) return $runtime.Runtime$Deno();
  if ("Bun" in globalThis) return $runtime.Runtime$Bun();
  return $runtime.Runtime$Node();
};

export const catching: typeof $runtime.catching = (thunk) => {
  return toResult.fromThrows(thunk);
};
