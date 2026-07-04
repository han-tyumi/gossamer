import type * as $crypto from "$/gossamer/gossamer/crypto.mjs";

export const random_uuid: typeof $crypto.random_uuid = () => {
  return globalThis.crypto.randomUUID();
};
