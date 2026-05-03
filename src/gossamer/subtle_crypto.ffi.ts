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
import { unwrap as unwrapTypedArray } from "~/gossamer/typed_array.ffi.ts";
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
  return toResult.fromPromise(
    subtle.digest(
      toHashAlgorithm(algorithm),
      unwrapTypedArray(data) as BufferSource,
    ),
  );
};

export const digest_data_view: typeof $subtleCrypto.digest_data_view = (
  algorithm,
  data,
) => {
  return toResult.fromPromise(
    subtle.digest(toHashAlgorithm(algorithm), data as BufferSource),
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
      unwrapTypedArray(data) as BufferSource,
    ),
  );
};

export const encrypt_data_view: typeof $subtleCrypto.encrypt_data_view = (
  algorithm,
  key,
  data,
) => {
  return toResult.fromPromise(
    subtle.encrypt(toEncryptAlgorithm(algorithm), key, data as BufferSource),
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
      unwrapTypedArray(data) as BufferSource,
    ),
  );
};

export const decrypt_data_view: typeof $subtleCrypto.decrypt_data_view = (
  algorithm,
  key,
  data,
) => {
  return toResult.fromPromise(
    subtle.decrypt(toEncryptAlgorithm(algorithm), key, data as BufferSource),
  );
};

export const sign: typeof $subtleCrypto.sign = (algorithm, key, data) => {
  return toResult.fromPromise(
    subtle.sign(
      toSignAlgorithm(algorithm),
      key,
      unwrapTypedArray(data) as BufferSource,
    ),
  );
};

export const sign_data_view: typeof $subtleCrypto.sign_data_view = (
  algorithm,
  key,
  data,
) => {
  return toResult.fromPromise(
    subtle.sign(toSignAlgorithm(algorithm), key, data as BufferSource),
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
      unwrapTypedArray(signature) as BufferSource,
      unwrapTypedArray(data) as BufferSource,
    ),
  );
};

export const verify_data_view: typeof $subtleCrypto.verify_data_view = (
  algorithm,
  key,
  signature,
  data,
) => {
  return toResult.fromPromise(
    subtle.verify(
      toSignAlgorithm(algorithm),
      key,
      signature as BufferSource,
      data as BufferSource,
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
      unwrapTypedArray(keyData) as BufferSource,
      toImportAlgorithm(algorithm),
      extractable,
      toKeyUsageArray(usages),
    ),
  );
};

export const import_key_data_view: typeof $subtleCrypto.import_key_data_view = (
  format,
  keyData,
  algorithm,
  extractable,
  usages,
) => {
  return toResult.fromPromise(
    subtle.importKey(
      toKeyFormat(format),
      keyData as BufferSource,
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
      toJsonWebKey(keyData),
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
    (subtle.exportKey("jwk", key) as Promise<JsonWebKey>).then(fromJsonWebKey),
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
      unwrapTypedArray(wrappedKey) as BufferSource,
      unwrappingKey,
      toWrapAlgorithm(unwrapAlgorithm),
      toImportAlgorithm(unwrappedKeyAlgorithm),
      extractable,
      toKeyUsageArray(usages),
    ),
  );
};

export const unwrap_key_data_view: typeof $subtleCrypto.unwrap_key_data_view = (
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
      wrappedKey as BufferSource,
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
      unwrapTypedArray(wrappedKey) as BufferSource,
      unwrappingKey,
      toWrapAlgorithm(unwrapAlgorithm),
      toImportAlgorithm(unwrappedKeyAlgorithm),
      extractable,
      toKeyUsageArray(usages),
    ),
  );
};

export const unwrap_key_jwk_data_view:
  typeof $subtleCrypto.unwrap_key_jwk_data_view = (
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
        wrappedKey as BufferSource,
        unwrappingKey,
        toWrapAlgorithm(unwrapAlgorithm),
        toImportAlgorithm(unwrappedKeyAlgorithm),
        extractable,
        toKeyUsageArray(usages),
      ),
    );
  };
