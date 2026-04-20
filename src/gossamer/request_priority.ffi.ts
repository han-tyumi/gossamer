import * as $requestPriority from "$/gossamer/gossamer/request_priority.mjs";

export function toRequestPriority(
  value: $requestPriority.RequestPriority$,
): string {
  if ($requestPriority.RequestPriority$isHigh(value)) return "high";
  if ($requestPriority.RequestPriority$isLow(value)) return "low";
  if ($requestPriority.RequestPriority$isOther(value)) {
    return $requestPriority.RequestPriority$Other$0(value);
  }
  return "auto";
}

export function fromRequestPriority(
  value: string,
): $requestPriority.RequestPriority$ {
  switch (value) {
    case "high":
      return $requestPriority.RequestPriority$High();
    case "low":
      return $requestPriority.RequestPriority$Low();
    case "auto":
      return $requestPriority.RequestPriority$Auto();
    default:
      return $requestPriority.RequestPriority$Other(value);
  }
}
