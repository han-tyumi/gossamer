import * as $requestInit from "$/gossamer/gossamer/request_init.mjs";
import { toHttpMethod } from "~/gossamer/http_method.ts";
import { toReferrerPolicy } from "~/gossamer/referrer_policy.ts";
import { toRequestCache } from "~/gossamer/request_cache.ts";
import { toRequestCredentials } from "~/gossamer/request_credentials.ts";
import { toRequestMode } from "~/gossamer/request_mode.ts";
import { toRequestRedirect } from "~/gossamer/request_redirect.ts";

export function toRequestInit(
  options: $requestInit.RequestInit$[],
): RequestInit {
  const result: RequestInit = {};
  for (const option of options) {
    if ($requestInit.RequestInit$isMethod(option)) {
      result.method = toHttpMethod($requestInit.RequestInit$Method$0(option));
    } else if ($requestInit.RequestInit$isHeaders(option)) {
      result.headers = $requestInit.RequestInit$Headers$0(option);
    } else if ($requestInit.RequestInit$isBody(option)) {
      result.body = $requestInit.RequestInit$Body$0(option);
    } else if ($requestInit.RequestInit$isCache(option)) {
      result.cache = toRequestCache(
        $requestInit.RequestInit$Cache$0(option),
      ) as RequestCache;
    } else if ($requestInit.RequestInit$isCredentials(option)) {
      result.credentials = toRequestCredentials(
        $requestInit.RequestInit$Credentials$0(option),
      ) as RequestCredentials;
    } else if ($requestInit.RequestInit$isIntegrity(option)) {
      result.integrity = $requestInit.RequestInit$Integrity$0(option);
    } else if ($requestInit.RequestInit$isKeepalive(option)) {
      result.keepalive = $requestInit.RequestInit$Keepalive$0(option);
    } else if ($requestInit.RequestInit$isMode(option)) {
      result.mode = toRequestMode(
        $requestInit.RequestInit$Mode$0(option),
      ) as RequestMode;
    } else if ($requestInit.RequestInit$isRedirect(option)) {
      result.redirect = toRequestRedirect(
        $requestInit.RequestInit$Redirect$0(option),
      );
    } else if ($requestInit.RequestInit$isReferrer(option)) {
      result.referrer = $requestInit.RequestInit$Referrer$0(option);
    } else if ($requestInit.RequestInit$isReferrerPolicy(option)) {
      result.referrerPolicy = toReferrerPolicy(
        $requestInit.RequestInit$ReferrerPolicy$0(option),
      ) as ReferrerPolicy;
    } else if ($requestInit.RequestInit$isSignal(option)) {
      result.signal = $requestInit.RequestInit$Signal$0(option);
    }
  }
  return result;
}
