import type * as $url from "$/gossamer/gossamer/url.mjs";
import { parse as parseUri } from "$/gleam_stdlib/gleam/uri.mjs";
import { Result$Error } from "$/prelude.mjs";

export const parse: typeof $url.parse = (url) => {
  if (!URL.canParse(url)) {
    return Result$Error(undefined);
  }
  return parseUri(url);
};

export const is_valid: typeof $url.is_valid = (url) => {
  return URL.canParse(url);
};
