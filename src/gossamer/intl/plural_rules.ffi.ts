import * as $pluralRules from "$/gossamer/gossamer/intl/plural_rules.mjs";
import { Result$Error, Result$Ok } from "$/prelude.mjs";
import {
  toRoundingMode,
  toRoundingPriority,
  toTrailingZeroDisplay,
} from "~/gossamer/intl/number_format.ffi.ts";
import { toLocaleMatcher } from "~/utils/intl.ffi.ts";
import { fromArray, toArray } from "~/utils/list.ffi.ts";
import { mapIfSome, setIfSome } from "~/utils/option.ffi.ts";

function toKind(kind: $pluralRules.Kind$): "cardinal" | "ordinal" {
  return $pluralRules.Kind$isCardinal(kind) ? "cardinal" : "ordinal";
}

function fromPluralCategory(
  rule: Intl.LDMLPluralRule,
): $pluralRules.PluralCategory$ {
  switch (rule) {
    case "zero":
      return $pluralRules.PluralCategory$Zero();
    case "one":
      return $pluralRules.PluralCategory$One();
    case "two":
      return $pluralRules.PluralCategory$Two();
    case "few":
      return $pluralRules.PluralCategory$Few();
    case "many":
      return $pluralRules.PluralCategory$Many();
    default:
      return $pluralRules.PluralCategory$Other();
  }
}

export const build: typeof $pluralRules.do_build = (
  locales,
  locale_matcher,
  kind,
  minimum_integer_digits,
  minimum_fraction_digits,
  maximum_fraction_digits,
  minimum_significant_digits,
  maximum_significant_digits,
  rounding_mode,
  rounding_priority,
  rounding_increment,
  trailing_zero_display,
) => {
  const options: Intl.PluralRulesOptions = {};
  mapIfSome(options, "localeMatcher", locale_matcher, toLocaleMatcher);
  mapIfSome(options, "type", kind, toKind);
  setIfSome(options, "minimumIntegerDigits", minimum_integer_digits);
  setIfSome(options, "minimumFractionDigits", minimum_fraction_digits);
  setIfSome(options, "maximumFractionDigits", maximum_fraction_digits);
  setIfSome(options, "minimumSignificantDigits", minimum_significant_digits);
  setIfSome(options, "maximumSignificantDigits", maximum_significant_digits);
  mapIfSome(options, "roundingMode", rounding_mode, toRoundingMode);
  mapIfSome(
    options,
    "roundingPriority",
    rounding_priority,
    toRoundingPriority,
  );
  setIfSome(options, "roundingIncrement", rounding_increment);
  mapIfSome(
    options,
    "trailingZeroDisplay",
    trailing_zero_display,
    toTrailingZeroDisplay,
  );
  try {
    return Result$Ok(new Intl.PluralRules(toArray(locales), options));
  } catch {
    return Result$Error(undefined);
  }
};

export const select: typeof $pluralRules.select_float = (rules, value) => {
  return fromPluralCategory(rules.select(value));
};

export const select_range: typeof $pluralRules.select_float_range = (
  rules,
  start,
  end,
) => {
  return fromPluralCategory(rules.selectRange(start, end));
};

export const resolved_locale: typeof $pluralRules.resolved_locale = (rules) => {
  return rules.resolvedOptions().locale;
};

export const supported_locales_of: typeof $pluralRules.supported_locales_of = (
  locales,
) => {
  return fromArray(Intl.PluralRules.supportedLocalesOf(toArray(locales)));
};
