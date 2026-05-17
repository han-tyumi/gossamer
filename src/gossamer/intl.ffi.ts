import type * as $intl from "$/gossamer/gossamer/intl.mjs";
import { Result$Error, Result$Ok } from "$/prelude.mjs";
import { fromArray, toArray } from "~/utils/list.ffi.ts";

export const get_canonical_locales: typeof $intl.get_canonical_locales = (
  locales,
) => {
  try {
    return Result$Ok(fromArray(Intl.getCanonicalLocales(toArray(locales))));
  } catch {
    return Result$Error(undefined);
  }
};

export const calendars: typeof $intl.calendars = () => {
  return fromArray(Intl.supportedValuesOf("calendar"));
};

export const collations: typeof $intl.collations = () => {
  return fromArray(Intl.supportedValuesOf("collation"));
};

export const currencies: typeof $intl.currencies = () => {
  return fromArray(Intl.supportedValuesOf("currency"));
};

export const numbering_systems: typeof $intl.numbering_systems = () => {
  return fromArray(Intl.supportedValuesOf("numberingSystem"));
};

export const time_zones: typeof $intl.time_zones = () => {
  return fromArray(Intl.supportedValuesOf("timeZone"));
};

export const units: typeof $intl.units = () => {
  return fromArray(Intl.supportedValuesOf("unit"));
};
