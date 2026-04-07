import type * as $headers from "$/gossamer/gossamer/headers.mjs";
import { fromArray, toArray } from "~/utils/list.ts";
import { toOption } from "~/utils/option.ts";

export type Headers$ = Headers;

export const new_: typeof $headers.new$ = () => {
  return new Headers();
};

export const from_pairs: typeof $headers.from_pairs = (pairs) => {
  return new Headers(toArray(pairs));
};

export const append: typeof $headers.append = (headers, name, value) => {
  headers.append(name, value);
  return headers;
};

export const delete_: typeof $headers.delete$ = (headers, name) => {
  headers.delete(name);
  return headers;
};

export const get: typeof $headers.get = (headers, name) => {
  return toOption(headers.get(name));
};

export const has: typeof $headers.has = (headers, name) => {
  return headers.has(name);
};

export const set: typeof $headers.set = (headers, name, value) => {
  headers.set(name, value);
  return headers;
};

export const get_set_cookie: typeof $headers.get_set_cookie = (headers) => {
  return fromArray(headers.getSetCookie());
};

export const keys: typeof $headers.keys = (headers) => {
  return fromArray(Array.from(headers.keys()));
};

export const values: typeof $headers.values = (headers) => {
  return fromArray(Array.from(headers.values()));
};

export const entries: typeof $headers.entries = (headers) => {
  return fromArray(Array.from(headers.entries()));
};

export const for_each: typeof $headers.for_each = (headers, callback) => {
  headers.forEach((value, key) => callback(value, key));
};
