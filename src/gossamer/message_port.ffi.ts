import type * as $messagePort from "$/gossamer/gossamer/message_port.mjs";
import { Result$Error, Result$Ok } from "$/prelude.mjs";
import { wrapBinary } from "~/gossamer/message_event.ffi.ts";

export const post_message: typeof $messagePort.post_message = (port, data) => {
  try {
    port.postMessage(data);
    return Result$Ok(undefined);
  } catch {
    return Result$Error(undefined);
  }
};

export const start: typeof $messagePort.start = (port) => {
  port.start();
};

export const close: typeof $messagePort.close = (port) => {
  port.close();
};

export const on_message: typeof $messagePort.on_message = (port, handler) => {
  port.onmessage = (event) => handler(wrapBinary(event.data));
};

export const on_message_error: typeof $messagePort.on_message_error = (
  port,
  handler,
) => {
  port.onmessageerror = () => handler();
};
