import type * as $broadcastChannel from "$/gossamer/gossamer/broadcast_channel.mjs";
import { Result$Error, Result$Ok } from "$/prelude.mjs";
import {
  unwrapBitArrayForClone,
  wrapArrayBuffer,
} from "~/utils/bit_array.ffi.ts";

// Deno's BroadcastChannel posts onto an internal timer that can fire a
// TypeError("expected i32") as an unhandled rejection after the
// channel closes. Silence the narrow case so test runs and short-lived
// scripts exit cleanly; legitimate errors still propagate.
if (typeof globalThis.Deno !== "undefined") {
  globalThis.addEventListener("unhandledrejection", (event) => {
    const reason = event.reason;
    if (
      reason instanceof TypeError &&
      typeof reason.message === "string" &&
      reason.message.includes("expected i32") &&
      typeof reason.stack === "string" &&
      reason.stack.includes("broadcast_channel")
    ) {
      event.preventDefault();
    }
  });
}

export const new_: typeof $broadcastChannel.new$ = (name) => {
  return new BroadcastChannel(name);
};

export const name: typeof $broadcastChannel.name = (channel) => {
  return channel.name;
};

export const post_message: typeof $broadcastChannel.post_message = (
  channel,
  data,
) => {
  try {
    channel.postMessage(unwrapBitArrayForClone(data));
    return Result$Ok(undefined);
  } catch {
    return Result$Error(undefined);
  }
};

export const close: typeof $broadcastChannel.close = (channel) => {
  channel.close();
};

export const set_on_message: typeof $broadcastChannel.set_on_message = (
  channel,
  handler,
) => {
  channel.onmessage = (event) => handler(wrapArrayBuffer(event.data), channel);
};
