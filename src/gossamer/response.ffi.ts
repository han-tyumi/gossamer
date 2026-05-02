import * as $response from "$/gossamer/gossamer/response.mjs";
import { fromResponseType } from "~/gossamer/response_type.ffi.ts";
import { fromHttpStatus, toHttpStatus } from "~/gossamer/http_status.ffi.ts";
import { toArray } from "~/utils/list.ffi.ts";
import { toResult } from "~/utils/result.ffi.ts";

export type Response$ = Response;

function toResponseInit(options: $response.ResponseInit$[]): ResponseInit {
  const result: ResponseInit = {};
  for (const option of options) {
    if ($response.ResponseInit$isHeaders(option)) {
      result.headers = $response.ResponseInit$Headers$0(option);
    } else if ($response.ResponseInit$isStatus(option)) {
      result.status = fromHttpStatus($response.ResponseInit$Status$0(option));
    } else if ($response.ResponseInit$isStatusText(option)) {
      result.statusText = $response.ResponseInit$StatusText$0(option);
    }
  }
  return result;
}

export const new_: typeof $response.new$ = () => new Response();

export const from_string: typeof $response.from_string = (body) => {
  return new Response(body);
};

export const from_string_with_init: typeof $response.from_string_with_init = (
  body,
  init,
) => {
  return toResult.fromThrows(
    () => new Response(body, toResponseInit(toArray(init))),
  );
};

export const from_bytes: typeof $response.from_bytes = (body) => {
  return new Response(body as BodyInit);
};

export const from_bytes_with_init: typeof $response.from_bytes_with_init = (
  body,
  init,
) => {
  return toResult.fromThrows(
    () => new Response(body as BodyInit, toResponseInit(toArray(init))),
  );
};

export const from_blob: typeof $response.from_blob = (body) => {
  return new Response(body);
};

export const from_blob_with_init: typeof $response.from_blob_with_init = (
  body,
  init,
) => {
  return toResult.fromThrows(
    () => new Response(body, toResponseInit(toArray(init))),
  );
};

export const from_buffer: typeof $response.from_buffer = (body) => {
  return new Response(body);
};

export const from_buffer_with_init: typeof $response.from_buffer_with_init = (
  body,
  init,
) => {
  return toResult.fromThrows(
    () => new Response(body, toResponseInit(toArray(init))),
  );
};

export const from_form_data: typeof $response.from_form_data = (body) => {
  return new Response(body);
};

export const from_form_data_with_init:
  typeof $response.from_form_data_with_init = (body, init) => {
    return toResult.fromThrows(
      () => new Response(body, toResponseInit(toArray(init))),
    );
  };

export const from_params: typeof $response.from_params = (body) => {
  return new Response(body);
};

export const from_params_with_init: typeof $response.from_params_with_init = (
  body,
  init,
) => {
  return toResult.fromThrows(
    () => new Response(body, toResponseInit(toArray(init))),
  );
};

export const from_stream: typeof $response.from_stream = (body) => {
  return toResult.fromThrows(() => new Response(body));
};

export const from_stream_with_init: typeof $response.from_stream_with_init = (
  body,
  init,
) => {
  return toResult.fromThrows(
    () => new Response(body, toResponseInit(toArray(init))),
  );
};

export const from_json: typeof $response.from_json = (data) => {
  return toResult.fromThrows(() => Response.json(data));
};

export const from_json_with_init: typeof $response.from_json_with_init = (
  data,
  init,
) => {
  return toResult.fromThrows(() =>
    Response.json(data, toResponseInit(toArray(init)))
  );
};

export const error: typeof $response.error = () => {
  return Response.error();
};

export const redirect: typeof $response.redirect = (url) => {
  return toResult.fromThrows(() => Response.redirect(url));
};

export const redirect_with_status: typeof $response.redirect_with_status = (
  url,
  status,
) => {
  return toResult.fromThrows(() =>
    Response.redirect(url, fromHttpStatus(status))
  );
};

export const headers_: typeof $response.headers = (response) => {
  return response.headers;
};

export const is_ok: typeof $response.is_ok = (response) => response.ok;

export const is_redirected: typeof $response.is_redirected = (response) => {
  return response.redirected;
};

export const status: typeof $response.status = (response) => {
  return toHttpStatus(response.status);
};

export const status_text: typeof $response.status_text = (response) => {
  return response.statusText;
};

export const type_: typeof $response.type_ = (response) => {
  return fromResponseType(response.type);
};

export const url: typeof $response.url = (response) => response.url;

export const clone: typeof $response.clone = (response) => {
  return toResult.fromThrows(() => response.clone());
};

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
