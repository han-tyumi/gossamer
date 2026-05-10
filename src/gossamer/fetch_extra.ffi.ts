import type * as $fetch from "$/gleam_fetch/gleam/fetch.mjs";
import * as $fetchExtra from "$/gossamer/gossamer/fetch_extra.mjs";
import * as $http from "$/gleam_http/gleam/http.mjs";
import * as $request from "$/gleam_http/gleam/http/request.mjs";
import * as $response from "$/gleam_http/gleam/http/response.mjs";
import { Result$Error, Result$Ok } from "$/prelude.mjs";
import {
  bitarray_request_to_fetch_request,
  FetchError$NetworkError,
  form_data_to_fetch_request,
  from_fetch_response,
  to_fetch_request,
} from "$/gleam_fetch/gleam/fetch.mjs";
import { to_string as uri_to_string } from "$/gleam_stdlib/gleam/uri.mjs";
import { fromResponseType } from "~/gossamer/response_type.ffi.ts";
import { fromBitArrayReadable } from "~/utils/bit_array.ffi.ts";
import { toArray } from "~/utils/list.ffi.ts";
import { mapIfSome, setIfSome } from "~/utils/option.ffi.ts";
import { toResult } from "~/utils/result.ffi.ts";

function toRequestCache(value: $fetchExtra.RequestCache$): RequestCache {
  if ($fetchExtra.RequestCache$isForceCache(value)) return "force-cache";
  if ($fetchExtra.RequestCache$isNoCache(value)) return "no-cache";
  if ($fetchExtra.RequestCache$isNoStore(value)) return "no-store";
  if ($fetchExtra.RequestCache$isOnlyIfCached(value)) return "only-if-cached";
  if ($fetchExtra.RequestCache$isReload(value)) return "reload";
  return "default";
}

function toRequestCredentials(
  value: $fetchExtra.RequestCredentials$,
): RequestCredentials {
  if ($fetchExtra.RequestCredentials$isInclude(value)) return "include";
  if ($fetchExtra.RequestCredentials$isOmit(value)) return "omit";
  return "same-origin";
}

function toRequestMode(value: $fetchExtra.RequestMode$): RequestMode {
  if ($fetchExtra.RequestMode$isNavigate(value)) return "navigate";
  if ($fetchExtra.RequestMode$isNoCors(value)) return "no-cors";
  if ($fetchExtra.RequestMode$isModeSameOrigin(value)) return "same-origin";
  return "cors";
}

function toRequestPriority(
  value: $fetchExtra.RequestPriority$,
): RequestPriority {
  if ($fetchExtra.RequestPriority$isHigh(value)) return "high";
  if ($fetchExtra.RequestPriority$isLow(value)) return "low";
  return "auto";
}

function toRequestRedirect(
  value: $fetchExtra.RequestRedirect$,
): RequestRedirect {
  if ($fetchExtra.RequestRedirect$isError(value)) return "error";
  if ($fetchExtra.RequestRedirect$isManual(value)) return "manual";
  return "follow";
}

function toReferrerPolicy(value: $fetchExtra.ReferrerPolicy$): ReferrerPolicy {
  if ($fetchExtra.ReferrerPolicy$isNoReferrer(value)) return "no-referrer";
  if ($fetchExtra.ReferrerPolicy$isNoReferrerWhenDowngrade(value)) {
    return "no-referrer-when-downgrade";
  }
  if ($fetchExtra.ReferrerPolicy$isOrigin(value)) return "origin";
  if ($fetchExtra.ReferrerPolicy$isOriginWhenCrossOrigin(value)) {
    return "origin-when-cross-origin";
  }
  if ($fetchExtra.ReferrerPolicy$isReferrerSameOrigin(value)) {
    return "same-origin";
  }
  if ($fetchExtra.ReferrerPolicy$isStrictOrigin(value)) return "strict-origin";
  if ($fetchExtra.ReferrerPolicy$isUnsafeUrl(value)) return "unsafe-url";
  return "strict-origin-when-cross-origin";
}

