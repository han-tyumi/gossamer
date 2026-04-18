import * as $rr from "$/gossamer/gossamer/request_redirect.mjs";

export function fromRequestRedirect(value: string): $rr.RequestRedirect$ {
  switch (value) {
    case "error":
      return $rr.RequestRedirect$Error();
    case "manual":
      return $rr.RequestRedirect$Manual();
    case "follow":
      return $rr.RequestRedirect$Follow();
    default:
      return $rr.RequestRedirect$Other(value);
  }
}

export function toRequestRedirect(
  value: $rr.RequestRedirect$,
): RequestRedirect {
  if ($rr.RequestRedirect$isError(value)) return "error";
  if ($rr.RequestRedirect$isManual(value)) return "manual";
  if ($rr.RequestRedirect$isOther(value)) {
    return $rr.RequestRedirect$Other$0(value) as RequestRedirect;
  }
  return "follow";
}
