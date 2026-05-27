import * as $listFormat from "$/gossamer/gossamer/intl/list_format.mjs";
import { Result$Error, Result$Ok } from "$/prelude.mjs";
import {
  fromLabelStyle,
  toLabelStyle,
  toLocaleMatcher,
} from "~/utils/intl.ffi.ts";
import { fromArray, fromArrayMapped, toArray } from "~/utils/list.ffi.ts";
import { mapIfSome } from "~/utils/option.ffi.ts";

function toKind(
  kind: $listFormat.Kind$,
): "conjunction" | "disjunction" | "unit" {
  if ($listFormat.Kind$isConjunction(kind)) return "conjunction";
  if ($listFormat.Kind$isDisjunction(kind)) return "disjunction";
  return "unit";
}

function fromKind(value: string): $listFormat.Kind$ {
  switch (value) {
    case "disjunction":
      return $listFormat.Kind$Disjunction();
    case "unit":
      return $listFormat.Kind$Unit();
    default:
      return $listFormat.Kind$Conjunction();
  }
}

function fromPartKind(type: string): $listFormat.PartKind$ {
  return type === "literal"
    ? $listFormat.PartKind$Literal()
    : $listFormat.PartKind$Element();
}

function toPart(item: { type: string; value: string }): $listFormat.Part$ {
  return $listFormat.Part$Part(fromPartKind(item.type), item.value);
}

export const build: typeof $listFormat.do_build = (
  locales,
  locale_matcher,
  kind,
  style,
) => {
  const options: Intl.ListFormatOptions = {};
  mapIfSome(options, "localeMatcher", locale_matcher, toLocaleMatcher);
  mapIfSome(options, "type", kind, toKind);
  mapIfSome(options, "style", style, toLabelStyle);
  try {
    return Result$Ok(new Intl.ListFormat(toArray(locales), options));
  } catch {
    return Result$Error(undefined);
  }
};

export const format: typeof $listFormat.format = (formatter, list) => {
  return formatter.format(toArray(list));
};

export const format_to_parts: typeof $listFormat.format_to_parts = (
  formatter,
  list,
) => {
  return fromArrayMapped(formatter.formatToParts(toArray(list)), toPart);
};

export const resolved_options: typeof $listFormat.resolved_options = (
  formatter,
) => {
  const resolved = formatter.resolvedOptions();
  return $listFormat.ResolvedOptions$ResolvedOptions(
    resolved.locale,
    fromKind(resolved.type),
    fromLabelStyle(resolved.style),
  );
};

export const supported_locales_of: typeof $listFormat.supported_locales_of = (
  locales,
) => {
  return fromArray(Intl.ListFormat.supportedLocalesOf(toArray(locales)));
};
