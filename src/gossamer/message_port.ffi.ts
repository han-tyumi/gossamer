import type * as $messagePort from "$/gossamer/gossamer/message_port.mjs";
import { toMessageEvent } from "~/gossamer/message_event.ffi.ts";
import { toResult } from "~/utils/result.ffi.ts";

export type MessagePort$ = MessagePort;

export const post_message: typeof $messagePort.post_message = (port, data) => {
  return toResult.fromThrows(() => {
    port.postMessage(data);
    return undefined;
  });
};

export const start: typeof $messagePort.start = (port) => {
  port.start();
};

export const close: typeof $messagePort.close = (port) => {
  port.close();
};

export const on_message: typeof $messagePort.on_message = (port, handler) => {
  port.onmessage = (event) => handler(toMessageEvent(event));
};

export const on_message_error: typeof $messagePort.on_message_error = (
  port,
  handler,
) => {
  port.onmessageerror = (event) => handler(toMessageEvent(event));
};
