import type * as $fetch from "$/gleam_fetch/gleam/fetch.mjs";
import type * as $fetchExtra from "$/gossamer/gossamer/fetch_extra.mjs";
import * as $response from "$/gleam_http/gleam/http/response.mjs";
import { Result$Error, Result$Ok } from "$/prelude.mjs";
import {
  bitarray_request_to_fetch_request,
  FetchError$NetworkError,
  form_data_to_fetch_request,
  from_fetch_response,
  to_fetch_request,
} from "$/gleam_fetch/gleam/fetch.mjs";
import { buildInit } from "~/gossamer/fetch_options.ffi.ts";
import { fromResponseType } from "~/gossamer/response_type.ffi.ts";

function jsResponseOf(
  response: $response.Response$<$fetch.FetchBody$>,
): Response {
  return $response.Response$Response$body(response);
}

export const response_url: typeof $fetchExtra.response_url = (response) => {
  return jsResponseOf(response).url;
};

export const is_response_redirected: typeof $fetchExtra.is_response_redirected =
  (response) => {
    return jsResponseOf(response).redirected;
  };

export const is_response_body_used: typeof $fetchExtra.is_response_body_used = (
  response,
) => {
  return jsResponseOf(response).bodyUsed;
};

export const response_type: typeof $fetchExtra.response_type = (response) => {
  return fromResponseType(jsResponseOf(response).type);
};

async function send_internal(jsRequest: Request, init: RequestInit) {
  try {
    const jsResponse = await globalThis.fetch(jsRequest, init);
    return Result$Ok(from_fetch_response(jsResponse));
  } catch (error) {
    return Result$Error(FetchError$NetworkError(String(error)));
  }
}

export const send: typeof $fetchExtra.send = (request, options) =>
  send_internal(to_fetch_request(request), buildInit(options));

export const send_bits: typeof $fetchExtra.send_bits = (request, options) =>
  send_internal(bitarray_request_to_fetch_request(request), buildInit(options));

export const send_form_data: typeof $fetchExtra.send_form_data = (
  request,
  options,
) => send_internal(form_data_to_fetch_request(request), buildInit(options));
