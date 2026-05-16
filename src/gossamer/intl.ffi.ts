import * as $intl from "$/gossamer/gossamer/intl.mjs";
import { Result$Error, Result$Ok } from "$/prelude.mjs";
import { fromArray, toArray } from "~/utils/list.ffi.ts";

function toSupportedKey(
  key: $intl.SupportedValueKey$,
):
  | "calendar"
  | "collation"
  | "currency"
  | "numberingSystem"
  | "timeZone"
  | "unit" {
  if ($intl.SupportedValueKey$isCalendar(key)) return "calendar";
  if ($intl.SupportedValueKey$isCollation(key)) return "collation";
  if ($intl.SupportedValueKey$isCurrency(key)) return "currency";
  if ($intl.SupportedValueKey$isNumberingSystem(key)) return "numberingSystem";
  if ($intl.SupportedValueKey$isTimeZone(key)) return "timeZone";
  return "unit";
}

export const get_canonical_locales: typeof $intl.get_canonical_locales = (
  locales,
) => {
  try {
    return Result$Ok(fromArray(Intl.getCanonicalLocales(toArray(locales))));
  } catch {
    return Result$Error(undefined);
  }
};

export const supported_values_of: typeof $intl.supported_values_of = (key) => {
  return fromArray(Intl.supportedValuesOf(toSupportedKey(key)));
};
