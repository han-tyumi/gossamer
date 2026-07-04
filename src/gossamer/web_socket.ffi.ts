import * as $webSocket from "$/gossamer/gossamer/web_socket.mjs";
import { BitArray$BitArray, Result$Error, Result$Ok } from "$/prelude.mjs";
import { toBufferSource } from "~/utils/bit_array.ffi.ts";
import { toArray } from "~/utils/list.ffi.ts";
import { mapIfSome } from "~/utils/option.ffi.ts";

function isValidWebSocketUrl(url: string): boolean {
  let parsed: URL;
  try {
    parsed = new URL(url);
  } catch {
    return false;
  }
  // http: and https: are spec-valid; the constructor normalizes them
  // to ws: and wss:.
  const allowedSchemes = ["ws:", "wss:", "http:", "https:"];
  if (!allowedSchemes.includes(parsed.protocol)) return false;
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

function toMessageEvent(data: unknown): $webSocket.WebSocketEvent$ {
  if (typeof data === "string") {
    return $webSocket.WebSocketEvent$Text(data);
  }
  if (data instanceof ArrayBuffer) {
    return $webSocket.WebSocketEvent$Binary(
      BitArray$BitArray(new Uint8Array(data)),
    );
  }
  throw new Error(
    "gossamer.web_socket: the runtime delivered a binary message that is " +
      'not an ArrayBuffer despite binaryType being pinned to "arraybuffer". ' +
      "Please file an issue at https://github.com/han-tyumi/gossamer/issues.",
  );
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
  on_event,
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

  ws.binaryType = "arraybuffer";
  mapIfSome(ws, "onopen", on_event, (handler) => () => {
    handler($webSocket.WebSocketEvent$Opened(), ws);
  });
  mapIfSome(ws, "onmessage", on_event, (handler) => (event) => {
    handler(toMessageEvent(event.data), ws);
  });
  mapIfSome(ws, "onerror", on_event, (handler) => () => {
    handler($webSocket.WebSocketEvent$Errored(), ws);
  });
  mapIfSome(ws, "onclose", on_event, (handler) => (event) => {
    handler($webSocket.WebSocketEvent$Disconnected(toCloseEvent(event)), ws);
  });

  return Result$Ok(ws);
};

export const info: typeof $webSocket.info = (socket) => {
  return $webSocket.Info$Info(
    socket.url,
    socket.protocol,
    socket.extensions,
  );
};

export const ready_state: typeof $webSocket.ready_state = (socket) => {
  return toReadyState(socket.readyState);
};

export const buffered_amount: typeof $webSocket.buffered_amount = (socket) => {
  return socket.bufferedAmount;
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

export const send_binary: typeof $webSocket.send_binary = (socket, data) => {
  if (socket.readyState === WebSocket.CONNECTING) return checkOpen();
  socket.send(toBufferSource(data));
  return Result$Ok(undefined);
};

export const send_text: typeof $webSocket.send_text = (socket, data) => {
  if (socket.readyState === WebSocket.CONNECTING) return checkOpen();
  socket.send(data);
  return Result$Ok(undefined);
};
