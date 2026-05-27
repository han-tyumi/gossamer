import * as $intl from "$/gossamer/gossamer/intl.mjs";

export function toLocaleMatcher(
  matcher: $intl.LocaleMatcher$,
): "best fit" | "lookup" {
  return $intl.LocaleMatcher$isBestFit(matcher) ? "best fit" : "lookup";
}

export function toHourCycle(
  cycle: $intl.HourCycle$,
): "h11" | "h12" | "h23" | "h24" {
  if ($intl.HourCycle$isH11(cycle)) return "h11";
  if ($intl.HourCycle$isH12(cycle)) return "h12";
  if ($intl.HourCycle$isH23(cycle)) return "h23";
  return "h24";
}

export function toLabelStyle(
  style: $intl.LabelStyle$,
): "long" | "short" | "narrow" {
  if ($intl.LabelStyle$isLong(style)) return "long";
  if ($intl.LabelStyle$isShort(style)) return "short";
  return "narrow";
}

export function fromLabelStyle(value: string): $intl.LabelStyle$ {
  switch (value) {
    case "long":
      return $intl.LabelStyle$Long();
    case "short":
      return $intl.LabelStyle$Short();
    default:
      return $intl.LabelStyle$Narrow();
  }
}

export function fromRangeSource(
  source: "startRange" | "shared" | "endRange",
): $intl.RangePartSource$ {
  if (source === "startRange") return $intl.RangePartSource$Start();
  if (source === "endRange") return $intl.RangePartSource$End();
  return $intl.RangePartSource$Shared();
}

export function fromHourCycle(value: string): $intl.HourCycle$ {
  switch (value) {
    case "h11":
      return $intl.HourCycle$H11();
    case "h12":
      return $intl.HourCycle$H12();
    case "h24":
      return $intl.HourCycle$H24();
    default:
      return $intl.HourCycle$H23();
  }
}

export function toCaseFirst(
  value: $intl.CaseFirst$,
): "upper" | "lower" | "false" {
  if ($intl.CaseFirst$isUpper(value)) return "upper";
  if ($intl.CaseFirst$isLower(value)) return "lower";
  return "false";
}

export function fromCaseFirst(value: string): $intl.CaseFirst$ {
  switch (value) {
    case "upper":
      return $intl.CaseFirst$Upper();
    case "lower":
      return $intl.CaseFirst$Lower();
    default:
      return $intl.CaseFirst$Neither();
  }
}
