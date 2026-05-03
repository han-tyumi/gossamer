import * as $response from "$/gossamer/gossamer/response.mjs";
import { fromResponseType } from "~/gossamer/response_type.ffi.ts";
import { fromHttpStatus, toHttpStatus } from "~/gossamer/http_status.ffi.ts";
import { unwrap as unwrapTypedArray } from "~/gossamer/typed_array.ffi.ts";
import { toArray } from "~/utils/list.ffi.ts";
import { toOption } from "~/utils/option.ffi.ts";
import { toResult } from "~/utils/result.ffi.ts";

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

export const to_fields: typeof $response.to_fields = (response) => {
  return $response.Fields$Fields(
    toHttpStatus(response.status),
    response.statusText,
    fromResponseType(response.type),
    response.url,
    response.ok,
    response.redirected,
    response.headers,
    toOption(
      response.body as ReadableStream<Uint8Array> | null,
    ),
  );
};

export const new_: typeof $response.new$ = () => new Response();

export const from_blob: typeof $response.from_blob = (body) => {
  return new Response(body);
};

export const from_blob_with: typeof $response.from_blob_with = (
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

export const from_buffer_with: typeof $response.from_buffer_with = (
  body,
  init,
) => {
  return toResult.fromThrows(
    () => new Response(body, toResponseInit(toArray(init))),
  );
};

export const from_data_view: typeof $response.from_data_view = (body) => {
  return new Response(body as unknown as BodyInit);
};

export const from_data_view_with: typeof $response.from_data_view_with = (
  body,
  init,
) => {
  return toResult.fromThrows(
    () =>
      new Response(
        body as unknown as BodyInit,
        toResponseInit(toArray(init)),
      ),
  );
};

export const from_form_data: typeof $response.from_form_data = (body) => {
  return new Response(body);
};

export const from_form_data_with: typeof $response.from_form_data_with = (
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

export const from_json_with: typeof $response.from_json_with = (
  data,
  init,
) => {
  return toResult.fromThrows(() =>
    Response.json(data, toResponseInit(toArray(init)))
  );
};

export const from_params: typeof $response.from_params = (body) => {
  return new Response(body);
};

export const from_params_with: typeof $response.from_params_with = (
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

export const from_stream_with: typeof $response.from_stream_with = (
  body,
  init,
) => {
  return toResult.fromThrows(
    () => new Response(body, toResponseInit(toArray(init))),
  );
};

export const from_string: typeof $response.from_string = (body) => {
  return new Response(body);
};

export const from_string_with: typeof $response.from_string_with = (
  body,
  init,
) => {
  return toResult.fromThrows(
    () => new Response(body, toResponseInit(toArray(init))),
  );
};

export const from_typed_array: typeof $response.from_typed_array = (body) => {
  return new Response(unwrapTypedArray(body) as BodyInit);
};

export const from_typed_array_with: typeof $response.from_typed_array_with = (
  body,
  init,
) => {
  return toResult.fromThrows(
    () =>
      new Response(
        unwrapTypedArray(body) as BodyInit,
        toResponseInit(toArray(init)),
      ),
  );
};

export const error: typeof $response.error = () => {
  return Response.error();
};

export const redirect: typeof $response.redirect = (url) => {
  return toResult.fromThrows(() => Response.redirect(url));
};

export const redirect_url: typeof $response.redirect_url = (url) => {
  return Response.redirect(url.toString());
};

export const redirect_with_status: typeof $response.redirect_with_status = (
  url,
  status,
) => {
  return toResult.fromThrows(() =>
    Response.redirect(url, fromHttpStatus(status))
  );
};

export const redirect_url_with_status:
  typeof $response.redirect_url_with_status = (url, status) => {
    return toResult.fromThrows(() =>
      Response.redirect(url.toString(), fromHttpStatus(status))
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
