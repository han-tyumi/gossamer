import * as $rc from "$/gossamer/gossamer/request_credentials.mjs";

export function toRequestCredentials(
  value: $rc.RequestCredentials$,
): string {
  if ($rc.RequestCredentials$isInclude(value)) return "include";
  if ($rc.RequestCredentials$isOmit(value)) return "omit";
  if ($rc.RequestCredentials$isOther(value)) {
    return $rc.RequestCredentials$Other$0(value);
  }
  return "same-origin";
}

export function fromRequestCredentials(
  value: string | undefined,
): $rc.RequestCredentials$ {
  switch (value) {
    case undefined:
    case "same-origin":
      return $rc.RequestCredentials$SameOrigin();
    case "include":
      return $rc.RequestCredentials$Include();
    case "omit":
      return $rc.RequestCredentials$Omit();
    default:
      return $rc.RequestCredentials$Other(value);
  }
}
