import type * as $int_extra from "$/gossamer/gossamer/int_extra.mjs";

export const clz32: typeof $int_extra.clz32 = (value) => Math.clz32(value);
export const imul: typeof $int_extra.imul = (a, b) => Math.imul(a, b);

export const to_locale_string: typeof $int_extra.to_locale_string = (value) =>
  value.toLocaleString();
