import * as $number from "$/gossamer/gossamer/number.mjs";
import { Result$Error, Result$Ok } from "$/prelude.mjs";

export const epsilon: typeof $number.epsilon = () => Number.EPSILON;
export const max_value: typeof $number.max_value = () => Number.MAX_VALUE;
export const min_value: typeof $number.min_value = () => Number.MIN_VALUE;

function checkRange(value: number, low: number, high: number) {
  if (value < low || value > high) {
    return Result$Error($number.NumberError$OutOfRange(value));
  }
  return undefined;
}

export const to_fixed_string: typeof $number.to_fixed_string = (
  value,
  digits,
) => {
  return checkRange(digits, 0, 100) ?? Result$Ok(value.toFixed(digits));
};

export const to_precision_string: typeof $number.to_precision_string = (
  value,
  digits,
) => {
  return checkRange(digits, 1, 100) ?? Result$Ok(value.toPrecision(digits));
};

export const to_exponential_string: typeof $number.to_exponential_string = (
  value,
  digits,
) => {
  return checkRange(digits, 0, 100) ?? Result$Ok(value.toExponential(digits));
};

export const to_locale_string: typeof $number.to_locale_string = (value) =>
  value.toLocaleString();
