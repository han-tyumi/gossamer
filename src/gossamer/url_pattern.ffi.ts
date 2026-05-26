import * as $dict from "$/gleam_stdlib/gleam/dict.mjs";
import {
  type Option$,
  Option$isNone,
  Option$Some$0,
} from "$/gleam_stdlib/gleam/option.mjs";
import * as $urlPattern from "$/gossamer/gossamer/url_pattern.mjs";
import { Result$Error, Result$Ok } from "$/prelude.mjs";
import { fromArray } from "~/utils/list.ffi.ts";
import { setIfSome } from "~/utils/option.ffi.ts";
import { toResult } from "~/utils/result.ffi.ts";

function optionToValue(option: Option$<string>): string | undefined {
  return Option$isNone(option) ? undefined : Option$Some$0(option);
}

function invalidPattern() {
  return Result$Error(undefined);
}

function toComponentResult(
  component: URLPatternComponentResult,
): $urlPattern.ComponentMatch$ {
  const entries = Object.entries(component.groups).filter(
    (entry): entry is [string, string] => typeof entry[1] === "string",
  );
  return $urlPattern.ComponentMatch$ComponentMatch(
    component.input,
    $dict.from_list(fromArray(entries)),
  );
}

function toMatch(result: URLPatternResult): $urlPattern.Match$ {
  return $urlPattern.Match$Match(
    toComponentResult(result.protocol),
    toComponentResult(result.username),
    toComponentResult(result.password),
    toComponentResult(result.hostname),
    toComponentResult(result.port),
    toComponentResult(result.pathname),
    toComponentResult(result.search),
    toComponentResult(result.hash),
  );
}

export const build: typeof $urlPattern.do_build = (
  protocol,
  username,
  password,
  hostname,
  port,
  pathname,
  search,
  hash,
  base_url,
  ignore_case,
) => {
  const init: URLPatternInit = {};
  setIfSome(init, "protocol", protocol);
  setIfSome(init, "username", username);
  setIfSome(init, "password", password);
  setIfSome(init, "hostname", hostname);
  setIfSome(init, "port", port);
  setIfSome(init, "pathname", pathname);
  setIfSome(init, "search", search);
  setIfSome(init, "hash", hash);
  setIfSome(init, "baseURL", base_url);
  try {
    return Result$Ok(new URLPattern(init, { ignoreCase: ignore_case }));
  } catch {
    return invalidPattern();
  }
};

export const parse: typeof $urlPattern.parse = (pattern, base, ignore_case) => {
  try {
    const baseURL = optionToValue(base);
    const options: URLPatternOptions = { ignoreCase: ignore_case };
    return Result$Ok(
      baseURL === undefined
        ? new URLPattern(pattern, options)
        : new URLPattern(pattern, baseURL, options),
    );
  } catch {
    return invalidPattern();
  }
};

export const matches: typeof $urlPattern.matches = (pattern, input, base) => {
  const baseURL = optionToValue(base);
  return baseURL === undefined
    ? pattern.test(input)
    : pattern.test(input, baseURL);
};

export const exec: typeof $urlPattern.exec = (pattern, input, base) => {
  const baseURL = optionToValue(base);
  const result = baseURL === undefined
    ? pattern.exec(input)
    : pattern.exec(input, baseURL);
  return result === null ? toResult(null) : toResult(toMatch(result));
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
