import * as $intl from "$/gossamer/gossamer/intl.mjs";

export function toHourCycle(
  cycle: $intl.HourCycle$,
): "h11" | "h12" | "h23" | "h24" {
  if ($intl.HourCycle$isH11(cycle)) return "h11";
  if ($intl.HourCycle$isH12(cycle)) return "h12";
  if ($intl.HourCycle$isH23(cycle)) return "h23";
  return "h24";
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
