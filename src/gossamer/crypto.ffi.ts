import type * as $crypto from "$/gossamer/gossamer/crypto.mjs";
import { toResult } from "~/utils/result.ts";

export const get_random_values: typeof $crypto.get_random_values = (array) => {
  return toResult.fromThrows(() => globalThis.crypto.getRandomValues(array));
};

export const random_uuid: typeof $crypto.random_uuid = () => {
  return globalThis.crypto.randomUUID();
};
