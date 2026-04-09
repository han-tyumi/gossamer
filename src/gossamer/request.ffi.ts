import type * as $request from "$/gossamer/gossamer/request.mjs";
import { fromReferrerPolicy } from "~/gossamer/referrer_policy.ts";
import { fromRequestCache } from "~/gossamer/request_cache.ts";
import { fromRequestCredentials } from "~/gossamer/request_credentials.ts";
import { fromRequestDestination } from "~/gossamer/request_destination.ts";
import { toRequestInit } from "~/gossamer/request_init.ts";
import { fromRequestMode } from "~/gossamer/request_mode.ts";
import { fromRequestRedirect } from "~/gossamer/request_redirect.ts";
import { toArray } from "~/utils/list.ts";
import { toResult } from "~/utils/result.ts";

export type Request$ = Request;

export const new_: typeof $request.new$ = (input) => {
  return toResult.fromThrows(() => new Request(input));
};

export const new_with_init: typeof $request.new_with_init = (input, init) => {
  return toResult.fromThrows(() =>
    new Request(input, toRequestInit(toArray(init)))
  );
};

export const method: typeof $request.method = (request) => request.method;
export const url: typeof $request.url = (request) => request.url;
export const headers: typeof $request.headers = (request) => request.headers;
export const cache: typeof $request.cache = (request) => {
  return fromRequestCache(request.cache);
};

export const credentials: typeof $request.credentials = (request) => {
  return fromRequestCredentials(request.credentials);
};

export const destination: typeof $request.destination = (request) => {
  return fromRequestDestination(request.destination);
};

export const redirect: typeof $request.redirect = (request) => {
  return fromRequestRedirect(request.redirect);
};
export const signal: typeof $request.signal = (request) => request.signal;
export const referrer: typeof $request.referrer = (request) => request.referrer;

export const referrer_policy: typeof $request.referrer_policy = (request) => {
  return fromReferrerPolicy(request.referrerPolicy);
};

export const mode: typeof $request.mode = (request) => {
  return fromRequestMode(request.mode);
};

export const is_keepalive: typeof $request.is_keepalive = (request) => {
  return request.keepalive;
};

export const integrity: typeof $request.integrity = (request) => {
  return request.integrity;
};

export const clone: typeof $request.clone = (request) => request.clone();

export const body: typeof $request.body = (request) => {
  return toResult(request.body);
};

export const is_body_used: typeof $request.is_body_used = (request) => {
  return request.bodyUsed;
};

export const blob: typeof $request.blob = (request) => {
  return toResult.fromPromise(request.blob());
};

export const array_buffer: typeof $request.array_buffer = (request) => {
  return toResult.fromPromise(request.arrayBuffer());
};

export const bytes: typeof $request.bytes = (request) => {
  return toResult.fromPromise(request.bytes());
};

export const json: typeof $request.json = (request) => {
  return toResult.fromPromise(request.json());
};

export const form_data: typeof $request.form_data = (request) => {
  return toResult.fromPromise(request.formData());
};

export const text: typeof $request.text = (request) => {
  return toResult.fromPromise(request.text());
};
