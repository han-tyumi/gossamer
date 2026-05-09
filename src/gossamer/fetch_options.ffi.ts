import * as $fo from "$/gossamer/gossamer/fetch_options.mjs";
import { mapIfSome, setIfSome } from "~/utils/option.ffi.ts";

export function toRequestCache(value: $fo.RequestCache$): RequestCache {
  if ($fo.RequestCache$isForceCache(value)) return "force-cache";
  if ($fo.RequestCache$isNoCache(value)) return "no-cache";
  if ($fo.RequestCache$isNoStore(value)) return "no-store";
  if ($fo.RequestCache$isOnlyIfCached(value)) return "only-if-cached";
  if ($fo.RequestCache$isReload(value)) return "reload";
  return "default";
}

export function fromRequestCache(
  value: string | undefined,
): $fo.RequestCache$ {
  switch (value) {
    case "force-cache":
      return $fo.RequestCache$ForceCache();
    case "no-cache":
      return $fo.RequestCache$NoCache();
    case "no-store":
      return $fo.RequestCache$NoStore();
    case "only-if-cached":
      return $fo.RequestCache$OnlyIfCached();
    case "reload":
      return $fo.RequestCache$Reload();
    default:
      return $fo.RequestCache$Default();
  }
}

export function toRequestCredentials(
  value: $fo.RequestCredentials$,
): RequestCredentials {
  if ($fo.RequestCredentials$isInclude(value)) return "include";
  if ($fo.RequestCredentials$isOmit(value)) return "omit";
  return "same-origin";
}

export function fromRequestCredentials(
  value: string | undefined,
): $fo.RequestCredentials$ {
  switch (value) {
    case "include":
      return $fo.RequestCredentials$Include();
    case "omit":
      return $fo.RequestCredentials$Omit();
    default:
      return $fo.RequestCredentials$CredentialsSameOrigin();
  }
}

export function toRequestMode(value: $fo.RequestMode$): RequestMode {
  if ($fo.RequestMode$isNavigate(value)) return "navigate";
  if ($fo.RequestMode$isNoCors(value)) return "no-cors";
  if ($fo.RequestMode$isModeSameOrigin(value)) return "same-origin";
  return "cors";
}

export function fromRequestMode(
  value: string | undefined,
): $fo.RequestMode$ {
  switch (value) {
    case "navigate":
      return $fo.RequestMode$Navigate();
    case "no-cors":
      return $fo.RequestMode$NoCors();
    case "same-origin":
      return $fo.RequestMode$ModeSameOrigin();
    default:
      return $fo.RequestMode$Cors();
  }
}

export function toRequestPriority(
  value: $fo.RequestPriority$,
): RequestPriority {
  if ($fo.RequestPriority$isHigh(value)) return "high";
  if ($fo.RequestPriority$isLow(value)) return "low";
  return "auto";
}

export function fromRequestPriority(
  value: string | undefined,
): $fo.RequestPriority$ {
  switch (value) {
    case "high":
      return $fo.RequestPriority$High();
    case "low":
      return $fo.RequestPriority$Low();
    default:
      return $fo.RequestPriority$Auto();
  }
}

export function toRequestRedirect(
  value: $fo.RequestRedirect$,
): RequestRedirect {
  if ($fo.RequestRedirect$isError(value)) return "error";
  if ($fo.RequestRedirect$isManual(value)) return "manual";
  return "follow";
}

export function fromRequestRedirect(
  value: string | undefined,
): $fo.RequestRedirect$ {
  switch (value) {
    case "error":
      return $fo.RequestRedirect$Error();
    case "manual":
      return $fo.RequestRedirect$Manual();
    default:
      return $fo.RequestRedirect$Follow();
  }
}

export function toReferrerPolicy(
  value: $fo.ReferrerPolicy$,
): ReferrerPolicy {
  if ($fo.ReferrerPolicy$isNoReferrer(value)) return "no-referrer";
  if ($fo.ReferrerPolicy$isNoReferrerWhenDowngrade(value)) {
    return "no-referrer-when-downgrade";
  }
  if ($fo.ReferrerPolicy$isOrigin(value)) return "origin";
  if ($fo.ReferrerPolicy$isOriginWhenCrossOrigin(value)) {
    return "origin-when-cross-origin";
  }
  if ($fo.ReferrerPolicy$isReferrerSameOrigin(value)) return "same-origin";
  if ($fo.ReferrerPolicy$isStrictOrigin(value)) return "strict-origin";
  if ($fo.ReferrerPolicy$isUnsafeUrl(value)) return "unsafe-url";
  return "strict-origin-when-cross-origin";
}

export function fromReferrerPolicy(
  value: string | undefined,
): $fo.ReferrerPolicy$ {
  switch (value) {
    case "no-referrer":
      return $fo.ReferrerPolicy$NoReferrer();
    case "no-referrer-when-downgrade":
      return $fo.ReferrerPolicy$NoReferrerWhenDowngrade();
    case "origin":
      return $fo.ReferrerPolicy$Origin();
    case "origin-when-cross-origin":
      return $fo.ReferrerPolicy$OriginWhenCrossOrigin();
    case "same-origin":
      return $fo.ReferrerPolicy$ReferrerSameOrigin();
    case "strict-origin":
      return $fo.ReferrerPolicy$StrictOrigin();
    case "unsafe-url":
      return $fo.ReferrerPolicy$UnsafeUrl();
    default:
      return $fo.ReferrerPolicy$StrictOriginWhenCrossOrigin();
  }
}

export function buildInit(options: $fo.FetchOptions$): RequestInit {
  const init: RequestInit = {};

  mapIfSome(
    init,
    "cache",
    $fo.FetchOptions$FetchOptions$cache(options),
    toRequestCache,
  );
  mapIfSome(
    init,
    "credentials",
    $fo.FetchOptions$FetchOptions$credentials(options),
    toRequestCredentials,
  );
  setIfSome(
    init,
    "integrity",
    $fo.FetchOptions$FetchOptions$integrity(options),
  );
  setIfSome(
    init,
    "keepalive",
    $fo.FetchOptions$FetchOptions$keepalive(options),
  );
  mapIfSome(
    init,
    "mode",
    $fo.FetchOptions$FetchOptions$mode(options),
    toRequestMode,
  );
  mapIfSome(
    init,
    "priority",
    $fo.FetchOptions$FetchOptions$priority(options),
    toRequestPriority,
  );
  mapIfSome(
    init,
    "redirect",
    $fo.FetchOptions$FetchOptions$redirect(options),
    toRequestRedirect,
  );
  setIfSome(init, "referrer", $fo.FetchOptions$FetchOptions$referrer(options));
  mapIfSome(
    init,
    "referrerPolicy",
    $fo.FetchOptions$FetchOptions$referrer_policy(options),
    toReferrerPolicy,
  );
  setIfSome(init, "signal", $fo.FetchOptions$FetchOptions$signal(options));

  return init;
}
