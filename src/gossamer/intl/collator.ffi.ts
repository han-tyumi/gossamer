import * as $order from "$/gleam_stdlib/gleam/order.mjs";
import * as $intl from "$/gossamer/gossamer/intl.mjs";
import * as $collator from "$/gossamer/gossamer/intl/collator.mjs";
import { Result$Error, Result$Ok } from "$/prelude.mjs";
import { fromArray, toArray } from "~/utils/list.ffi.ts";
import { mapIfSome, setIfSome } from "~/utils/option.ffi.ts";

function toUsage(usage: $collator.Usage$): "sort" | "search" {
  return $collator.Usage$isSort(usage) ? "sort" : "search";
}

function toSensitivity(
  sensitivity: $collator.Sensitivity$,
): "base" | "accent" | "case" | "variant" {
  if ($collator.Sensitivity$isBase(sensitivity)) return "base";
  if ($collator.Sensitivity$isAccent(sensitivity)) return "accent";
  if ($collator.Sensitivity$isCase(sensitivity)) return "case";
  return "variant";
}

function toCaseFirst(
  case_first: $intl.CaseFirst$,
): "upper" | "lower" | "false" {
  if ($intl.CaseFirst$isUpper(case_first)) return "upper";
  if ($intl.CaseFirst$isLower(case_first)) return "lower";
  return "false";
}

export const build: typeof $collator.do_build = (
  locales,
  usage,
  sensitivity,
  ignore_punctuation,
  numeric,
  case_first,
  collation,
) => {
  const options: Intl.CollatorOptions = {
    usage: toUsage(usage),
    ignorePunctuation: ignore_punctuation,
    numeric,
  };
  mapIfSome(options, "sensitivity", sensitivity, toSensitivity);
  mapIfSome(options, "caseFirst", case_first, toCaseFirst);
  setIfSome(options, "collation", collation);
  try {
    return Result$Ok(new Intl.Collator(toArray(locales), options));
  } catch {
    return Result$Error(undefined);
  }
};

export const compare: typeof $collator.compare = (collator, a, b) => {
  const result = collator.compare(a, b);
  if (result < 0) return $order.Order$Lt();
  if (result > 0) return $order.Order$Gt();
  return $order.Order$Eq();
};

export const resolved_locale: typeof $collator.resolved_locale = (collator) => {
  return collator.resolvedOptions().locale;
};

export const supported_locales_of: typeof $collator.supported_locales_of = (
  locales,
) => {
  return fromArray(Intl.Collator.supportedLocalesOf(toArray(locales)));
};
