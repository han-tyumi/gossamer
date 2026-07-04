import * as $broadcastChannel from "$/gossamer/gossamer/broadcast_channel.mjs";
import { Result$Error, Result$Ok } from "$/prelude.mjs";
import {
  unwrapBitArrayForClone,
  wrapArrayBuffer,
} from "~/utils/bit_array.ffi.ts";

function classifyError(
  error: unknown,
): $broadcastChannel.PostMessageError$ {
  if (error instanceof DOMException && error.name === "InvalidStateError") {
    return $broadcastChannel.PostMessageError$InvalidState();
  }
  return $broadcastChannel.PostMessageError$DataClone();
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
  } catch (e) {
    return Result$Error(classifyError(e));
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
