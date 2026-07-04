import * as $displayNames from "$/gossamer/gossamer/intl/display_names.mjs";
import { Result$Error, Result$Ok } from "$/prelude.mjs";
import {
  fromLabelStyle,
  supportedLocalesOf,
  toLabelStyle,
  toLocaleMatcher,
} from "~/utils/intl.ffi.ts";
import { toArray } from "~/utils/list.ffi.ts";
import { mapIfSome, mapOption } from "~/utils/option.ffi.ts";

function toKind(kind: $displayNames.Kind$): Intl.DisplayNamesType {
  if ($displayNames.Kind$isLanguage(kind)) return "language";
  if ($displayNames.Kind$isRegion(kind)) return "region";
  if ($displayNames.Kind$isScript(kind)) return "script";
  if ($displayNames.Kind$isCurrency(kind)) return "currency";
  if ($displayNames.Kind$isCalendar(kind)) return "calendar";
  return "dateTimeField";
}

function fromKind(value: string): $displayNames.Kind$ {
  switch (value) {
    case "language":
      return $displayNames.Kind$Language();
    case "region":
      return $displayNames.Kind$Region();
    case "script":
      return $displayNames.Kind$Script();
    case "currency":
      return $displayNames.Kind$Currency();
    case "calendar":
      return $displayNames.Kind$Calendar();
    default:
      return $displayNames.Kind$DateTimeField();
  }
}

function toLanguageDisplay(
  display: $displayNames.LanguageDisplay$,
): "dialect" | "standard" {
  return $displayNames.LanguageDisplay$isDialect(display)
    ? "dialect"
    : "standard";
}

function fromLanguageDisplay(
  value: string,
): $displayNames.LanguageDisplay$ {
  return value === "standard"
    ? $displayNames.LanguageDisplay$Standard()
    : $displayNames.LanguageDisplay$Dialect();
}

export const build: typeof $displayNames.do_build = (
  locales,
  locale_matcher,
  kind,
  style,
  languageDisplay,
) => {
  // The native fallback is fixed to "none" so `of` and `find` can
  // distinguish "match" from "no match"; `of` then falls back to the
  // input code on the Gleam side.
  const options: Intl.DisplayNamesOptions = {
    type: toKind(kind),
    fallback: "none",
  };
  mapIfSome(options, "localeMatcher", locale_matcher, toLocaleMatcher);
  mapIfSome(options, "style", style, toLabelStyle);
  mapIfSome(options, "languageDisplay", languageDisplay, toLanguageDisplay);
  try {
    return Result$Ok(new Intl.DisplayNames(toArray(locales), options));
  } catch {
    return Result$Error(undefined);
  }
};

export const of: typeof $displayNames.of = (formatter, code) => {
  try {
    return Result$Ok(formatter.of(code) ?? code);
  } catch {
    return Result$Error(undefined);
  }
};

export const find: typeof $displayNames.find = (formatter, code) => {
  try {
    const result = formatter.of(code);
    return result === undefined ? Result$Error(undefined) : Result$Ok(result);
  } catch {
    return Result$Error(undefined);
  }
};

export const resolved_options: typeof $displayNames.resolved_options = (
  formatter,
) => {
  const resolved = formatter.resolvedOptions();
  return $displayNames.ResolvedOptions$ResolvedOptions(
    resolved.locale,
    fromKind(resolved.type),
    fromLabelStyle(resolved.style),
    mapOption(resolved.languageDisplay, fromLanguageDisplay),
  );
};

export const supported_locales_of: typeof $displayNames.supported_locales_of = (
  locales,
) => {
  return supportedLocalesOf(Intl.DisplayNames.supportedLocalesOf, locales);
};
