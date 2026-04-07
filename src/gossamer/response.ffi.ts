import type * as $response from "$/gossamer/gossamer/response.mjs";
import { toResponseInit } from "~/gossamer/response_init.ts";
import { toArray } from "~/utils/list.ts";
import { toOption } from "~/utils/option.ts";

export type Response$ = Response;

export const new_: typeof $response.new$ = (body) => {
  return new Response(body);
};

export const new_with_init: typeof $response.new_with_init = (body, init) => {
  return new Response(body, toResponseInit(toArray(init)));
};

export const json: typeof $response.json = (data, init) => {
  return Response.json(data, toResponseInit(toArray(init)));
};

export const error: typeof $response.error = () => {
  return Response.error();
};

export const redirect: typeof $response.redirect = (url) => {
  return Response.redirect(url);
};

export const redirect_with_status: typeof $response.redirect_with_status = (
  url,
  status,
) => {
  return Response.redirect(url, status);
};

export const headers_: typeof $response.headers = (response) => {
  return response.headers;
};

export const ok: typeof $response.ok = (response) => response.ok;

export const redirected: typeof $response.redirected = (response) => {
  return response.redirected;
};

export const status: typeof $response.status = (response) => response.status;

export const status_text: typeof $response.status_text = (response) => {
  return response.statusText;
};

export const type_: typeof $response.type_ = (response) => response.type;

export const url: typeof $response.url = (response) => response.url;

export const clone: typeof $response.clone = (response) => response.clone();

export const body: typeof $response.body = (response) => {
  return toOption(response.body);
};

export const body_used: typeof $response.body_used = (response) => {
  return response.bodyUsed;
};

export const array_buffer: typeof $response.array_buffer = (response) => {
  return response.arrayBuffer();
};

export const bytes: typeof $response.bytes = (response) => {
  return response.bytes();
};

export const json_body: typeof $response.json_body = (response) => {
  return response.json();
};

export const text: typeof $response.text = (response) => {
  return response.text();
};
