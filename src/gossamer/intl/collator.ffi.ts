import * as $order from "$/gleam_stdlib/gleam/order.mjs";
import * as $collator from "$/gossamer/gossamer/intl/collator.mjs";
import { Result$Error, Result$Ok } from "$/prelude.mjs";
import {
  fromCaseFirst,
  supportedLocalesOf,
  toCaseFirst,
  toLocaleMatcher,
} from "~/utils/intl.ffi.ts";
import { toArray } from "~/utils/list.ffi.ts";
import { mapIfSome, setIfSome } from "~/utils/option.ffi.ts";

function toUsage(usage: $collator.Usage$): "sort" | "search" {
  return $collator.Usage$isSort(usage) ? "sort" : "search";
}

function fromUsage(value: string): $collator.Usage$ {
  return value === "search" ? $collator.Usage$Search() : $collator.Usage$Sort();
}

function toSensitivity(
  sensitivity: $collator.Sensitivity$,
): "base" | "accent" | "case" | "variant" {
  if ($collator.Sensitivity$isBase(sensitivity)) return "base";
  if ($collator.Sensitivity$isAccent(sensitivity)) return "accent";
  if ($collator.Sensitivity$isCase(sensitivity)) return "case";
  return "variant";
}

function fromSensitivity(value: string): $collator.Sensitivity$ {
  switch (value) {
    case "base":
      return $collator.Sensitivity$Base();
    case "accent":
      return $collator.Sensitivity$Accent();
    case "case":
      return $collator.Sensitivity$Case();
    default:
      return $collator.Sensitivity$Variant();
  }
}

export const build: typeof $collator.do_build = (
  locales,
  locale_matcher,
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
  mapIfSome(options, "localeMatcher", locale_matcher, toLocaleMatcher);
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

export const resolved_options: typeof $collator.resolved_options = (
  collator,
) => {
  const resolved = collator.resolvedOptions();
  return $collator.ResolvedOptions$ResolvedOptions(
    resolved.locale,
    fromUsage(resolved.usage),
    fromSensitivity(resolved.sensitivity),
    resolved.ignorePunctuation,
    resolved.collation,
    resolved.numeric,
    fromCaseFirst(resolved.caseFirst),
  );
};

export const supported_locales_of: typeof $collator.supported_locales_of = (
  locales,
) => {
  return supportedLocalesOf(Intl.Collator.supportedLocalesOf, locales);
};
