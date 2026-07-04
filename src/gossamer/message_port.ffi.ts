import type * as $messagePort from "$/gossamer/gossamer/message_port.mjs";
import { Result$Error, Result$Ok } from "$/prelude.mjs";
import {
  unwrapBitArrayForClone,
  wrapArrayBuffer,
} from "~/utils/bit_array.ffi.ts";
import { collectPorts, isMessagePort } from "~/utils/transferables.ffi.ts";

export const post_message: typeof $messagePort.post_message = (port, data) => {
  try {
    const payload = unwrapBitArrayForClone(data);
    const ports = collectPorts(payload);
    if (ports.length === 0) {
      port.postMessage(payload);
    } else {
      port.postMessage(payload, ports);
    }
    return Result$Ok(undefined);
  } catch {
    return Result$Error(undefined);
  }
};

export const close: typeof $messagePort.close = (port) => {
  port.close();
};

export const set_on_message: typeof $messagePort.set_on_message = (
  port,
  handler,
) => {
  port.onmessage = (event) => handler(wrapArrayBuffer(event.data), port);
};

export const from_dynamic: typeof $messagePort.from_dynamic = (value) => {
  if (isMessagePort(value)) {
    return Result$Ok(value);
  }
  return Result$Error(undefined);
};
