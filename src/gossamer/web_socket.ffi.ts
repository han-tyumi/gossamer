import * as $webSocket from "$/gossamer/gossamer/web_socket.mjs";
import { BitArray$BitArray, Result$Error, Result$Ok } from "$/prelude.mjs";
import { toBufferSource } from "~/utils/bit_array.ffi.ts";
import { toArray } from "~/utils/list.ffi.ts";
import { mapIfSome } from "~/utils/option.ffi.ts";

function wrapBinary(value: unknown): unknown {
  if (value instanceof ArrayBuffer) {
    return BitArray$BitArray(new Uint8Array(value));
  }
  return value;
}

function isValidWebSocketUrl(url: string): boolean {
  let parsed: URL;
  try {
    parsed = new URL(url);
  } catch {
    return false;
  }
  if (parsed.protocol !== "ws:" && parsed.protocol !== "wss:") return false;
  if (parsed.hash !== "") return false;
  return true;
}

function toCloseEvent(event: CloseEvent): $webSocket.CloseEvent$ {
  return $webSocket.CloseEvent$CloseEvent(
    event.code,
    event.reason,
    event.wasClean,
  );
}

function toBinaryType(value: BinaryType | string): $webSocket.BinaryType$ {
  if (value === "arraybuffer") return $webSocket.BinaryType$ArrayBuffer();
  return $webSocket.BinaryType$Blob();
}

function fromBinaryType(value: $webSocket.BinaryType$): BinaryType {
  if ($webSocket.BinaryType$isArrayBuffer(value)) return "arraybuffer";
  return "blob";
}

function toReadyState(value: number): $webSocket.ReadyState$ {
  switch (value) {
    case 0:
      return $webSocket.ReadyState$Connecting();
    case 1:
      return $webSocket.ReadyState$Open();
    case 2:
      return $webSocket.ReadyState$Closing();
    case 3:
      return $webSocket.ReadyState$Closed();
    default:
      return $webSocket.ReadyState$Closed();
  }
}

export const build: typeof $webSocket.do_build = (
  url,
  protocolsList,
  binary_type,
  on_open,
  on_message,
  on_error,
  on_close,
) => {
  if (!isValidWebSocketUrl(url)) {
    return Result$Error($webSocket.WebSocketError$InvalidUrl());
  }
  const protocols = toArray(protocolsList);
  let ws: WebSocket;
  try {
    ws = new WebSocket(url, protocols);
  } catch {
    return Result$Error($webSocket.WebSocketError$InvalidProtocols());
  }

  mapIfSome(ws, "binaryType", binary_type, fromBinaryType);
  mapIfSome(ws, "onopen", on_open, (handler) => () => handler());
  mapIfSome(
    ws,
    "onmessage",
    on_message,
    (handler) => (event) => handler(wrapBinary(event.data)),
  );
  mapIfSome(ws, "onerror", on_error, (handler) => () => handler());
  mapIfSome(
    ws,
    "onclose",
    on_close,
    (handler) => (event) => handler(toCloseEvent(event)),
  );

  return Result$Ok(ws);
};

export const binary_type: typeof $webSocket.binary_type = (socket) => {
  return toBinaryType(socket.binaryType);
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

const utf8 = new TextEncoder();

export const close_with: typeof $webSocket.close_with = (
  socket,
  code,
  reason,
) => {
  if (code !== 1000 && (code < 3000 || code > 4999)) {
    return Result$Error($webSocket.WebSocketError$InvalidCloseCode(code));
  }
  if (utf8.encode(reason).length > 123) {
    return Result$Error($webSocket.WebSocketError$CloseReasonTooLong());
  }
  socket.close(code, reason);
  return Result$Ok(undefined);
};

function checkOpen() {
  return Result$Error($webSocket.WebSocketError$NotOpen());
}

export const send_blob: typeof $webSocket.send_blob = (socket, data) => {
  if (socket.readyState === WebSocket.CONNECTING) return checkOpen();
  socket.send(data);
  return Result$Ok(undefined);
};

export const send_bytes: typeof $webSocket.send_bytes = (socket, data) => {
  if (socket.readyState === WebSocket.CONNECTING) return checkOpen();
  socket.send(toBufferSource(data));
  return Result$Ok(undefined);
};

export const send_string: typeof $webSocket.send_string = (socket, data) => {
  if (socket.readyState === WebSocket.CONNECTING) return checkOpen();
  socket.send(data);
  return Result$Ok(undefined);
};
