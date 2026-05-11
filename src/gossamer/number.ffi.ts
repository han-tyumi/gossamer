import * as $number from "$/gossamer/gossamer/number.mjs";
import { Result$Error, Result$Ok } from "$/prelude.mjs";

export const epsilon: typeof $number.epsilon = () => Number.EPSILON;
export const max_value: typeof $number.max_value = () => Number.MAX_VALUE;
export const min_value: typeof $number.min_value = () => Number.MIN_VALUE;

export const is_nan: typeof $number.is_nan = (value) => Number.isNaN(value);

export const is_finite: typeof $number.is_finite = (value) =>
  Number.isFinite(value);

export const is_integer: typeof $number.is_integer = (value) =>
  Number.isInteger(value);

export const is_safe_integer: typeof $number.is_safe_integer = (value) =>
  Number.isSafeInteger(value);

function checkRange(value: number, low: number, high: number) {
  if (value < low || value > high) {
    return Result$Error($number.NumberError$OutOfRange(value));
  }
  return undefined;
}

export const to_fixed: typeof $number.to_fixed = (value, digits) => {
  return checkRange(digits, 0, 100) ?? Result$Ok(value.toFixed(digits));
};

export const to_precision: typeof $number.to_precision = (value, digits) => {
  return checkRange(digits, 1, 100) ?? Result$Ok(value.toPrecision(digits));
};

export const to_exponential: typeof $number.to_exponential = (
  value,
  digits,
) => {
  return checkRange(digits, 0, 100) ?? Result$Ok(value.toExponential(digits));
};

export const to_string_with_radix: typeof $number.to_string_with_radix = (
  value,
  radix,
) => {
  return checkRange(radix, 2, 36) ?? Result$Ok(value.toString(radix));
};

export const to_locale_string: typeof $number.to_locale_string = (value) =>
  value.toLocaleString();

export const parse_int: typeof $number.parse_int = (string, radix) => {
  const result = globalThis.parseInt(string, radix);
  return Number.isNaN(result) ? Result$Error(undefined) : Result$Ok(result);
};

export const parse_float: typeof $number.parse_float = (string) => {
  const result = globalThis.parseFloat(string);
  return Number.isNaN(result) ? Result$Error(undefined) : Result$Ok(result);
};
