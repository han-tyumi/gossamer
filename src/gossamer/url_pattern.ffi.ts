import type * as $urlPattern from "$/gossamer/gossamer/url_pattern.mjs";
import { toURLPatternInit } from "~/gossamer/url_pattern_init.ts";
import { toURLPatternResult } from "~/gossamer/url_pattern_result.ts";
import { toArray } from "~/utils/list.ts";
import { toResult } from "~/utils/result.ts";

export type URLPattern$ = URLPattern;

export const new_: typeof $urlPattern.new$ = (init) => {
  return toResult.fromThrows(() =>
    new URLPattern(toURLPatternInit(toArray(init)))
  );
};

export const new_from_string: typeof $urlPattern.new_from_string = (
  pattern,
) => {
  return toResult.fromThrows(() => new URLPattern(pattern));
};

export const new_from_string_with_base:
  typeof $urlPattern.new_from_string_with_base = (
    pattern,
    baseURL,
  ) => {
    return toResult.fromThrows(() => new URLPattern(pattern, baseURL));
  };

export const test_: typeof $urlPattern.test_ = (pattern, input) => {
  return pattern.test(input);
};

export const test_with_base: typeof $urlPattern.test_with_base = (
  pattern,
  input,
  baseURL,
) => {
  return pattern.test(input, baseURL);
};

export const exec: typeof $urlPattern.exec = (pattern, input) => {
  const result = pattern.exec(input);
  return result === null
    ? toResult(null)
    : toResult(toURLPatternResult(result));
};

export const exec_with_base: typeof $urlPattern.exec_with_base = (
  pattern,
  input,
  baseURL,
) => {
  const result = pattern.exec(input, baseURL);
  return result === null
    ? toResult(null)
    : toResult(toURLPatternResult(result));
};

export const protocol: typeof $urlPattern.protocol = (pattern) => {
  return pattern.protocol;
};

export const username: typeof $urlPattern.username = (pattern) => {
  return pattern.username;
};

export const password: typeof $urlPattern.password = (pattern) => {
  return pattern.password;
};

export const hostname: typeof $urlPattern.hostname = (pattern) => {
  return pattern.hostname;
};

export const port: typeof $urlPattern.port = (pattern) => {
  return pattern.port;
};

export const pathname: typeof $urlPattern.pathname = (pattern) => {
  return pattern.pathname;
};

export const search: typeof $urlPattern.search = (pattern) => {
  return pattern.search;
};

export const hash: typeof $urlPattern.hash = (pattern) => {
  return pattern.hash;
};

export const has_reg_exp_groups: typeof $urlPattern.has_reg_exp_groups = (
  pattern,
) => {
  return pattern.hasRegExpGroups;
};
