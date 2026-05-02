import * as $regExpFlag from "$/gossamer/gossamer/regexp_flag.mjs";

export function flagChar(flag: $regExpFlag.RegExpFlag$): string {
  if ($regExpFlag.RegExpFlag$isGlobal(flag)) return "g";
  if ($regExpFlag.RegExpFlag$isIgnoreCase(flag)) return "i";
  if ($regExpFlag.RegExpFlag$isMultiline(flag)) return "m";
  if ($regExpFlag.RegExpFlag$isDotAll(flag)) return "s";
  if ($regExpFlag.RegExpFlag$isUnicode(flag)) return "u";
  if ($regExpFlag.RegExpFlag$isUnicodeSets(flag)) return "v";
  if ($regExpFlag.RegExpFlag$isSticky(flag)) return "y";
  return "d";
}

export function fromFlagChar(
  char: string,
): $regExpFlag.RegExpFlag$ | undefined {
  switch (char) {
    case "g":
      return $regExpFlag.RegExpFlag$Global();
    case "i":
      return $regExpFlag.RegExpFlag$IgnoreCase();
    case "m":
      return $regExpFlag.RegExpFlag$Multiline();
    case "s":
      return $regExpFlag.RegExpFlag$DotAll();
    case "u":
      return $regExpFlag.RegExpFlag$Unicode();
    case "v":
      return $regExpFlag.RegExpFlag$UnicodeSets();
    case "y":
      return $regExpFlag.RegExpFlag$Sticky();
    case "d":
      return $regExpFlag.RegExpFlag$HasIndices();
    default:
      return undefined;
  }
}
