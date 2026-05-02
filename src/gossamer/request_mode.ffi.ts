import * as $requestMode from "$/gossamer/gossamer/request_mode.mjs";

export function toRequestMode(value: $requestMode.RequestMode$): string {
  if ($requestMode.RequestMode$isNavigate(value)) return "navigate";
  if ($requestMode.RequestMode$isNoCors(value)) return "no-cors";
  if ($requestMode.RequestMode$isSameOrigin(value)) return "same-origin";
  if ($requestMode.RequestMode$isOther(value)) {
    return $requestMode.RequestMode$Other$0(value);
  }
  return "cors";
}

export function fromRequestMode(
  value: string | undefined,
): $requestMode.RequestMode$ {
  switch (value) {
    case undefined:
    case "cors":
      return $requestMode.RequestMode$Cors();
    case "navigate":
      return $requestMode.RequestMode$Navigate();
    case "no-cors":
      return $requestMode.RequestMode$NoCors();
    case "same-origin":
      return $requestMode.RequestMode$SameOrigin();
    default:
      return $requestMode.RequestMode$Other(value);
  }
}
