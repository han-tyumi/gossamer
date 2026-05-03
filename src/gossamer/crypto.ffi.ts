import type * as $crypto from "$/gossamer/gossamer/crypto.mjs";
import {
  unwrap as unwrapIntTypedArray,
  wrap as wrapIntTypedArray,
} from "~/gossamer/int_typed_array.ffi.ts";
import { toResult } from "~/utils/result.ffi.ts";

export const get_random_values: typeof $crypto.get_random_values = (array) => {
  return toResult.fromThrows(() =>
    wrapIntTypedArray(
      globalThis.crypto.getRandomValues(unwrapIntTypedArray(array)),
    )
  );
};

export const random_uuid: typeof $crypto.random_uuid = () => {
  return globalThis.crypto.randomUUID();
};
