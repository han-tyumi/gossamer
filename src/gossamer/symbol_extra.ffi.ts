import type * as $symbolExtra from "$/gossamer/gossamer/symbol_extra.mjs";
import { toResult } from "~/utils/result.ffi.ts";

export const anonymous: typeof $symbolExtra.anonymous = () => {
  return Symbol();
};

export const key_for: typeof $symbolExtra.key_for = (symbol) => {
  return toResult(Symbol.keyFor(symbol));
};
