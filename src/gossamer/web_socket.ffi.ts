import type * as $webSocket from "$/gossamer/gossamer/web_socket.mjs";
import { fromBinaryType, toBinaryType } from "~/gossamer/binary_type.ts";
import { toCloseEvent } from "~/gossamer/close_event.ts";
import { toArray } from "~/utils/list.ts";
import { toResult } from "~/utils/result.ts";

export type WebSocket$ = WebSocket;

export const new_: typeof $webSocket.new$ = (url) => {
  return toResult.fromThrows(() => new WebSocket(url));
};

export const new_with_protocols: typeof $webSocket.new_with_protocols = (
  url,
  protocols,
) => {
  return toResult.fromThrows(() => new WebSocket(url, toArray(protocols)));
};

export const binary_type: typeof $webSocket.binary_type = (socket) => {
  return toBinaryType(socket.binaryType);
};

export const set_binary_type: typeof $webSocket.set_binary_type = (
  socket,
  value,
) => {
  socket.binaryType = fromBinaryType(value);
};

export const buffered_amount: typeof $webSocket.buffered_amount = (socket) => {
  return socket.bufferedAmount;
};

export const extensions: typeof $webSocket.extensions = (socket) => {
  return socket.extensions;
};

export const protocol: typeof $webSocket.protocol = (socket) => {
  return socket.protocol;
};

export const ready_state: typeof $webSocket.ready_state = (socket) => {
  return socket.readyState;
};

export const url: typeof $webSocket.url = (socket) => {
  return socket.url;
};

export const close: typeof $webSocket.close = (socket) => {
  socket.close();
};

export const close_with: typeof $webSocket.close_with = (
  socket,
  code,
  reason,
) => {
  socket.close(code, reason);
};

export const send: typeof $webSocket.send = (socket, data) => {
  socket.send(data);
};

export const send_dynamic: typeof $webSocket.send_dynamic = (socket, data) => {
  socket.send(data as string | ArrayBufferLike | Blob | ArrayBufferView);
};

export const on_open: typeof $webSocket.on_open = (socket, handler) => {
  socket.onopen = () => handler();
};

export const on_message: typeof $webSocket.on_message = (socket, handler) => {
  socket.onmessage = (event) => handler(event);
};

export const on_error: typeof $webSocket.on_error = (socket, handler) => {
  socket.onerror = () => handler();
};

export const on_close: typeof $webSocket.on_close = (socket, handler) => {
  socket.onclose = (event) => handler(toCloseEvent(event));
};
