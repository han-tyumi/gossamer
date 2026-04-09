import * as $requestInit from "$/gossamer/gossamer/request_init.mjs";
import { toRequestRedirect } from "~/gossamer/request_redirect.ts";

export function toRequestInit(
  options: $requestInit.RequestInit$[],
): RequestInit {
  const result: RequestInit = {};
  for (const option of options) {
    if ($requestInit.RequestInit$isMethod(option)) {
      result.method = $requestInit.RequestInit$Method$0(option);
    } else if ($requestInit.RequestInit$isHeaders(option)) {
      result.headers = $requestInit.RequestInit$Headers$0(option);
    } else if ($requestInit.RequestInit$isBody(option)) {
      result.body = $requestInit.RequestInit$Body$0(option);
    } else if ($requestInit.RequestInit$isRedirect(option)) {
      result.redirect = toRequestRedirect(
        $requestInit.RequestInit$Redirect$0(option),
      );
    } else if ($requestInit.RequestInit$isSignal(option)) {
      result.signal = $requestInit.RequestInit$Signal$0(option);
    } else if ($requestInit.RequestInit$isReferrer(option)) {
      result.referrer = $requestInit.RequestInit$Referrer$0(option);
    } else if ($requestInit.RequestInit$isKeepalive(option)) {
      result.keepalive = $requestInit.RequestInit$Keepalive$0(option);
    } else if ($requestInit.RequestInit$isIntegrity(option)) {
      result.integrity = $requestInit.RequestInit$Integrity$0(option);
    }
  }
  return result;
}
