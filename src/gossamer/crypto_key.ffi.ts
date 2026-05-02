import * as $cryptoKey from "$/gossamer/gossamer/crypto_key.mjs";
import { fromAesAlgorithm } from "~/gossamer/aes_algorithm.ffi.ts";
import { fromEcAlgorithm } from "~/gossamer/ec_algorithm.ffi.ts";
import { fromHashAlgorithm } from "~/gossamer/hash_algorithm.ffi.ts";
import { toKeyType } from "~/gossamer/key_type.ffi.ts";
import { fromKeyUsage } from "~/gossamer/key_usage.ffi.ts";
import { fromNamedCurve } from "~/gossamer/named_curve.ffi.ts";
import { fromRsaAlgorithm } from "~/gossamer/rsa_algorithm.ffi.ts";
import { fromArrayMapped } from "~/utils/list.ffi.ts";

interface AesKeyAlgorithmShape extends KeyAlgorithm {
  length: number;
}

interface EcKeyAlgorithmShape extends KeyAlgorithm {
  namedCurve: string;
}

interface HmacKeyAlgorithmShape extends KeyAlgorithm {
  hash: AlgorithmIdentifier;
  length: number;
}

interface RsaKeyAlgorithmShape extends KeyAlgorithm {
  modulusLength: number;
  publicExponent: Uint8Array;
  hash: AlgorithmIdentifier;
}

function hashName(hash: AlgorithmIdentifier): string {
  return typeof hash === "string" ? hash : hash.name;
}

export function toKeyAlgorithm(
  algorithm: KeyAlgorithm,
): $cryptoKey.KeyAlgorithm$ {
  const name = algorithm.name;

  if ("namedCurve" in algorithm) {
    return $cryptoKey.KeyAlgorithm$Ec(
      fromEcAlgorithm(name),
      fromNamedCurve((algorithm as EcKeyAlgorithmShape).namedCurve),
    );
  }

  if ("modulusLength" in algorithm) {
    const rsa = algorithm as RsaKeyAlgorithmShape;
    return $cryptoKey.KeyAlgorithm$Rsa(
      fromRsaAlgorithm(name),
      rsa.modulusLength,
      new Uint8Array(rsa.publicExponent),
      fromHashAlgorithm(hashName(rsa.hash)),
    );
  }

  if ("hash" in algorithm) {
    const hmac = algorithm as HmacKeyAlgorithmShape;
    return $cryptoKey.KeyAlgorithm$Hmac(
      fromHashAlgorithm(hashName(hmac.hash)),
      hmac.length,
    );
  }

  return $cryptoKey.KeyAlgorithm$Aes(
    fromAesAlgorithm(name),
    (algorithm as AesKeyAlgorithmShape).length,
  );
}

export const to_fields: typeof $cryptoKey.to_fields = (key) => {
  return $cryptoKey.Fields$Fields(
    toKeyAlgorithm(key.algorithm),
    key.extractable,
    toKeyType(key.type),
    fromArrayMapped(key.usages, fromKeyUsage),
  );
};

export const algorithm: typeof $cryptoKey.algorithm = (key) => {
  return toKeyAlgorithm(key.algorithm);
};

export const is_extractable: typeof $cryptoKey.is_extractable = (key) => {
  return key.extractable;
};

export const type_: typeof $cryptoKey.type_ = (key) => {
  return toKeyType(key.type);
};

export const usages: typeof $cryptoKey.usages = (key) => {
  return fromArrayMapped(key.usages, fromKeyUsage);
};
