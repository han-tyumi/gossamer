import * as $response from "$/gossamer/gossamer/response.mjs";
import { blobRef, toBlob } from "~/gossamer/blob.ffi.ts";
import { fromResponseType } from "~/gossamer/response_type.ffi.ts";
import { fromHttpStatus, toHttpStatus } from "~/gossamer/http_status.ffi.ts";
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

export function toResponse(response: Response): $response.Response$ {
  return $response.Response$Response(
    toHttpStatus(response.status),
    response.statusText,
    fromResponseType(response.type),
    response.url,
    response.ok,
    response.redirected,
    response.headers,
    toOption(response.body),
    response,
  );
}

function ref(response: $response.Response$): Response {
  return $response.Response$Response$ref(response);
}

export const new_: typeof $response.new$ = () => toResponse(new Response());

export const from_string: typeof $response.from_string = (body) => {
  return toResponse(new Response(body));
};

export const from_string_with: typeof $response.from_string_with = (
  body,
  init,
) => {
  return toResult.fromThrows(
    () => toResponse(new Response(body, toResponseInit(toArray(init)))),
  );
};

export const from_bytes: typeof $response.from_bytes = (body) => {
  return toResponse(new Response(body as BodyInit));
};

export const from_bytes_with: typeof $response.from_bytes_with = (
  body,
  init,
) => {
  return toResult.fromThrows(
    () =>
      toResponse(new Response(body as BodyInit, toResponseInit(toArray(init)))),
  );
};

export const from_blob: typeof $response.from_blob = (body) => {
  return toResponse(new Response(blobRef(body)));
};

export const from_blob_with: typeof $response.from_blob_with = (
  body,
  init,
) => {
  return toResult.fromThrows(
    () =>
      toResponse(new Response(blobRef(body), toResponseInit(toArray(init)))),
  );
};

export const from_buffer: typeof $response.from_buffer = (body) => {
  return toResponse(new Response(body));
};

export const from_buffer_with: typeof $response.from_buffer_with = (
  body,
  init,
) => {
  return toResult.fromThrows(
    () => toResponse(new Response(body, toResponseInit(toArray(init)))),
  );
};

export const from_form_data: typeof $response.from_form_data = (body) => {
  return toResponse(new Response(body));
};

export const from_form_data_with: typeof $response.from_form_data_with = (
  body,
  init,
) => {
  return toResult.fromThrows(
    () => toResponse(new Response(body, toResponseInit(toArray(init)))),
  );
};

export const from_params: typeof $response.from_params = (body) => {
  return toResponse(new Response(body));
};

export const from_params_with: typeof $response.from_params_with = (
  body,
  init,
) => {
  return toResult.fromThrows(
    () => toResponse(new Response(body, toResponseInit(toArray(init)))),
  );
};

export const from_stream: typeof $response.from_stream = (body) => {
  return toResult.fromThrows(() => toResponse(new Response(body)));
};

export const from_stream_with: typeof $response.from_stream_with = (
  body,
  init,
) => {
  return toResult.fromThrows(
    () => toResponse(new Response(body, toResponseInit(toArray(init)))),
  );
};

export const from_json: typeof $response.from_json = (data) => {
  return toResult.fromThrows(() => toResponse(Response.json(data)));
};

export const from_json_with: typeof $response.from_json_with = (
  data,
  init,
) => {
  return toResult.fromThrows(() =>
    toResponse(Response.json(data, toResponseInit(toArray(init))))
  );
};

export const error: typeof $response.error = () => {
  return toResponse(Response.error());
};

export const redirect: typeof $response.redirect = (url) => {
  return toResult.fromThrows(() => toResponse(Response.redirect(url)));
};

export const redirect_url: typeof $response.redirect_url = (url) => {
  return toResponse(Response.redirect(url.toString()));
};

export const redirect_with_status: typeof $response.redirect_with_status = (
  url,
  status,
) => {
  return toResult.fromThrows(() =>
    toResponse(Response.redirect(url, fromHttpStatus(status)))
  );
};

export const redirect_url_with_status:
  typeof $response.redirect_url_with_status = (url, status) => {
    return toResult.fromThrows(() =>
      toResponse(Response.redirect(url.toString(), fromHttpStatus(status)))
    );
  };

export const clone: typeof $response.clone = (response) => {
  return toResult.fromThrows(() => toResponse(ref(response).clone()));
};

export const is_body_used: typeof $response.is_body_used = (response) => {
  return ref(response).bodyUsed;
};

export const blob: typeof $response.blob = (response) => {
  return toResult.fromPromise(ref(response).blob().then(toBlob));
};

export const array_buffer: typeof $response.array_buffer = (response) => {
  return toResult.fromPromise(ref(response).arrayBuffer());
};

export const bytes: typeof $response.bytes = (response) => {
  return toResult.fromPromise(ref(response).bytes());
};

export const json: typeof $response.json = (response) => {
  return toResult.fromPromise(ref(response).json());
};

export const form_data: typeof $response.form_data = (response) => {
  return toResult.fromPromise(ref(response).formData());
};

export const text: typeof $response.text = (response) => {
  return toResult.fromPromise(ref(response).text());
};
