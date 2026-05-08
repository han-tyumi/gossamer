import * as $fo from "$/gossamer/gossamer/fetch_options.mjs";
import { mapIfSome, setIfSome } from "~/utils/option.ffi.ts";
import { toReferrerPolicy } from "~/gossamer/referrer_policy.ffi.ts";
import { toRequestCache } from "~/gossamer/request_cache.ffi.ts";
import { toRequestCredentials } from "~/gossamer/request_credentials.ffi.ts";
import { toRequestMode } from "~/gossamer/request_mode.ffi.ts";
import { toRequestPriority } from "~/gossamer/request_priority.ffi.ts";
import { toRequestRedirect } from "~/gossamer/request_redirect.ffi.ts";

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
