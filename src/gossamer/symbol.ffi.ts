import type * as $symbol from "$/gossamer/gossamer/symbol.mjs";
import { toResult } from "~/utils/result.ts";

export type Symbol$ = symbol;

export const new_: typeof $symbol.new$ = () => {
  return Symbol();
};

export const new_with: typeof $symbol.new_with = (description) => {
  return Symbol(description);
};

export const for_: typeof $symbol.for$ = (key) => {
  return Symbol.for(key);
};

export const key_for: typeof $symbol.key_for = (sym) => {
  return toResult(Symbol.keyFor(sym));
};

export const description: typeof $symbol.description = (sym) => {
  return toResult(sym.description);
};

export const to_string: typeof $symbol.to_string = (sym) => {
  return sym.toString();
};
