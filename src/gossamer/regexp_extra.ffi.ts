import * as $dict from "$/gleam_stdlib/gleam/dict.mjs";
import * as $option from "$/gleam_stdlib/gleam/option.mjs";
import * as $regexp from "$/gleam_regexp/gleam/regexp.mjs";
import * as $regexpExtra from "$/gossamer/gossamer/regexp_extra.mjs";
import { Result$Error, Result$Ok } from "$/prelude.mjs";
import { fromArray, toArray } from "~/utils/list.ffi.ts";

function flagChar(flag: $regexpExtra.RegexpFlag$): string {
  if ($regexpExtra.RegexpFlag$isGlobal(flag)) return "g";
  if ($regexpExtra.RegexpFlag$isIgnoreCase(flag)) return "i";
  if ($regexpExtra.RegexpFlag$isMultiline(flag)) return "m";
  if ($regexpExtra.RegexpFlag$isDotAll(flag)) return "s";
  if ($regexpExtra.RegexpFlag$isUnicode(flag)) return "u";
  if ($regexpExtra.RegexpFlag$isUnicodeSets(flag)) return "v";
  if ($regexpExtra.RegexpFlag$isSticky(flag)) return "y";
  return "d";
}

function fromFlagChar(
  char: string,
): $regexpExtra.RegexpFlag$ | undefined {
  switch (char) {
    case "g":
      return $regexpExtra.RegexpFlag$Global();
    case "i":
      return $regexpExtra.RegexpFlag$IgnoreCase();
    case "m":
      return $regexpExtra.RegexpFlag$Multiline();
    case "s":
      return $regexpExtra.RegexpFlag$DotAll();
    case "u":
      return $regexpExtra.RegexpFlag$Unicode();
    case "v":
      return $regexpExtra.RegexpFlag$UnicodeSets();
    case "y":
      return $regexpExtra.RegexpFlag$Sticky();
    case "d":
      return $regexpExtra.RegexpFlag$HasIndices();
    default:
      return undefined;
  }
}

export const compile: typeof $regexpExtra.compile = (pattern, flags) => {
  const flagString = toArray(flags).map(flagChar).join("");
  try {
    return Result$Ok(new RegExp(pattern, flagString));
  } catch (error) {
    if (!(error instanceof Error)) {
      return Result$Error(
        $regexp.CompileError$CompileError(String(error), 0),
      );
    }
    // @ts-expect-error columnNumber is non-standard (SpiderMonkey-only)
    const byteIndex = (error.columnNumber || 0) | 0;
    return Result$Error(
      $regexp.CompileError$CompileError(error.message, byteIndex),
    );
  }
};

export const flags: typeof $regexpExtra.flags = (regexp) => {
  const variants: $regexpExtra.RegexpFlag$[] = [];
  for (const char of regexp.flags) {
    const flag = fromFlagChar(char);
    if (flag !== undefined) variants.push(flag);
  }
  return fromArray(variants);
};

export const source: typeof $regexpExtra.source = (regexp) => regexp.source;

function submatches(captures: (string | undefined)[]) {
  const result: $option.Option$<string>[] = [];
  for (let index = captures.length - 1; index >= 0; index--) {
    const capture = captures[index];
    if (capture) {
      result[index] = $option.Option$Some(capture);
      continue;
    }
    if (result.length > 0) {
      result[index] = $option.Option$None();
    }
  }
  return fromArray(result);
}

export const scan: typeof $regexpExtra.scan = (regexp, string) => {
  const global = regexp.global
    ? regexp
    : new RegExp(regexp.source, regexp.flags + "g");
  global.lastIndex = 0;
  const matches = [...string.matchAll(global)].map((match) => {
    const named = match.groups
      ? Object.entries(match.groups).filter(([, value]) => value !== undefined)
      : [];
    return $regexpExtra.Match$Match(
      match[0],
      submatches(match.slice(1)),
      $dict.from_list(fromArray(named)),
    );
  });
  return fromArray(matches);
};

export const escape: typeof $regexpExtra.escape = (string) => {
  return RegExp.escape(string);
};
