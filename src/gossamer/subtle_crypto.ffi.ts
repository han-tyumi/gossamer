import * as $subtleCrypto from "$/gossamer/gossamer/subtle_crypto.mjs";
import { fromJsonWebKey, toJsonWebKey } from "~/gossamer/json_web_key.ffi.ts";
import { toKeyFormat } from "~/gossamer/key_format.ffi.ts";
import { toKeyUsageArray } from "~/gossamer/key_usage.ffi.ts";
import { toHashAlgorithm } from "~/gossamer/hash_algorithm.ffi.ts";
import { toDeriveAlgorithm } from "~/gossamer/subtle_crypto/derive_algorithm.ffi.ts";
import { toDerivedKeyType } from "~/gossamer/subtle_crypto/derived_key_type.ffi.ts";
import { toEncryptAlgorithm } from "~/gossamer/subtle_crypto/encrypt_algorithm.ffi.ts";
import { toImportAlgorithm } from "~/gossamer/subtle_crypto/import_algorithm.ffi.ts";
import { toWrapAlgorithm } from "~/gossamer/subtle_crypto/wrap_algorithm.ffi.ts";
import { toKeyGenAlgorithm } from "~/gossamer/subtle_crypto/key_gen_algorithm.ffi.ts";
import { toKeyPairGenAlgorithm } from "~/gossamer/subtle_crypto/key_pair_gen_algorithm.ffi.ts";
import { toSignAlgorithm } from "~/gossamer/subtle_crypto/sign_algorithm.ffi.ts";
import { toResult } from "~/utils/result.ffi.ts";

const subtle = globalThis.crypto.subtle;

function toCryptoKeyPair(
  pair: CryptoKeyPair,
): $subtleCrypto.CryptoKeyPair$ {
  return $subtleCrypto.CryptoKeyPair$CryptoKeyPair(
    pair.publicKey,
    pair.privateKey,
  );
}

export const digest: typeof $subtleCrypto.digest = (algorithm, data) => {
  return toResult.fromPromiseAsError(
    subtle.digest(
      toHashAlgorithm(algorithm),
      data as unknown as BufferSource,
    ),
  );
};

export const encrypt: typeof $subtleCrypto.encrypt = (
  algorithm,
  key,
  data,
) => {
  return toResult.fromPromiseAsError(
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
  return toResult.fromPromiseAsError(
    subtle.decrypt(
      toEncryptAlgorithm(algorithm),
      key,
      data as unknown as BufferSource,
    ),
  );
};

export const sign: typeof $subtleCrypto.sign = (algorithm, key, data) => {
  return toResult.fromPromiseAsError(
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
  return toResult.fromPromiseAsError(
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
  return toResult.fromPromiseAsError(
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
  return toResult.fromPromiseAsError(
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
  return toResult.fromPromiseAsError(
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
  return toResult.fromPromiseAsError(
    subtle.importKey(
      "jwk",
      toJsonWebKey(keyData),
      toImportAlgorithm(algorithm),
      extractable,
      toKeyUsageArray(usages),
    ),
  );
};

export const export_key: typeof $subtleCrypto.export_key = (format, key) => {
  return toResult.fromPromiseAsError(
    subtle.exportKey(toKeyFormat(format), key),
  );
};

export const export_key_jwk: typeof $subtleCrypto.export_key_jwk = (key) => {
  return toResult.fromPromiseAsError(
    (subtle.exportKey("jwk", key) as Promise<JsonWebKey>).then(fromJsonWebKey),
  );
};

export const derive_bits: typeof $subtleCrypto.derive_bits = (
  algorithm,
  baseKey,
  length,
) => {
  return toResult.fromPromiseAsError(
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
  return toResult.fromPromiseAsError(
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
  return toResult.fromPromiseAsError(
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
  return toResult.fromPromiseAsError(
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
  return toResult.fromPromiseAsError(
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
  return toResult.fromPromiseAsError(
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
