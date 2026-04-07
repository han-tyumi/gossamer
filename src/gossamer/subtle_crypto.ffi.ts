import type * as $subtleCrypto from "$/gossamer/gossamer/subtle_crypto.mjs";
import { toCryptoKeyPair } from "~/gossamer/crypto_key_pair.ts";
import { toKeyFormat } from "~/gossamer/key_format.ts";
import { toKeyUsageArray } from "~/gossamer/key_usage.ts";
import { toDeriveAlgorithm } from "~/gossamer/subtle_crypto/derive_algorithm.ts";
import { toDerivedKeyType } from "~/gossamer/subtle_crypto/derived_key_type.ts";
import { toEncryptAlgorithm } from "~/gossamer/subtle_crypto/encrypt_algorithm.ts";
import { toImportAlgorithm } from "~/gossamer/subtle_crypto/import_algorithm.ts";
import { toWrapAlgorithm } from "~/gossamer/subtle_crypto/wrap_algorithm.ts";
import { toKeyGenAlgorithm } from "~/gossamer/subtle_crypto/key_gen_algorithm.ts";
import { toKeyPairGenAlgorithm } from "~/gossamer/subtle_crypto/key_pair_gen_algorithm.ts";
import { toSignAlgorithm } from "~/gossamer/subtle_crypto/sign_algorithm.ts";
import { toResult } from "~/utils/result.ts";

const subtle = globalThis.crypto.subtle;

export const digest: typeof $subtleCrypto.digest = (algorithm, data) => {
  return toResult.fromPromise(
    subtle.digest(algorithm, data as unknown as BufferSource),
  );
};

export const encrypt: typeof $subtleCrypto.encrypt = (
  algorithm,
  key,
  data,
) => {
  return toResult.fromPromise(
    subtle.encrypt(
      toEncryptAlgorithm(algorithm),
      key,
      data as unknown as BufferSource,
    ),
  );
};

export const decrypt: typeof $subtleCrypto.decrypt = (
  algorithm,
  key,
  data,
) => {
  return toResult.fromPromise(
    subtle.decrypt(
      toEncryptAlgorithm(algorithm),
      key,
      data as unknown as BufferSource,
    ),
  );
};

export const sign: typeof $subtleCrypto.sign = (algorithm, key, data) => {
  return toResult.fromPromise(
    subtle.sign(
      toSignAlgorithm(algorithm),
      key,
      data as unknown as BufferSource,
    ),
  );
};

export const verify: typeof $subtleCrypto.verify = (
  algorithm,
  key,
  signature,
  data,
) => {
  return toResult.fromPromise(
    subtle.verify(
      toSignAlgorithm(algorithm),
      key,
      signature as unknown as BufferSource,
      data as unknown as BufferSource,
    ),
  );
};

export const generate_key: typeof $subtleCrypto.generate_key = (
  algorithm,
  extractable,
  usages,
) => {
  return toResult.fromPromise(
    subtle.generateKey(
      toKeyGenAlgorithm(algorithm),
      extractable,
      toKeyUsageArray(usages),
    ) as Promise<CryptoKey>,
  );
};

export const generate_key_pair: typeof $subtleCrypto.generate_key_pair = (
  algorithm,
  extractable,
  usages,
) => {
  return toResult.fromPromise(
    (
      subtle.generateKey(
        toKeyPairGenAlgorithm(algorithm),
        extractable,
        toKeyUsageArray(usages),
      ) as Promise<CryptoKeyPair>
    ).then(toCryptoKeyPair),
  );
};

export const import_key: typeof $subtleCrypto.import_key = (
  format,
  keyData,
  algorithm,
  extractable,
  usages,
) => {
  return toResult.fromPromise(
    subtle.importKey(
      toKeyFormat(format),
      keyData as unknown as BufferSource,
      toImportAlgorithm(algorithm),
      extractable,
      toKeyUsageArray(usages),
    ),
  );
};

export const import_key_jwk: typeof $subtleCrypto.import_key_jwk = (
  keyData,
  algorithm,
  extractable,
  usages,
) => {
  return toResult.fromPromise(
    subtle.importKey(
      "jwk",
      keyData as JsonWebKey,
      toImportAlgorithm(algorithm),
      extractable,
      toKeyUsageArray(usages),
    ),
  );
};

export const export_key: typeof $subtleCrypto.export_key = (format, key) => {
  return toResult.fromPromise(
    subtle.exportKey(toKeyFormat(format), key),
  );
};

export const export_key_jwk: typeof $subtleCrypto.export_key_jwk = (key) => {
  return toResult.fromPromise(
    subtle.exportKey("jwk", key) as Promise<unknown>,
  );
};

export const derive_bits: typeof $subtleCrypto.derive_bits = (
  algorithm,
  baseKey,
  length,
) => {
  return toResult.fromPromise(
    subtle.deriveBits(toDeriveAlgorithm(algorithm), baseKey, length),
  );
};

export const derive_key: typeof $subtleCrypto.derive_key = (
  algorithm,
  baseKey,
  derivedKeyType,
  extractable,
  usages,
) => {
  return toResult.fromPromise(
    subtle.deriveKey(
      toDeriveAlgorithm(algorithm),
      baseKey,
      toDerivedKeyType(derivedKeyType),
      extractable,
      toKeyUsageArray(usages),
    ),
  );
};

export const wrap_key: typeof $subtleCrypto.wrap_key = (
  format,
  key,
  wrappingKey,
  algorithm,
) => {
  return toResult.fromPromise(
    subtle.wrapKey(
      toKeyFormat(format),
      key,
      wrappingKey,
      toWrapAlgorithm(algorithm),
    ),
  );
};

export const wrap_key_jwk: typeof $subtleCrypto.wrap_key_jwk = (
  key,
  wrappingKey,
  algorithm,
) => {
  return toResult.fromPromise(
    subtle.wrapKey("jwk", key, wrappingKey, toWrapAlgorithm(algorithm)),
  );
};

export const unwrap_key: typeof $subtleCrypto.unwrap_key = (
  format,
  wrappedKey,
  unwrappingKey,
  unwrapAlgorithm,
  unwrappedKeyAlgorithm,
  extractable,
  usages,
) => {
  return toResult.fromPromise(
    subtle.unwrapKey(
      toKeyFormat(format),
      wrappedKey as unknown as BufferSource,
      unwrappingKey,
      toWrapAlgorithm(unwrapAlgorithm),
      toImportAlgorithm(unwrappedKeyAlgorithm),
      extractable,
      toKeyUsageArray(usages),
    ),
  );
};

export const unwrap_key_jwk: typeof $subtleCrypto.unwrap_key_jwk = (
  wrappedKey,
  unwrappingKey,
  unwrapAlgorithm,
  unwrappedKeyAlgorithm,
  extractable,
  usages,
) => {
  return toResult.fromPromise(
    subtle.unwrapKey(
      "jwk",
      wrappedKey as unknown as BufferSource,
      unwrappingKey,
      toWrapAlgorithm(unwrapAlgorithm),
      toImportAlgorithm(unwrappedKeyAlgorithm),
      extractable,
      toKeyUsageArray(usages),
    ),
  );
};
