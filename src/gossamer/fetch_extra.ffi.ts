import type * as $fetch from "$/gleam_fetch/gleam/fetch.mjs";
import type * as $fetchExtra from "$/gossamer/gossamer/fetch_extra.mjs";
import * as $http from "$/gleam_http/gleam/http.mjs";
import * as $request from "$/gleam_http/gleam/http/request.mjs";
import * as $response from "$/gleam_http/gleam/http/response.mjs";
import { Result$Error, Result$Ok } from "$/prelude.mjs";
import {
  bitarray_request_to_fetch_request,
  FetchError$NetworkError,
  form_data_to_fetch_request,
  from_fetch_response,
  to_fetch_request,
} from "$/gleam_fetch/gleam/fetch.mjs";
import { to_string as uri_to_string } from "$/gleam_stdlib/gleam/uri.mjs";
import { buildInit } from "~/gossamer/fetch_options.ffi.ts";
import { fromResponseType } from "~/gossamer/response_type.ffi.ts";
import { fromBitArrayReadable } from "~/utils/bit_array.ffi.ts";
import { toArray } from "~/utils/list.ffi.ts";

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

export const send_stream: typeof $fetchExtra.send_stream = (
  request,
  options,
) => {
  const url = uri_to_string($request.to_uri(request));
  const method = $http.method_to_string(
    $request.Request$Request$method(request),
  ).toUpperCase();
  const headers = new Headers();
  for (
    const [name, value] of toArray($request.Request$Request$headers(request))
  ) {
    headers.append(name.toLowerCase(), value);
  }
  const init: RequestInit = { headers, method };
  if (method !== "GET" && method !== "HEAD") {
    init.body = fromBitArrayReadable($request.Request$Request$body(request));
    init.duplex = "half";
  }
  return send_internal(new Request(url, init), buildInit(options));
};
