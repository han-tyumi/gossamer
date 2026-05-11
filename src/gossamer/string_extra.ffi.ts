import * as $order from "$/gleam_stdlib/gleam/order.mjs";
import * as $stringExtra from "$/gossamer/gossamer/string_extra.mjs";
import { Result$Error, Result$Ok } from "$/prelude.mjs";
import { toArray } from "~/utils/list.ffi.ts";

function toNormalizationForm(
  form: $stringExtra.NormalizationForm$,
): string {
  if ($stringExtra.NormalizationForm$isNfc(form)) return "NFC";
  if ($stringExtra.NormalizationForm$isNfd(form)) return "NFD";
  if ($stringExtra.NormalizationForm$isNfkc(form)) return "NFKC";
  return "NFKD";
}

function isValidCodePoint(code: number) {
  return code >= 0 && code <= 0x10FFFF;
}

function invalidCodePoint(code: number) {
  return Result$Error($stringExtra.CodePointError$InvalidCodePoint(code));
}

export const from_code_point: typeof $stringExtra.from_code_point = (code) => {
  if (!isValidCodePoint(code)) return invalidCodePoint(code);
  return Result$Ok(String.fromCodePoint(code));
};

export const from_code_points: typeof $stringExtra.from_code_points = (
  codes,
) => {
  const array = toArray(codes);
  for (const code of array) {
    if (!isValidCodePoint(code)) return invalidCodePoint(code);
  }
  return Result$Ok(String.fromCodePoint(...array));
};

export const normalize: typeof $stringExtra.normalize = (string) =>
  string.normalize();

export const normalize_to: typeof $stringExtra.normalize_to = (string, form) =>
  string.normalize(toNormalizationForm(form));

export const locale_compare: typeof $stringExtra.locale_compare = (
  string,
  other,
) => {
  const result = string.localeCompare(other);
  if (result < 0) return $order.Order$Lt();
  if (result > 0) return $order.Order$Gt();
  return $order.Order$Eq();
};

export const to_locale_lower_case: typeof $stringExtra.to_locale_lower_case = (
  string,
) => string.toLocaleLowerCase();

export const to_locale_upper_case: typeof $stringExtra.to_locale_upper_case = (
  string,
) => string.toLocaleUpperCase();

export const is_well_formed: typeof $stringExtra.is_well_formed = (string) =>
  string.isWellFormed();

export const to_well_formed: typeof $stringExtra.to_well_formed = (string) =>
  string.toWellFormed();
