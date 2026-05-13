import * as $order from "$/gleam_stdlib/gleam/order.mjs";
import * as $bigInt from "$/gossamer/gossamer/big_int.mjs";
import { Result$Error, Result$Ok } from "$/prelude.mjs";
import { toResult } from "~/utils/result.ffi.ts";

export const from_int: typeof $bigInt.from_int = (value) => BigInt(value);

export const from_string: typeof $bigInt.from_string = (string) => {
  try {
    return Result$Ok(BigInt(string));
  } catch {
    return Result$Error($bigInt.BigIntError$InvalidInteger());
  }
};

const MAX_SAFE = BigInt(Number.MAX_SAFE_INTEGER);
const MIN_SAFE = BigInt(Number.MIN_SAFE_INTEGER);

export const to_int: typeof $bigInt.to_int = (value) => {
  if (value > MAX_SAFE || value < MIN_SAFE) return toResult(null);
  return toResult(Number(value));
};

export const to_string: typeof $bigInt.to_string = (value) => String(value);

export const add: typeof $bigInt.add = (a, b) => a + b;

export const subtract: typeof $bigInt.subtract = (a, b) => a - b;

export const multiply: typeof $bigInt.multiply = (a, b) => a * b;

export const divide: typeof $bigInt.divide = (a, divisor) => {
  if (divisor === 0n) return Result$Error($bigInt.BigIntError$DivisionByZero());
  return Result$Ok(a / divisor);
};

export const remainder: typeof $bigInt.remainder = (a, divisor) => {
  if (divisor === 0n) return Result$Error($bigInt.BigIntError$DivisionByZero());
  return Result$Ok(a % divisor);
};

export const negate: typeof $bigInt.negate = (value) => -value;

export const absolute_value: typeof $bigInt.absolute_value = (value) =>
  value < 0n ? -value : value;

export const compare: typeof $bigInt.compare = (a, b) => {
  if (a < b) return $order.Order$Lt();
  if (a > b) return $order.Order$Gt();
  return $order.Order$Eq();
};

export const power: typeof $bigInt.power = (base, exponent) => {
  if (exponent < 0n) return Result$Error(undefined);
  return Result$Ok(base ** exponent);
};

export const bitwise_and: typeof $bigInt.bitwise_and = (a, b) => a & b;

export const bitwise_or: typeof $bigInt.bitwise_or = (a, b) => a | b;

export const bitwise_exclusive_or: typeof $bigInt.bitwise_exclusive_or = (
  a,
  b,
) => a ^ b;

export const bitwise_not: typeof $bigInt.bitwise_not = (value) => ~value;

export const bitwise_shift_left: typeof $bigInt.bitwise_shift_left = (
  value,
  by,
) => {
  if (by < 0n) return Result$Error(undefined);
  return Result$Ok(value << by);
};

export const bitwise_shift_right: typeof $bigInt.bitwise_shift_right = (
  value,
  by,
) => {
  if (by < 0n) return Result$Error(undefined);
  return Result$Ok(value >> by);
};
