import type * as $request from "$/gossamer/gossamer/request.mjs";
import { toRequestInit } from "~/gossamer/request_init.ts";
import { toArray } from "~/utils/list.ts";
import { toOption } from "~/utils/option.ts";

export type Request$ = Request;

export const new_: typeof $request.new$ = (input) => {
  return new Request(input);
};

export const new_with_init: typeof $request.new_with_init = (input, init) => {
  return new Request(input, toRequestInit(toArray(init)));
};

export const method: typeof $request.method = (request) => request.method;
export const url: typeof $request.url = (request) => request.url;
export const headers: typeof $request.headers = (request) => request.headers;
export const cache: typeof $request.cache = (request) => request.cache;

export const credentials: typeof $request.credentials = (request) => {
  return request.credentials;
};

export const destination: typeof $request.destination = (request) => {
  return request.destination;
};

export const redirect: typeof $request.redirect = (request) => request.redirect;
export const signal: typeof $request.signal = (request) => request.signal;
export const referrer: typeof $request.referrer = (request) => request.referrer;

export const referrer_policy: typeof $request.referrer_policy = (request) => {
  return request.referrerPolicy;
};

export const mode: typeof $request.mode = (request) => request.mode;

export const keepalive: typeof $request.keepalive = (request) => {
  return request.keepalive;
};

export const is_history_navigation: typeof $request.is_history_navigation = (
  request,
) => {
  return request.isHistoryNavigation;
};

export const is_reload_navigation: typeof $request.is_reload_navigation = (
  request,
) => {
  return request.isReloadNavigation;
};

export const integrity: typeof $request.integrity = (request) => {
  return request.integrity;
};

export const clone: typeof $request.clone = (request) => request.clone();

export const body: typeof $request.body = (request) => {
  return toOption(request.body);
};

export const body_used: typeof $request.body_used = (request) => {
  return request.bodyUsed;
};

export const array_buffer: typeof $request.array_buffer = (request) => {
  return request.arrayBuffer();
};

export const bytes: typeof $request.bytes = (request) => {
  return request.bytes();
};

export const json: typeof $request.json = (request) => {
  return request.json();
};

export const text: typeof $request.text = (request) => {
  return request.text();
};
