import * as $webSocket from "$/gossamer/gossamer/web_socket.mjs";
import { fromBinaryType, toBinaryType } from "~/gossamer/binary_type.ffi.ts";
import { blobRef } from "~/gossamer/blob.ffi.ts";
import { toMessageEvent } from "~/gossamer/message_event.ffi.ts";
import { toReadyState } from "~/gossamer/ready_state.ffi.ts";
import { toArray } from "~/utils/list.ffi.ts";
import { toResult } from "~/utils/result.ffi.ts";

function toCloseEvent(event: CloseEvent): $webSocket.CloseEvent$ {
  return $webSocket.CloseEvent$CloseEvent(
    event.code,
    event.reason,
    event.wasClean,
  );
}

export const from_url_string: typeof $webSocket.from_url_string = (url) => {
  return toResult.fromThrows(() => new WebSocket(url));
};

export const from_url_string_with_protocols:
  typeof $webSocket.from_url_string_with_protocols = (url, protocols) => {
    return toResult.fromThrows(() => new WebSocket(url, toArray(protocols)));
  };

export const from_url: typeof $webSocket.from_url = (url) => {
  return toResult.fromThrows(() => new WebSocket(url.toString()));
};

export const from_url_with_protocols:
  typeof $webSocket.from_url_with_protocols = (url, protocols) => {
    return toResult.fromThrows(
      () => new WebSocket(url.toString(), toArray(protocols)),
    );
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
  return toReadyState(socket.readyState);
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
  return toResult.fromThrows(() => {
    socket.close(code, reason);
  });
};

export const send_string: typeof $webSocket.send_string = (socket, data) => {
  return toResult.fromThrows(() => {
    socket.send(data);
  });
};

export const send_bytes: typeof $webSocket.send_bytes = (socket, data) => {
  return toResult.fromThrows(() => {
    socket.send(data);
  });
};

export const send_blob: typeof $webSocket.send_blob = (socket, data) => {
  return toResult.fromThrows(() => {
    socket.send(blobRef(data));
  });
};

export const send_buffer: typeof $webSocket.send_buffer = (socket, data) => {
  return toResult.fromThrows(() => {
    socket.send(data);
  });
};

export const on_open: typeof $webSocket.on_open = (socket, handler) => {
  socket.onopen = () => handler();
};

export const on_message: typeof $webSocket.on_message = (socket, handler) => {
  socket.onmessage = (event) => handler(toMessageEvent(event));
};

export const on_error: typeof $webSocket.on_error = (socket, handler) => {
  socket.onerror = () => handler();
};

export const on_close: typeof $webSocket.on_close = (socket, handler) => {
  socket.onclose = (event) => handler(toCloseEvent(event));
};
