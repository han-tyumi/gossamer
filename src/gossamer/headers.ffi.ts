import type * as $headers from "$/gossamer/gossamer/headers.mjs";
import { Result$Error, Result$Ok } from "$/prelude.mjs";
import { fromArray, toArray } from "~/utils/list.ts";
import { toResult } from "~/utils/result.ts";

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
  try {
    const value = headers.get(name);
    return value === null ? Result$Error("not found") : Result$Ok(value);
  } catch (error) {
    return Result$Error(
      error instanceof Error ? error.message : String(error),
    );
  }
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
