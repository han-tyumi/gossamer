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
  value: string | undefined,
): $requestPriority.RequestPriority$ {
  if (value === undefined || value === "auto") {
    return $requestPriority.RequestPriority$Auto();
  }
  if (value === "high") return $requestPriority.RequestPriority$High();
  if (value === "low") return $requestPriority.RequestPriority$Low();
  return $requestPriority.RequestPriority$Other(value);
}
