import type * as $headers from "$/gossamer/gossamer/headers.mjs";
import { fromArray, toArray } from "~/utils/list.ffi.ts";
import { toOption } from "~/utils/option.ffi.ts";
import { toResult } from "~/utils/result.ffi.ts";

export type Headers$ = Headers;

export const new_: typeof $headers.new$ = () => {
  return new Headers();
};

export const from_pairs: typeof $headers.from_pairs = (pairs) => {
  return toResult.fromThrows(() => new Headers(toArray(pairs)));
};

export const append: typeof $headers.append = (headers, name, value) => {
  return toResult.fromThrows(() => {
    headers.append(name, value);
    return headers;
  });
};

export const delete_: typeof $headers.delete$ = (headers, name) => {
  return toResult.fromThrows(() => {
    headers.delete(name);
    return headers;
  });
};

export const get: typeof $headers.get = (headers, name) => {
  return toResult.fromThrows(() => toOption(headers.get(name)));
};

export const has: typeof $headers.has = (headers, name) => {
  return toResult.fromThrows(() => headers.has(name));
};

export const set: typeof $headers.set = (headers, name, value) => {
  return toResult.fromThrows(() => {
    headers.set(name, value);
    return headers;
  });
};

export const get_set_cookie: typeof $headers.get_set_cookie = (headers) => {
  return fromArray(headers.getSetCookie());
};

export const keys: typeof $headers.keys = (headers) => {
  return headers.keys();
};

export const values: typeof $headers.values = (headers) => {
  return headers.values();
};

export const entries: typeof $headers.entries = (headers) => {
  return headers.entries();
};

export const for_each: typeof $headers.for_each = (headers, callback) => {
  headers.forEach((value, name) => callback(name, value));
};
