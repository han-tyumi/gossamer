import * as $rt from "$/gossamer/gossamer/response_type.mjs";

export function fromResponseType(value: string): $rt.ResponseType$ {
  switch (value) {
    case "basic":
      return $rt.ResponseType$Basic();
    case "cors":
      return $rt.ResponseType$Cors();
    case "error":
      return $rt.ResponseType$Error();
    case "opaque":
      return $rt.ResponseType$Opaque();
    case "opaqueredirect":
      return $rt.ResponseType$OpaqueRedirect();
    case "default":
      return $rt.ResponseType$Default();
    default:
      return $rt.ResponseType$Other(value);
  }
}
