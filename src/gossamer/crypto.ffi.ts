import type * as $crypto from "$/gossamer/gossamer/crypto.mjs";

export const get_random_values: typeof $crypto.get_random_values = (array) => {
  return globalThis.crypto.getRandomValues(array);
};

export const random_uuid: typeof $crypto.random_uuid = () => {
  return globalThis.crypto.randomUUID();
};
