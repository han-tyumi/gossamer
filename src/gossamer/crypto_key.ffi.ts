import type * as $cryptoKey from "$/gossamer/gossamer/crypto_key.mjs";
import { toKeyType } from "~/gossamer/key_type.ts";
import { fromKeyUsage } from "~/gossamer/key_usage.ts";
import { fromArrayMapped } from "~/utils/list.ts";

export type CryptoKey$ = CryptoKey;

export const algorithm: typeof $cryptoKey.algorithm = (key) => {
  return key.algorithm;
};

export const extractable: typeof $cryptoKey.extractable = (key) => {
  return key.extractable;
};

export const type_: typeof $cryptoKey.type_ = (key) => {
  return toKeyType(key.type);
};

export const usages: typeof $cryptoKey.usages = (key) => {
  return fromArrayMapped(key.usages, fromKeyUsage);
};
