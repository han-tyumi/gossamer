import { BitArray$BitArray } from "$/prelude.mjs";
import type * as $messageEvent from "$/gossamer/gossamer/message_event.mjs";

function wrapBinary(value: unknown): unknown {
  if (value instanceof ArrayBuffer) {
    return BitArray$BitArray(new Uint8Array(value));
  }
  return value;
}

export const data: typeof $messageEvent.data = (event) => {
  return wrapBinary(event.data);
};

export const origin: typeof $messageEvent.origin = (event) => {
  return event.origin;
};

export const last_event_id: typeof $messageEvent.last_event_id = (event) => {
  return event.lastEventId;
};
