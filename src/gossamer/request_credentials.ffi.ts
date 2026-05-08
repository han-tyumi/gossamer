import * as $rc from "$/gossamer/gossamer/request_credentials.mjs";

export function toRequestCredentials(
  value: $rc.RequestCredentials$,
): RequestCredentials {
  if ($rc.RequestCredentials$isInclude(value)) return "include";
  if ($rc.RequestCredentials$isOmit(value)) return "omit";
  return "same-origin";
}

export function fromRequestCredentials(
  value: string | undefined,
): $rc.RequestCredentials$ {
  switch (value) {
    case "include":
      return $rc.RequestCredentials$Include();
    case "omit":
      return $rc.RequestCredentials$Omit();
    default:
      return $rc.RequestCredentials$SameOrigin();
  }
}
