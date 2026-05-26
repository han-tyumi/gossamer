import type * as $url from "$/gossamer/gossamer/url.mjs";
import { parse as parseUri } from "$/gleam_stdlib/gleam/uri.mjs";
import { Result$Error } from "$/prelude.mjs";
import { optionToValue } from "~/utils/option.ffi.ts";

export const parse: typeof $url.parse = (url, base) => {
  const baseURL = optionToValue(base);
  try {
    const href = baseURL === undefined
      ? new URL(url).href
      : new URL(url, baseURL).href;
    return parseUri(href);
  } catch {
    return Result$Error(undefined);
  }
};

export const is_valid: typeof $url.is_valid = (url) => {
  return URL.canParse(url);
};
