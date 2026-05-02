import * as $request from "$/gossamer/gossamer/request.mjs";
import {
  fromReferrerPolicy,
  toReferrerPolicy,
} from "~/gossamer/referrer_policy.ffi.ts";
import {
  fromRequestCache,
  toRequestCache,
} from "~/gossamer/request_cache.ffi.ts";
import { fromHttpMethod, toHttpMethod } from "~/gossamer/http_method.ffi.ts";
import {
  fromRequestCredentials,
  toRequestCredentials,
} from "~/gossamer/request_credentials.ffi.ts";
import { fromRequestDestination } from "~/gossamer/request_destination.ffi.ts";
import { fromRequestMode, toRequestMode } from "~/gossamer/request_mode.ffi.ts";
import {
  fromRequestPriority,
  toRequestPriority,
} from "~/gossamer/request_priority.ffi.ts";
import {
  fromRequestRedirect,
  toRequestRedirect,
} from "~/gossamer/request_redirect.ffi.ts";
import { toArray } from "~/utils/list.ffi.ts";
import { toOption } from "~/utils/option.ffi.ts";
import { toResult } from "~/utils/result.ffi.ts";

export function toRequestInit(options: $request.RequestInit$[]): RequestInit {
  const result: RequestInit = {};
  for (const option of options) {
    if ($request.RequestInit$isMethod(option)) {
      result.method = toHttpMethod($request.RequestInit$Method$0(option));
    } else if ($request.RequestInit$isHeaders(option)) {
      result.headers = $request.RequestInit$Headers$0(option);
    } else if ($request.RequestInit$isBody(option)) {
      result.body = $request.RequestInit$Body$0(option);
    } else if ($request.RequestInit$isBodyBytes(option)) {
      result.body = $request.RequestInit$BodyBytes$0(option) as BodyInit;
    } else if ($request.RequestInit$isBodyBlob(option)) {
      result.body = $request.RequestInit$BodyBlob$0(option);
    } else if ($request.RequestInit$isBodyBuffer(option)) {
      result.body = $request.RequestInit$BodyBuffer$0(option);
    } else if ($request.RequestInit$isBodyFormData(option)) {
      result.body = $request.RequestInit$BodyFormData$0(option);
    } else if ($request.RequestInit$isBodyParams(option)) {
      result.body = $request.RequestInit$BodyParams$0(option);
    } else if ($request.RequestInit$isBodyStream(option)) {
      result.body = $request.RequestInit$BodyStream$0(option);
      // `duplex: "half"` is required by the Fetch spec when body is a
      // `ReadableStream`; currently the only accepted value.
      (result as RequestInit & { duplex: string }).duplex = "half";
    } else if ($request.RequestInit$isCache(option)) {
      result.cache = toRequestCache(
        $request.RequestInit$Cache$0(option),
      ) as RequestCache;
    } else if ($request.RequestInit$isCredentials(option)) {
      result.credentials = toRequestCredentials(
        $request.RequestInit$Credentials$0(option),
      ) as RequestCredentials;
    } else if ($request.RequestInit$isIntegrity(option)) {
      result.integrity = $request.RequestInit$Integrity$0(option);
    } else if ($request.RequestInit$isKeepalive(option)) {
      result.keepalive = $request.RequestInit$Keepalive$0(option);
    } else if ($request.RequestInit$isMode(option)) {
      result.mode = toRequestMode(
        $request.RequestInit$Mode$0(option),
      ) as RequestMode;
    } else if ($request.RequestInit$isPriority(option)) {
      (result as RequestInit & { priority: string }).priority =
        toRequestPriority($request.RequestInit$Priority$0(option));
    } else if ($request.RequestInit$isRedirect(option)) {
      result.redirect = toRequestRedirect(
        $request.RequestInit$Redirect$0(option),
      );
    } else if ($request.RequestInit$isReferrer(option)) {
      result.referrer = $request.RequestInit$Referrer$0(option);
    } else if ($request.RequestInit$isReferrerPolicy(option)) {
      result.referrerPolicy = toReferrerPolicy(
        $request.RequestInit$ReferrerPolicy$0(option),
      ) as ReferrerPolicy;
    } else if ($request.RequestInit$isSignal(option)) {
      result.signal = $request.RequestInit$Signal$0(option);
    }
  }
  return result;
}

export function toRequest(request: Request): $request.Request$ {
  const priority = (request as Request & { priority: string }).priority;
  return $request.Request$Request(
    fromHttpMethod(request.method),
    request.url,
    request.headers,
    fromRequestCache(request.cache),
    fromRequestCredentials(request.credentials),
    fromRequestDestination(request.destination),
    fromRequestMode(request.mode),
    fromRequestPriority(priority),
    fromRequestRedirect(request.redirect),
    fromReferrerPolicy(request.referrerPolicy),
    request.signal,
    request.referrer ?? "about:client",
    request.integrity ?? "",
    request.keepalive ?? false,
    toOption(request.body),
    request,
  );
}

export function requestRef(request: $request.Request$): Request {
  return $request.Request$Request$ref(request);
}

function ref(request: $request.Request$): Request {
  return requestRef(request);
}

export const from_url_string: typeof $request.from_url_string = (url) => {
  return toResult.fromThrows(() => toRequest(new Request(url)));
};

export const from_url_string_with: typeof $request.from_url_string_with = (
  url,
  init,
) => {
  return toResult.fromThrows(() =>
    toRequest(new Request(url, toRequestInit(toArray(init))))
  );
};

export const from_url: typeof $request.from_url = (url) => {
  return toResult.fromThrows(() => toRequest(new Request(url.toString())));
};

export const from_url_with: typeof $request.from_url_with = (
  url,
  init,
) => {
  return toResult.fromThrows(() =>
    toRequest(new Request(url.toString(), toRequestInit(toArray(init))))
  );
};

export const from_request: typeof $request.from_request = (existing) => {
  return toResult.fromThrows(() => toRequest(new Request(ref(existing))));
};

export const from_request_with: typeof $request.from_request_with = (
  existing,
  init,
) => {
  return toResult.fromThrows(() =>
    toRequest(new Request(ref(existing), toRequestInit(toArray(init))))
  );
};

export const clone: typeof $request.clone = (request) => {
  return toResult.fromThrows(() => toRequest(ref(request).clone()));
};

export const is_body_used: typeof $request.is_body_used = (request) => {
  return ref(request).bodyUsed;
};

export const blob: typeof $request.blob = (request) => {
  return toResult.fromPromise(ref(request).blob());
};

export const array_buffer: typeof $request.array_buffer = (request) => {
  return toResult.fromPromise(ref(request).arrayBuffer());
};

export const bytes: typeof $request.bytes = (request) => {
  return toResult.fromPromise(ref(request).bytes());
};

export const json: typeof $request.json = (request) => {
  return toResult.fromPromise(ref(request).json());
};

export const form_data: typeof $request.form_data = (request) => {
  return toResult.fromPromise(ref(request).formData());
};

export const text: typeof $request.text = (request) => {
  return toResult.fromPromise(ref(request).text());
};
