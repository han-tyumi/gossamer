import * as $requestMode from "$/gossamer/gossamer/request_mode.mjs";

export function fromRequestMode(value: string): $requestMode.RequestMode$ {
  switch (value) {
    case "navigate":
      return $requestMode.RequestMode$Navigate();
    case "no-cors":
      return $requestMode.RequestMode$NoCors();
    case "same-origin":
      return $requestMode.RequestMode$SameOrigin();
    case "cors":
      return $requestMode.RequestMode$Cors();
    default:
      return $requestMode.RequestMode$Other(value);
  }
}
