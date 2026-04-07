import type * as $gossamer from "$/gossamer/gossamer.mjs";
import { toRequestInit } from "~/gossamer/request_init.ts";
import { toArray } from "~/utils/list.ts";
import { toOption } from "~/utils/option.ts";

export type Date$ = Date;

export const alert: typeof $gossamer.alert = (message) => {
  globalThis.alert(message);
};

export const clear_interval: typeof $gossamer.clear_interval = (id) => {
  globalThis.clearInterval(id);
};

export const clear_timeout: typeof $gossamer.clear_timeout = (id) => {
  globalThis.clearTimeout(id);
};

export const close: typeof $gossamer.close = () => {
  globalThis.close();
};

export const confirm: typeof $gossamer.confirm = (message) => {
  return globalThis.confirm(message);
};

export const prompt: typeof $gossamer.prompt = (message, defaultValue) => {
  return toOption(globalThis.prompt(message, defaultValue));
};

export const queue_microtask: typeof $gossamer.queue_microtask = (func) => {
  globalThis.queueMicrotask(func);
};

export const report_error: typeof $gossamer.report_error = (error) => {
  globalThis.reportError(error);
};

export const set_interval: typeof $gossamer.set_interval = (delay, callback) => {
  return globalThis.setInterval(callback, delay);
};

export const set_timeout: typeof $gossamer.set_timeout = (delay, callback) => {
  return globalThis.setTimeout(callback, delay);
};

export const fetch_: typeof $gossamer.fetch = (url) => {
  return globalThis.fetch(url);
};

export const fetch_with_init: typeof $gossamer.fetch_with_init = (url, init) => {
  return globalThis.fetch(url, toRequestInit(toArray(init)));
};

export const fetch_request: typeof $gossamer.fetch_request = (request) => {
  return globalThis.fetch(request);
};
