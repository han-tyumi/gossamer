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

export const normalize: typeof $stringExtra.normalize = (string) =>
  string.normalize();

export const normalize_to: typeof $stringExtra.normalize_to = (string, form) =>
  string.normalize(toNormalizationForm(form));

export const to_locale_lower_case: typeof $stringExtra.to_locale_lower_case = (
  string,
  locales,
) => {
  try {
    return Result$Ok(string.toLocaleLowerCase(toArray(locales)));
  } catch {
    return Result$Error(undefined);
  }
};

export const to_locale_upper_case: typeof $stringExtra.to_locale_upper_case = (
  string,
  locales,
) => {
  try {
    return Result$Ok(string.toLocaleUpperCase(toArray(locales)));
  } catch {
    return Result$Error(undefined);
  }
};

export const is_well_formed: typeof $stringExtra.is_well_formed = (string) =>
  string.isWellFormed();

export const to_well_formed: typeof $stringExtra.to_well_formed = (string) =>
  string.toWellFormed();
