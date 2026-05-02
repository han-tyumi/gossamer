import type * as $url from "$/gossamer/gossamer/url.mjs";
import { blobRef } from "~/gossamer/blob.ffi.ts";
import { toResult } from "~/utils/result.ffi.ts";

export const new_: typeof $url.new$ = (url) => {
  return toResult.fromThrows(() => new URL(url));
};

export const new_with_base: typeof $url.new_with_base = (url, base) => {
  return toResult.fromThrows(() => new URL(url, base));
};

export const parse: typeof $url.parse = (url) => {
  return toResult(URL.parse(url));
};

export const parse_with_base: typeof $url.parse_with_base = (url, base) => {
  return toResult(URL.parse(url, base));
};

export const can_parse: typeof $url.can_parse = (url) => {
  return URL.canParse(url);
};

export const can_parse_with_base: typeof $url.can_parse_with_base = (
  url,
  base,
) => {
  return URL.canParse(url, base);
};

export const hash: typeof $url.hash = (url) => url.hash;
export const set_hash: typeof $url.set_hash = (url, hash) => {
  url.hash = hash;
  return url;
};

export const host: typeof $url.host = (url) => url.host;
export const set_host: typeof $url.set_host = (url, host) => {
  url.host = host;
  return url;
};

export const hostname: typeof $url.hostname = (url) => url.hostname;
export const set_hostname: typeof $url.set_hostname = (url, hostname) => {
  url.hostname = hostname;
  return url;
};

export const href: typeof $url.href = (url) => url.href;
export const set_href: typeof $url.set_href = (url, href) => {
  return toResult.fromThrows(() => {
    url.href = href;
    return url;
  });
};

export const origin: typeof $url.origin = (url) => url.origin;

export const password: typeof $url.password = (url) => url.password;
export const set_password: typeof $url.set_password = (url, password) => {
  url.password = password;
  return url;
};

export const pathname: typeof $url.pathname = (url) => url.pathname;
export const set_pathname: typeof $url.set_pathname = (url, pathname) => {
  url.pathname = pathname;
  return url;
};

export const port: typeof $url.port = (url) => url.port;
export const set_port: typeof $url.set_port = (url, port) => {
  url.port = port;
  return url;
};

export const protocol: typeof $url.protocol = (url) => url.protocol;
export const set_protocol: typeof $url.set_protocol = (url, protocol) => {
  url.protocol = protocol;
  return url;
};

export const search: typeof $url.search = (url) => url.search;
export const set_search: typeof $url.set_search = (url, search) => {
  url.search = search;
  return url;
};

export const search_params: typeof $url.search_params = (url) => {
  return url.searchParams;
};

export const username: typeof $url.username = (url) => url.username;
export const set_username: typeof $url.set_username = (url, username) => {
  url.username = username;
  return url;
};

export const to_string: typeof $url.to_string = (url) => url.toString();
export const to_json: typeof $url.to_json = (url) => url.toJSON();

export const create_object_url: typeof $url.create_object_url = (blob) => {
  return URL.createObjectURL(blobRef(blob));
};

export const revoke_object_url: typeof $url.revoke_object_url = (url) => {
  URL.revokeObjectURL(url);
};
