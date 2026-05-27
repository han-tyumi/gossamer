import type * as $float_extra from "$/gossamer/gossamer/float_extra.mjs";
import { Result$Error, Result$Ok } from "$/prelude.mjs";
import { toArray } from "~/utils/list.ffi.ts";

function toResult(value: number) {
  return Number.isFinite(value) ? Result$Ok(value) : Result$Error(undefined);
}

function withRange(
  value: number,
  low: number,
  high: number,
  format: () => string,
) {
  if (value < low || value > high) {
    return Result$Error(undefined);
  }
  return Result$Ok(format());
}

export const cbrt: typeof $float_extra.cbrt = (value) => Math.cbrt(value);
export const hypot: typeof $float_extra.hypot = (values) =>
  Math.hypot(...toArray(values));
export const fround: typeof $float_extra.fround = (value) => Math.fround(value);
export const sign: typeof $float_extra.sign = (value) => Math.sign(value);

export const sin: typeof $float_extra.sin = (angle) => Math.sin(angle);
export const cos: typeof $float_extra.cos = (angle) => Math.cos(angle);
export const tan: typeof $float_extra.tan = (angle) => Math.tan(angle);

export const asin: typeof $float_extra.asin = (value) =>
  toResult(Math.asin(value));
export const acos: typeof $float_extra.acos = (value) =>
  toResult(Math.acos(value));
export const atan: typeof $float_extra.atan = (value) => Math.atan(value);
export const atan2: typeof $float_extra.atan2 = (y, x) => Math.atan2(y, x);

export const sinh: typeof $float_extra.sinh = (value) => Math.sinh(value);
export const cosh: typeof $float_extra.cosh = (value) => Math.cosh(value);
export const tanh: typeof $float_extra.tanh = (value) => Math.tanh(value);

export const asinh: typeof $float_extra.asinh = (value) => Math.asinh(value);
export const acosh: typeof $float_extra.acosh = (value) =>
  toResult(Math.acosh(value));
export const atanh: typeof $float_extra.atanh = (value) =>
  toResult(Math.atanh(value));

export const log2: typeof $float_extra.log2 = (value) =>
  toResult(Math.log2(value));
export const log10: typeof $float_extra.log10 = (value) =>
  toResult(Math.log10(value));
export const log1p: typeof $float_extra.log1p = (value) =>
  toResult(Math.log1p(value));

export const expm1: typeof $float_extra.expm1 = (value) => Math.expm1(value);

export const to_fixed_string: typeof $float_extra.to_fixed_string = (
  value,
  digits,
) => withRange(digits, 0, 100, () => value.toFixed(digits));

export const to_precision_string: typeof $float_extra.to_precision_string = (
  value,
  digits,
) => withRange(digits, 1, 100, () => value.toPrecision(digits));

export const to_exponential_string: typeof $float_extra.to_exponential_string =
  (value, digits) =>
    withRange(digits, 0, 100, () => value.toExponential(digits));
