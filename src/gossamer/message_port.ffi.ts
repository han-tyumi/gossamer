import type * as $messagePort from "$/gossamer/gossamer/message_port.mjs";

export type MessagePort$ = MessagePort;

export const post_message: typeof $messagePort.post_message = (
  port,
  message,
) => {
  port.postMessage(message);
};

export const start: typeof $messagePort.start = (port) => {
  port.start();
};

export const close: typeof $messagePort.close = (port) => {
  port.close();
};

export const on_message: typeof $messagePort.on_message = (port, handler) => {
  port.onmessage = (event) => handler(event);
};

export const on_message_error: typeof $messagePort.on_message_error = (
  port,
  handler,
) => {
  port.onmessageerror = (event) => handler(event);
};
