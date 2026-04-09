import * as $hm from "$/gossamer/gossamer/http_method.mjs";

export function toHttpMethod(value: $hm.HttpMethod$): string {
  if ($hm.HttpMethod$isConnect(value)) return "CONNECT";
  if ($hm.HttpMethod$isDelete(value)) return "DELETE";
  if ($hm.HttpMethod$isGet(value)) return "GET";
  if ($hm.HttpMethod$isHead(value)) return "HEAD";
  if ($hm.HttpMethod$isOptions(value)) return "OPTIONS";
  if ($hm.HttpMethod$isPatch(value)) return "PATCH";
  if ($hm.HttpMethod$isPost(value)) return "POST";
  if ($hm.HttpMethod$isPut(value)) return "PUT";
  if ($hm.HttpMethod$isOther(value)) return $hm.HttpMethod$Other$0(value);
  return "TRACE";
}

export function fromHttpMethod(value: string): $hm.HttpMethod$ {
  switch (value.toUpperCase()) {
    case "CONNECT":
      return $hm.HttpMethod$Connect();
    case "DELETE":
      return $hm.HttpMethod$Delete();
    case "GET":
      return $hm.HttpMethod$Get();
    case "HEAD":
      return $hm.HttpMethod$Head();
    case "OPTIONS":
      return $hm.HttpMethod$Options();
    case "PATCH":
      return $hm.HttpMethod$Patch();
    case "POST":
      return $hm.HttpMethod$Post();
    case "PUT":
      return $hm.HttpMethod$Put();
    case "TRACE":
      return $hm.HttpMethod$Trace();
    default:
      return $hm.HttpMethod$Other(value);
  }
}
