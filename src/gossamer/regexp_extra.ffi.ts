import * as $regexp from "$/gleam_regexp/gleam/regexp.mjs";
import * as $regexpExtra from "$/gossamer/gossamer/regexp_extra.mjs";
import { Result$Error, Result$Ok } from "$/prelude.mjs";
import { fromArray, toArray } from "~/utils/list.ffi.ts";

function flagChar(flag: $regexpExtra.RegExpFlag$): string {
  if ($regexpExtra.RegExpFlag$isGlobal(flag)) return "g";
  if ($regexpExtra.RegExpFlag$isIgnoreCase(flag)) return "i";
  if ($regexpExtra.RegExpFlag$isMultiline(flag)) return "m";
  if ($regexpExtra.RegExpFlag$isDotAll(flag)) return "s";
  if ($regexpExtra.RegExpFlag$isUnicode(flag)) return "u";
  if ($regexpExtra.RegExpFlag$isUnicodeSets(flag)) return "v";
  if ($regexpExtra.RegExpFlag$isSticky(flag)) return "y";
  return "d";
}

function fromFlagChar(
  char: string,
): $regexpExtra.RegExpFlag$ | undefined {
  switch (char) {
    case "g":
      return $regexpExtra.RegExpFlag$Global();
    case "i":
      return $regexpExtra.RegExpFlag$IgnoreCase();
    case "m":
      return $regexpExtra.RegExpFlag$Multiline();
    case "s":
      return $regexpExtra.RegExpFlag$DotAll();
    case "u":
      return $regexpExtra.RegExpFlag$Unicode();
    case "v":
      return $regexpExtra.RegExpFlag$UnicodeSets();
    case "y":
      return $regexpExtra.RegExpFlag$Sticky();
    case "d":
      return $regexpExtra.RegExpFlag$HasIndices();
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
  const variants: $regexpExtra.RegExpFlag$[] = [];
  for (const char of regexp.flags) {
    const flag = fromFlagChar(char);
    if (flag !== undefined) variants.push(flag);
  }
  return fromArray(variants);
};

export const source: typeof $regexpExtra.source = (regexp) => regexp.source;

export const escape: typeof $regexpExtra.escape = (string) => {
  return RegExp.escape(string);
};
