import * as $rc from "$/gossamer/gossamer/request_credentials.mjs";

export function fromRequestCredentials(
  value: string,
): $rc.RequestCredentials$ {
  switch (value) {
    case "include":
      return $rc.RequestCredentials$Include();
    case "omit":
      return $rc.RequestCredentials$Omit();
    case "same-origin":
      return $rc.RequestCredentials$SameOrigin();
    default:
      return $rc.RequestCredentials$Other(value);
  }
}
