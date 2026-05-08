import * as $requestCache from "$/gossamer/gossamer/request_cache.mjs";

export function toRequestCache(
  value: $requestCache.RequestCache$,
): RequestCache {
  if ($requestCache.RequestCache$isForceCache(value)) return "force-cache";
  if ($requestCache.RequestCache$isNoCache(value)) return "no-cache";
  if ($requestCache.RequestCache$isNoStore(value)) return "no-store";
  if ($requestCache.RequestCache$isOnlyIfCached(value)) return "only-if-cached";
  if ($requestCache.RequestCache$isReload(value)) return "reload";
  return "default";
}

export function fromRequestCache(
  value: string | undefined,
): $requestCache.RequestCache$ {
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
    default:
      return $requestCache.RequestCache$Default();
  }
}