function buildInit(options: $fetchExtra.FetchOptions$): RequestInit {
  const init: RequestInit = {};

  mapIfSome(
    init,
    "cache",
    $fetchExtra.FetchOptions$FetchOptions$cache(options),
    toRequestCache,
  );
  mapIfSome(
    init,
    "credentials",
    $fetchExtra.FetchOptions$FetchOptions$credentials(options),
    toRequestCredentials,
  );
  setIfSome(
    init,
    "integrity",
    $fetchExtra.FetchOptions$FetchOptions$integrity(options),
  );
  setIfSome(
    init,
    "keepalive",
    $fetchExtra.FetchOptions$FetchOptions$keepalive(options),
  );
  mapIfSome(
    init,
    "mode",
    $fetchExtra.FetchOptions$FetchOptions$mode(options),
    toRequestMode,
  );
  mapIfSome(
    init,
    "priority",
    $fetchExtra.FetchOptions$FetchOptions$priority(options),
    toRequestPriority,
  );
  mapIfSome(
    init,
    "redirect",
    $fetchExtra.FetchOptions$FetchOptions$redirect(options),
    toRequestRedirect,
  );
  setIfSome(
    init,
    "referrer",
    $fetchExtra.FetchOptions$FetchOptions$referrer(options),
  );
  mapIfSome(
    init,
    "referrerPolicy",
    $fetchExtra.FetchOptions$FetchOptions$referrer_policy(options),
    toReferrerPolicy,
  );
  setIfSome(
    init,
    "signal",
    $fetchExtra.FetchOptions$FetchOptions$signal(options),
  );

  return init;
}

function jsResponseOf(
  response: $response.Response$<$fetch.FetchBody$>,
): Response {
  return $response.Response$Response$body(response);
}

export const response_url: typeof $fetchExtra.response_url = (response) => {
  return jsResponseOf(response).url;
};

export const is_response_redirected: typeof $fetchExtra.is_response_redirected =
  (response) => {
    return jsResponseOf(response).redirected;
  };

export const is_response_body_used: typeof $fetchExtra.is_response_body_used = (
  response,
) => {
  return jsResponseOf(response).bodyUsed;
};

export const response_type: typeof $fetchExtra.response_type = (response) => {
  return fromResponseType(jsResponseOf(response).type);
};

async function send_internal(jsRequest: Request, init: RequestInit) {
  try {
    const jsResponse = await globalThis.fetch(jsRequest, init);
    return Result$Ok(from_fetch_response(jsResponse));
  } catch (error) {
    return Result$Error(FetchError$NetworkError(String(error)));
  }
}

export const send: typeof $fetchExtra.send = (request, options) =>
  send_internal(to_fetch_request(request), buildInit(options));

export const send_bits: typeof $fetchExtra.send_bits = (request, options) =>
  send_internal(bitarray_request_to_fetch_request(request), buildInit(options));

export const send_form_data: typeof $fetchExtra.send_form_data = (
  request,
  options,
) => send_internal(form_data_to_fetch_request(request), buildInit(options));

export const send_stream: typeof $fetchExtra.send_stream = (
  request,
  options,
) => {
  const url = uri_to_string($request.to_uri(request));
  const method = $http.method_to_string(
    $request.Request$Request$method(request),
  ).toUpperCase();
  const headers = new Headers();
  for (
    const [name, value] of toArray($request.Request$Request$headers(request))
  ) {
    headers.append(name.toLowerCase(), value);
  }
  const init: RequestInit = { headers, method };
  if (method !== "GET" && method !== "HEAD") {
    init.body = fromBitArrayReadable($request.Request$Request$body(request));
    init.duplex = "half";
  }
  return send_internal(new Request(url, init), buildInit(options));
};

export const response_clone: typeof $fetchExtra.response_clone = (response) => {
  return toResult.fromThrows(() =>
    from_fetch_response(jsResponseOf(response).clone())
  );
};
