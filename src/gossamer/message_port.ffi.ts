import type * as $messagePort from "$/gossamer/gossamer/message_port.mjs";
import { Result$Error, Result$Ok } from "$/prelude.mjs";
import { wrapArrayBuffer } from "~/utils/bit_array.ffi.ts";

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

export const set_on_message: typeof $messagePort.set_on_message = (
  port,
  handler,
) => {
  port.onmessage = (event) => handler(wrapArrayBuffer(event.data));
};

export const set_on_message_error: typeof $messagePort.set_on_message_error = (
  port,
  handler,
) => {
  port.onmessageerror = () => handler();
};
