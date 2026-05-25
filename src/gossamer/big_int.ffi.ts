import * as $order from "$/gleam_stdlib/gleam/order.mjs";
import type * as $bigInt from "$/gossamer/gossamer/big_int.mjs";
import { Result$Error, Result$Ok } from "$/prelude.mjs";
import { toResult } from "~/utils/result.ffi.ts";

export const from_int: typeof $bigInt.from_int = (value) => BigInt(value);

export const parse: typeof $bigInt.parse = (string) => {
  try {
    return Result$Ok(BigInt(string));
  } catch {
    return Result$Error(undefined);
  }
};

export const base_parse: typeof $bigInt.base_parse = (string, base) => {
  if (base < 2 || base > 36) return Result$Error(undefined);
  let body = string.trim();
  let negative = false;
  if (body[0] === "+" || body[0] === "-") {
    negative = body[0] === "-";
    body = body.slice(1);
  }
  if (body.length === 0) return Result$Error(undefined);
  const radix = BigInt(base);
  let acc = 0n;
  for (const char of body) {
    const digit = parseInt(char, base);
    if (Number.isNaN(digit)) return Result$Error(undefined);
    acc = acc * radix + BigInt(digit);
  }
  return Result$Ok(negative ? -acc : acc);
};

const MAX_SAFE = BigInt(Number.MAX_SAFE_INTEGER);
const MIN_SAFE = BigInt(Number.MIN_SAFE_INTEGER);

export const to_int: typeof $bigInt.to_int = (x) => {
  if (x > MAX_SAFE || x < MIN_SAFE) return toResult(null);
  return toResult(Number(x));
};

export const to_float: typeof $bigInt.to_float = (x) => {
  const float = Number(x);
  return Number.isFinite(float) ? Result$Ok(float) : Result$Error(undefined);
};

export const to_string: typeof $bigInt.to_string = (x) => String(x);

export const to_base_string: typeof $bigInt.to_base_string = (x, base) => {
  if (base < 2 || base > 36) return Result$Error(undefined);
  return Result$Ok(x.toString(base).toUpperCase());
};

export const to_base2: typeof $bigInt.to_base2 = (x) =>
  x.toString(2).toUpperCase();

export const to_base8: typeof $bigInt.to_base8 = (x) =>
  x.toString(8).toUpperCase();

export const to_base16: typeof $bigInt.to_base16 = (x) =>
  x.toString(16).toUpperCase();

export const to_base36: typeof $bigInt.to_base36 = (x) =>
  x.toString(36).toUpperCase();

export const add: typeof $bigInt.add = (a, b) => a + b;

export const subtract: typeof $bigInt.subtract = (a, b) => a - b;

export const multiply: typeof $bigInt.multiply = (a, b) => a * b;

export const divide: typeof $bigInt.divide = (dividend, divisor) => {
  if (divisor === 0n) return Result$Error(undefined);
  return Result$Ok(dividend / divisor);
};

export const remainder: typeof $bigInt.remainder = (dividend, divisor) => {
  if (divisor === 0n) return Result$Error(undefined);
  return Result$Ok(dividend % divisor);
};

export const modulo: typeof $bigInt.modulo = (dividend, divisor) => {
  if (divisor === 0n) return Result$Error(undefined);
  const rem = dividend % divisor;
  return Result$Ok(rem * divisor < 0n ? rem + divisor : rem);
};

export const floor_divide: typeof $bigInt.floor_divide = (
  dividend,
  divisor,
) => {
  if (divisor === 0n) return Result$Error(undefined);
  const quotient = dividend / divisor;
  const rem = dividend % divisor;
  return Result$Ok(rem !== 0n && rem * divisor < 0n ? quotient - 1n : quotient);
};

export const negate: typeof $bigInt.negate = (x) => -x;

export const absolute_value: typeof $bigInt.absolute_value = (x) =>
  x < 0n ? -x : x;

export const power: typeof $bigInt.power = (base, exponent) => {
  if (exponent < 0n) return Result$Error(undefined);
  return Result$Ok(base ** exponent);
};

export const compare: typeof $bigInt.compare = (a, b) => {
  if (a < b) return $order.Order$Lt();
  if (a > b) return $order.Order$Gt();
  return $order.Order$Eq();
};

export const min: typeof $bigInt.min = (a, b) => (a < b ? a : b);

export const max: typeof $bigInt.max = (a, b) => (a > b ? a : b);

export const clamp: typeof $bigInt.clamp = (x, minBound, maxBound) =>
  x < minBound ? minBound : x > maxBound ? maxBound : x;

export const is_even: typeof $bigInt.is_even = (x) => x % 2n === 0n;

export const is_odd: typeof $bigInt.is_odd = (x) => x % 2n !== 0n;

export const bitwise_and: typeof $bigInt.bitwise_and = (x, y) => x & y;

export const bitwise_or: typeof $bigInt.bitwise_or = (x, y) => x | y;

export const bitwise_exclusive_or: typeof $bigInt.bitwise_exclusive_or = (
  x,
  y,
) => x ^ y;

export const bitwise_not: typeof $bigInt.bitwise_not = (x) => ~x;

export const bitwise_shift_left: typeof $bigInt.bitwise_shift_left = (x, y) => {
  if (y < 0n) return Result$Error(undefined);
  return Result$Ok(x << y);
};

export const bitwise_shift_right: typeof $bigInt.bitwise_shift_right = (
  x,
  y,
) => {
  if (y < 0n) return Result$Error(undefined);
  return Result$Ok(x >> y);
};

export const as_int_n: typeof $bigInt.as_int_n = (x, bits) =>
  BigInt.asIntN(Math.max(0, bits), x);

export const as_uint_n: typeof $bigInt.as_uint_n = (x, bits) =>
  BigInt.asUintN(Math.max(0, bits), x);
