import * as $requestCache from "$/gossamer/gossamer/request_cache.mjs";

export function fromRequestCache(value: string): $requestCache.RequestCache$ {
  switch (value) {
    case "force-cache":
      return $requestCache.RequestCache$ForceCache();
    case "no-cache":
      return $requestCache.RequestCache$NoCache();
    case "no-store":
      return $requestCache.RequestCache$NoStore();
    case "only-if-cached":
      return $requestCache.RequestCache$OnlyIfCached();
    case "reload":
      return $requestCache.RequestCache$Reload();
    case "default":
      return $requestCache.RequestCache$Default();
    default:
      return $requestCache.RequestCache$Other(value);
  }
}
