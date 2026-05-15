import * as $displayNames from "$/gossamer/gossamer/intl/display_names.mjs";
import { Result$Error, Result$Ok } from "$/prelude.mjs";
import { toLabelStyle } from "~/utils/intl.ffi.ts";
import { fromArray, toArray } from "~/utils/list.ffi.ts";
import { mapIfSome } from "~/utils/option.ffi.ts";

function toKind(kind: $displayNames.Kind$): Intl.DisplayNamesType {
  if ($displayNames.Kind$isLanguage(kind)) return "language";
  if ($displayNames.Kind$isRegion(kind)) return "region";
  if ($displayNames.Kind$isScript(kind)) return "script";
  if ($displayNames.Kind$isCurrency(kind)) return "currency";
  if ($displayNames.Kind$isCalendar(kind)) return "calendar";
  return "dateTimeField";
}

function toFallback(fallback: $displayNames.Fallback$): "code" | "none" {
  return $displayNames.Fallback$isFallbackCode(fallback) ? "code" : "none";
}

function toLanguageDisplay(
  display: $displayNames.LanguageDisplay$,
): "dialect" | "standard" {
  return $displayNames.LanguageDisplay$isDialect(display)
    ? "dialect"
    : "standard";
}

export const build: typeof $displayNames.do_build = (
  locales,
  kind,
  style,
  fallback,
  languageDisplay,
) => {
  const options: Intl.DisplayNamesOptions = { type: toKind(kind) };
  mapIfSome(options, "style", style, toLabelStyle);
  mapIfSome(options, "fallback", fallback, toFallback);
  mapIfSome(options, "languageDisplay", languageDisplay, toLanguageDisplay);
  try {
    return Result$Ok(new Intl.DisplayNames(toArray(locales), options));
  } catch {
    return Result$Error(undefined);
  }
};

export const of: typeof $displayNames.of = (formatter, code) => {
  const result = formatter.of(code);
  return result === undefined ? Result$Error(undefined) : Result$Ok(result);
};

export const resolved_locale: typeof $displayNames.resolved_locale = (
  formatter,
) => {
  return formatter.resolvedOptions().locale;
};

export const supported_locales_of: typeof $displayNames.supported_locales_of = (
  locales,
) => {
  return fromArray(Intl.DisplayNames.supportedLocalesOf(toArray(locales)));
};
