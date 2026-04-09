import type * as $response from "$/gossamer/gossamer/response.mjs";
import { toResponseInit } from "~/gossamer/response_init.ts";
import { fromResponseType } from "~/gossamer/response_type.ts";
import { toArray } from "~/utils/list.ts";
import { toResult } from "~/utils/result.ts";

export type Response$ = Response;

export const new_: typeof $response.new$ = (body) => {
  return toResult.fromThrows(() => new Response(body));
};

export const new_with_init: typeof $response.new_with_init = (body, init) => {
  return toResult.fromThrows(
    () => new Response(body, toResponseInit(toArray(init))),
  );
};

export const from_json: typeof $response.from_json = (data, init) => {
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

export const is_ok: typeof $response.is_ok = (response) => response.ok;

export const is_redirected: typeof $response.is_redirected = (response) => {
  return response.redirected;
};

export const status: typeof $response.status = (response) => response.status;

export const status_text: typeof $response.status_text = (response) => {
  return response.statusText;
};

export const type_: typeof $response.type_ = (response) => {
  return fromResponseType(response.type);
};

export const url: typeof $response.url = (response) => response.url;

export const clone: typeof $response.clone = (response) => response.clone();

export const body: typeof $response.body = (response) => {
  return toResult(response.body);
};

export const is_body_used: typeof $response.is_body_used = (response) => {
  return response.bodyUsed;
};

export const blob: typeof $response.blob = (response) => {
  return toResult.fromPromise(response.blob());
};

export const array_buffer: typeof $response.array_buffer = (response) => {
  return toResult.fromPromise(response.arrayBuffer());
};

export const bytes: typeof $response.bytes = (response) => {
  return toResult.fromPromise(response.bytes());
};

export const json: typeof $response.json = (response) => {
  return toResult.fromPromise(response.json());
};

export const form_data: typeof $response.form_data = (response) => {
  return toResult.fromPromise(response.formData());
};

export const text: typeof $response.text = (response) => {
  return toResult.fromPromise(response.text());
};
