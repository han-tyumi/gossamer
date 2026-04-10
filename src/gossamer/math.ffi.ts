import type * as $math from "$/gossamer/gossamer/math.mjs";
import { Result$Error, Result$Ok } from "$/prelude.mjs";

function toResult(value: number) {
  return Number.isFinite(value) ? Result$Ok(value) : Result$Error(undefined);
}

export const random: typeof $math.random = () => Math.random();
export const sign: typeof $math.sign = (value) => Math.sign(value);
export const trunc: typeof $math.trunc = (value) => Math.trunc(value);
export const cbrt: typeof $math.cbrt = (value) => Math.cbrt(value);
export const hypot: typeof $math.hypot = (x, y) => Math.hypot(x, y);

export const log: typeof $math.log = (value) => toResult(Math.log(value));
export const log2: typeof $math.log2 = (value) => toResult(Math.log2(value));
export const log10: typeof $math.log10 = (value) => toResult(Math.log10(value));
export const log1p: typeof $math.log1p = (value) => toResult(Math.log1p(value));

export const sin: typeof $math.sin = (angle) => Math.sin(angle);
export const cos: typeof $math.cos = (angle) => Math.cos(angle);
export const tan: typeof $math.tan = (angle) => Math.tan(angle);

export const asin: typeof $math.asin = (value) => toResult(Math.asin(value));
export const acos: typeof $math.acos = (value) => toResult(Math.acos(value));
export const atan: typeof $math.atan = (value) => Math.atan(value);
export const atan2: typeof $math.atan2 = (y, x) => Math.atan2(y, x);

export const sinh: typeof $math.sinh = (value) => Math.sinh(value);
export const cosh: typeof $math.cosh = (value) => Math.cosh(value);
export const tanh: typeof $math.tanh = (value) => Math.tanh(value);

export const asinh: typeof $math.asinh = (value) => Math.asinh(value);
export const acosh: typeof $math.acosh = (value) => toResult(Math.acosh(value));
export const atanh: typeof $math.atanh = (value) => toResult(Math.atanh(value));

export const exp: typeof $math.exp = (value) => Math.exp(value);
export const expm1: typeof $math.expm1 = (value) => Math.expm1(value);

export const clz32: typeof $math.clz32 = (value) => Math.clz32(value);
export const fround: typeof $math.fround = (value) => Math.fround(value);
export const imul: typeof $math.imul = (a, b) => Math.imul(a, b);
