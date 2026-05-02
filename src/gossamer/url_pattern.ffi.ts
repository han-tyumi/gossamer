import * as $dict from "$/gleam_stdlib/gleam/dict.mjs";
import * as $urlPattern from "$/gossamer/gossamer/url_pattern.mjs";
import { fromArray, toArray } from "~/utils/list.ffi.ts";
import { toResult } from "~/utils/result.ffi.ts";

function toURLPatternInit(
  options: $urlPattern.URLPatternInit$[],
): URLPatternInit {
  const result: URLPatternInit = {};
  for (const option of options) {
    if ($urlPattern.URLPatternInit$isProtocol(option)) {
      result.protocol = $urlPattern.URLPatternInit$Protocol$0(option);
    } else if ($urlPattern.URLPatternInit$isUsername(option)) {
      result.username = $urlPattern.URLPatternInit$Username$0(option);
    } else if ($urlPattern.URLPatternInit$isPassword(option)) {
      result.password = $urlPattern.URLPatternInit$Password$0(option);
    } else if ($urlPattern.URLPatternInit$isHostname(option)) {
      result.hostname = $urlPattern.URLPatternInit$Hostname$0(option);
    } else if ($urlPattern.URLPatternInit$isPort(option)) {
      result.port = $urlPattern.URLPatternInit$Port$0(option);
    } else if ($urlPattern.URLPatternInit$isPathname(option)) {
      result.pathname = $urlPattern.URLPatternInit$Pathname$0(option);
    } else if ($urlPattern.URLPatternInit$isSearch(option)) {
      result.search = $urlPattern.URLPatternInit$Search$0(option);
    } else if ($urlPattern.URLPatternInit$isHash(option)) {
      result.hash = $urlPattern.URLPatternInit$Hash$0(option);
    } else if ($urlPattern.URLPatternInit$isBaseURL(option)) {
      result.baseURL = $urlPattern.URLPatternInit$BaseURL$0(option);
    }
  }
  return result;
}

function toComponentResult(
  component: URLPatternComponentResult,
): $urlPattern.URLPatternComponentResult$ {
  const entries = Object.entries(component.groups).filter(
    (entry): entry is [string, string] => typeof entry[1] === "string",
  );
  return $urlPattern.URLPatternComponentResult$URLPatternComponentResult(
    component.input,
    $dict.from_list(fromArray(entries)),
  );
}

function toURLPatternResult(
  result: URLPatternResult,
): $urlPattern.URLPatternResult$ {
  return $urlPattern.URLPatternResult$URLPatternResult(
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

function toURLPattern(pattern: URLPattern): $urlPattern.URLPattern$ {
  return $urlPattern.URLPattern$URLPattern(
    pattern.protocol,
    pattern.username,
    pattern.password,
    pattern.hostname,
    pattern.port,
    pattern.pathname,
    pattern.search,
    pattern.hash,
    pattern.hasRegExpGroups,
    pattern,
  );
}

function ref(pattern: $urlPattern.URLPattern$): URLPattern {
  return $urlPattern.URLPattern$URLPattern$ref(pattern);
}

export const new_: typeof $urlPattern.new$ = (init) => {
  return toResult.fromThrows(() =>
    toURLPattern(new URLPattern(toURLPatternInit(toArray(init))))
  );
};

export const from_string: typeof $urlPattern.from_string = (pattern) => {
  return toResult.fromThrows(() => toURLPattern(new URLPattern(pattern)));
};

export const from_string_with_base: typeof $urlPattern.from_string_with_base = (
  pattern,
  baseURL,
) => {
  return toResult.fromThrows(() =>
    toURLPattern(new URLPattern(pattern, baseURL))
  );
};

export const test_: typeof $urlPattern.test_ = (pattern, input) => {
  return ref(pattern).test(input);
};

export const test_with_base: typeof $urlPattern.test_with_base = (
  pattern,
  input,
  baseURL,
) => {
  return ref(pattern).test(input, baseURL);
};

export const exec: typeof $urlPattern.exec = (pattern, input) => {
  const result = ref(pattern).exec(input);
  return result === null
    ? toResult(null)
    : toResult(toURLPatternResult(result));
};

export const exec_with_base: typeof $urlPattern.exec_with_base = (
  pattern,
  input,
  baseURL,
) => {
  const result = ref(pattern).exec(input, baseURL);
  return result === null
    ? toResult(null)
    : toResult(toURLPatternResult(result));
};
