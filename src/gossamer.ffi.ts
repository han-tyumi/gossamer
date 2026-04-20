import type * as $gossamer from "$/gossamer/gossamer.mjs";
import { toRequestInit } from "~/gossamer/request.ffi.ts";
import { toArray } from "~/utils/list.ffi.ts";
import { toResult } from "~/utils/result.ffi.ts";

export const structured_clone: typeof $gossamer.structured_clone = (value) => {
  return toResult.fromThrows(() => globalThis.structuredClone(value));
};

export const atob: typeof $gossamer.atob = (encoded) => {
  return toResult.fromThrows(() => globalThis.atob(encoded));
};

export const btoa: typeof $gossamer.btoa = (data) => {
  return toResult.fromThrows(() => globalThis.btoa(data));
};

export const clear_interval: typeof $gossamer.clear_interval = (id) => {
  globalThis.clearInterval(id);
};

export const clear_timeout: typeof $gossamer.clear_timeout = (id) => {
  globalThis.clearTimeout(id);
};

export const queue_microtask: typeof $gossamer.queue_microtask = (func) => {
  globalThis.queueMicrotask(func);
};

export const set_interval: typeof $gossamer.set_interval = (
  delay,
  callback,
) => {
  return globalThis.setInterval(callback, delay);
};

export const set_timeout: typeof $gossamer.set_timeout = (delay, callback) => {
  return globalThis.setTimeout(callback, delay);
};

export const user_agent: typeof $gossamer.user_agent = () => {
  return globalThis.navigator.userAgent;
};

export const fetch_: typeof $gossamer.fetch = (url) => {
  return toResult.fromPromise(globalThis.fetch(url));
};

export const fetch_url: typeof $gossamer.fetch_url = (url) => {
  return toResult.fromPromise(globalThis.fetch(url));
};

export const fetch_with: typeof $gossamer.fetch_with = (
  url,
  init,
) => {
  return toResult.fromPromise(
    globalThis.fetch(url, toRequestInit(toArray(init))),
  );
};

export const fetch_url_with: typeof $gossamer.fetch_url_with = (
  url,
  init,
) => {
  return toResult.fromPromise(
    globalThis.fetch(url, toRequestInit(toArray(init))),
  );
};

export const fetch_request: typeof $gossamer.fetch_request = (request) => {
  return toResult.fromPromise(globalThis.fetch(request));
};

export const fetch_request_with: typeof $gossamer.fetch_request_with = (
  request,
  init,
) => {
  return toResult.fromPromise(
    globalThis.fetch(request, toRequestInit(toArray(init))),
  );
};
