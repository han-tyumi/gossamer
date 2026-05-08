import * as $requestPriority from "$/gossamer/gossamer/request_priority.mjs";

export function toRequestPriority(
  value: $requestPriority.RequestPriority$,
): RequestPriority {
  if ($requestPriority.RequestPriority$isHigh(value)) return "high";
  if ($requestPriority.RequestPriority$isLow(value)) return "low";
  return "auto";
}

export function fromRequestPriority(
  value: string | undefined,
): $requestPriority.RequestPriority$ {
  switch (value) {
    case "high":
      return $requestPriority.RequestPriority$High();
    case "low":
      return $requestPriority.RequestPriority$Low();
    default:
      return $requestPriority.RequestPriority$Auto();
  }
}
