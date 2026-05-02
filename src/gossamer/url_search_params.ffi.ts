import type * as $urlSearchParams from "$/gossamer/gossamer/url_search_params.mjs";
import { fromArray, toArray } from "~/utils/list.ffi.ts";
import { toResult } from "~/utils/result.ffi.ts";

export const new_: typeof $urlSearchParams.new$ = () => {
  return new URLSearchParams();
};

export const from_string: typeof $urlSearchParams.from_string = (query) => {
  return new URLSearchParams(query);
};

export const from_pairs: typeof $urlSearchParams.from_pairs = (pairs) => {
  return new URLSearchParams(toArray(pairs));
};

export const append: typeof $urlSearchParams.append = (params, name, value) => {
  params.append(name, value);
  return params;
};

export const delete_: typeof $urlSearchParams.delete$ = (params, name) => {
  params.delete(name);
  return params;
};

export const delete_value: typeof $urlSearchParams.delete_value = (
  params,
  name,
  value,
) => {
  params.delete(name, value);
  return params;
};

export const get: typeof $urlSearchParams.get = (params, name) => {
  return toResult(params.get(name));
};

export const get_all: typeof $urlSearchParams.get_all = (params, name) => {
  return fromArray(params.getAll(name));
};

export const has: typeof $urlSearchParams.has = (params, name) => {
  return params.has(name);
};

export const has_value: typeof $urlSearchParams.has_value = (
  params,
  name,
  value,
) => {
  return params.has(name, value);
};

export const set: typeof $urlSearchParams.set = (params, name, value) => {
  params.set(name, value);
  return params;
};

export const sort: typeof $urlSearchParams.sort = (params) => {
  params.sort();
  return params;
};

export const for_each: typeof $urlSearchParams.for_each = (
  params,
  callback,
) => {
  params.forEach((value, name) => callback(name, value));
};

export const keys: typeof $urlSearchParams.keys = (params) => {
  return params.keys();
};

export const values: typeof $urlSearchParams.values = (params) => {
  return params.values();
};

export const entries: typeof $urlSearchParams.entries = (params) => {
  return params.entries();
};

export const to_string: typeof $urlSearchParams.to_string = (params) => {
  return params.toString();
};

export const size: typeof $urlSearchParams.size = (params) => {
  return params.size;
};
