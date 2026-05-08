import { BitArray$BitArray } from "$/prelude.mjs";
import type * as $crypto from "$/gossamer/gossamer/crypto.mjs";

const RANDOM_VALUES_QUOTA = 65_536;

export const random_bytes: typeof $crypto.random_bytes = (length) => {
  if (length <= 0) return BitArray$BitArray(new Uint8Array(0));
  const bytes = new Uint8Array(length);
  for (let offset = 0; offset < length; offset += RANDOM_VALUES_QUOTA) {
    globalThis.crypto.getRandomValues(
      bytes.subarray(offset, Math.min(offset + RANDOM_VALUES_QUOTA, length)),
    );
  }
  return BitArray$BitArray(bytes);
};

export const random_uuid: typeof $crypto.random_uuid = () => {
  return globalThis.crypto.randomUUID();
};
