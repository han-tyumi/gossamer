import * as $rr from "$/gossamer/gossamer/request_redirect.mjs";

export function fromRequestRedirect(
  value: string | undefined,
): $rr.RequestRedirect$ {
  switch (value) {
    case "error":
      return $rr.RequestRedirect$Error();
    case "manual":
      return $rr.RequestRedirect$Manual();
    default:
      return $rr.RequestRedirect$Follow();
  }
}

export function toRequestRedirect(
  value: $rr.RequestRedirect$,
): RequestRedirect {
  if ($rr.RequestRedirect$isError(value)) return "error";
  if ($rr.RequestRedirect$isManual(value)) return "manual";
  return "follow";
}
