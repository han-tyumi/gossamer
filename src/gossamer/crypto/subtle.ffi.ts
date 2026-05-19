import * as $crypto from "$/gossamer/gossamer/crypto.mjs";
import * as $subtle from "$/gossamer/gossamer/crypto/subtle.mjs";
import { BitArray$BitArray, Result$Error, Result$Ok } from "$/prelude.mjs";
import {
  toAesAlgorithm,
  toEcAlgorithm,
  toHashAlgorithm,
  toKeyUsageArray,
  toNamedCurve,
  toRsaAlgorithm,
} from "~/gossamer/crypto/key.ffi.ts";
import { fromJsonWebKey, toJsonWebKey } from "~/gossamer/crypto/jwk.ffi.ts";
import { toUint8Array } from "~/utils/bit_array.ffi.ts";
import { setIfSome } from "~/utils/option.ffi.ts";

const subtle = globalThis.crypto.subtle;

function toCryptoError(value: unknown): $crypto.CryptoError$ {
  if (value instanceof Error) {
    switch (value.name) {
      case "NotSupportedError":
        return $crypto.CryptoError$AlgorithmNotSupported();
      case "InvalidAccessError":
        return $crypto.CryptoError$InvalidAccess();
      case "OperationError":
        return $crypto.CryptoError$OperationFailed();
      case "DataError":
        return $crypto.CryptoError$DataMalformed();
      case "QuotaExceededError":
        return $crypto.CryptoError$QuotaExceeded();
      case "SyntaxError":
        return $crypto.CryptoError$InvalidSyntax();
    }
  }
  throw new Error(
    `gossamer/crypto/subtle: unmapped error from JavaScript SubtleCrypto: ${
      value instanceof Error ? `${value.name}: ${value.message}` : String(value)
    }. Please file an issue at https://github.com/han-tyumi/gossamer/issues.`,
    { cause: value },
  );
}

async function toCryptoResult<T>(thunk: () => Promise<T>) {
  try {
    return Result$Ok(await thunk());
  } catch (error) {
    return Result$Error(toCryptoError(error));
  }
}

async function toCryptoBitArrayResult(thunk: () => Promise<ArrayBuffer>) {
  try {
    return Result$Ok(BitArray$BitArray(new Uint8Array(await thunk())));
  } catch (error) {
    return Result$Error(toCryptoError(error));
  }
}

const keyUsageVariants: Record<KeyUsage, () => $crypto.KeyUsage$> = {
  encrypt: $crypto.KeyUsage$Encrypt,
  decrypt: $crypto.KeyUsage$Decrypt,
  sign: $crypto.KeyUsage$Sign,
  verify: $crypto.KeyUsage$Verify,
  deriveKey: $crypto.KeyUsage$DeriveKey,
  deriveBits: $crypto.KeyUsage$DeriveBits,
  wrapKey: $crypto.KeyUsage$WrapKey,
  unwrapKey: $crypto.KeyUsage$UnwrapKey,
};

function usageMismatch(required: KeyUsage): $crypto.CryptoError$ {
  return $crypto.CryptoError$KeyUsageMismatch(
    keyUsageVariants[required](),
  );
}

function checkUsage(
  key: CryptoKey,
  required: KeyUsage,
): $crypto.CryptoError$ | null {
  return key.usages.includes(required) ? null : usageMismatch(required);
}

function checkExtractable(key: CryptoKey): $crypto.CryptoError$ | null {
  return key.extractable ? null : $crypto.CryptoError$KeyNotExtractable();
}

function toCryptoKeyPair(
  pair: CryptoKeyPair,
): $subtle.CryptoKeyPair$ {
  return $subtle.CryptoKeyPair$CryptoKeyPair(
    pair.publicKey,
    pair.privateKey,
  );
}

function toKeyFormat(
  value: $subtle.KeyFormat$,
): Exclude<KeyFormat, "jwk"> {
  if ($subtle.KeyFormat$isPkcs8(value)) return "pkcs8";
  if ($subtle.KeyFormat$isRaw(value)) return "raw";
  return "spki";
}

function toDeriveAlgorithm(
  algorithm: $subtle.DeriveAlgorithm$,
): AlgorithmIdentifier | HkdfParams | Pbkdf2Params | EcdhKeyDeriveParams {
  if ($subtle.DeriveAlgorithm$isDeriveHkdf(algorithm)) {
    return {
      name: "HKDF",
      hash: toHashAlgorithm(
        $subtle.DeriveAlgorithm$DeriveHkdf$hash(algorithm),
      ),
      info: toUint8Array(
        $subtle.DeriveAlgorithm$DeriveHkdf$info(algorithm),
      ),
      salt: toUint8Array(
        $subtle.DeriveAlgorithm$DeriveHkdf$salt(algorithm),
      ),
    };
  }
  if ($subtle.DeriveAlgorithm$isDerivePbkdf2(algorithm)) {
    return {
      name: "PBKDF2",
      hash: toHashAlgorithm(
        $subtle.DeriveAlgorithm$DerivePbkdf2$hash(algorithm),
      ),
      iterations: $subtle.DeriveAlgorithm$DerivePbkdf2$iterations(algorithm),
      salt: toUint8Array(
        $subtle.DeriveAlgorithm$DerivePbkdf2$salt(algorithm),
      ),
    };
  }
  if ($subtle.DeriveAlgorithm$isDeriveEcDh(algorithm)) {
    return {
      name: "ECDH",
      public: $subtle.DeriveAlgorithm$DeriveEcDh$public(algorithm),
    };
  }
  return {
    name: "X25519",
    public: $subtle.DeriveAlgorithm$DeriveX25519$public(algorithm),
  };
}

function toSymmetricKeyParams(
  params: $subtle.SymmetricKeyParams$,
):
  | AlgorithmIdentifier
  | AesKeyGenParams
  | AesDerivedKeyParams
  | HmacKeyGenParams
  | HmacImportParams {
  if ($subtle.SymmetricKeyParams$isAes(params)) {
    return {
      name: toAesAlgorithm($subtle.SymmetricKeyParams$Aes$name(params)),
      length: $subtle.SymmetricKeyParams$Aes$length(params),
    };
  }
  return {
    name: "HMAC",
    hash: toHashAlgorithm($subtle.SymmetricKeyParams$Hmac$hash(params)),
  };
}

function toEncryptAlgorithm(
  algorithm: $subtle.EncryptAlgorithm$,
):
  | AlgorithmIdentifier
  | AesCbcParams
  | AesGcmParams
  | AesCtrParams
  | RsaOaepParams {
  if ($subtle.EncryptAlgorithm$isEncryptAesCbc(algorithm)) {
    return {
      name: "AES-CBC",
      iv: toUint8Array(
        $subtle.EncryptAlgorithm$EncryptAesCbc$iv(algorithm),
      ),
    };
  }
  if ($subtle.EncryptAlgorithm$isEncryptAesGcm(algorithm)) {
    const params: AesGcmParams = {
      name: "AES-GCM",
      iv: toUint8Array($subtle.EncryptAlgorithm$EncryptAesGcm$iv(algorithm)),
      additionalData: toUint8Array(
        $subtle.EncryptAlgorithm$EncryptAesGcm$additional_data(algorithm),
      ),
    };
    setIfSome(
      params,
      "tagLength",
      $subtle.EncryptAlgorithm$EncryptAesGcm$tag_length(algorithm),
    );
    return params;
  }
  if ($subtle.EncryptAlgorithm$isEncryptAesCtr(algorithm)) {
    return {
      name: "AES-CTR",
      counter: toUint8Array(
        $subtle.EncryptAlgorithm$EncryptAesCtr$counter(algorithm),
      ),
      length: $subtle.EncryptAlgorithm$EncryptAesCtr$length(algorithm),
    };
  }
  return {
    name: "RSA-OAEP",
    label: toUint8Array(
      $subtle.EncryptAlgorithm$EncryptRsaOaep$label(algorithm),
    ),
  };
}

function toImportAlgorithm(
  algorithm: $subtle.ImportAlgorithm$,
):
  | AlgorithmIdentifier
  | HmacImportParams
  | RsaHashedImportParams
  | EcKeyImportParams {
  if ($subtle.ImportAlgorithm$isImportAes(algorithm)) {
    return toAesAlgorithm($subtle.ImportAlgorithm$ImportAes$name(algorithm));
  }
  if ($subtle.ImportAlgorithm$isImportHmac(algorithm)) {
    return {
      name: "HMAC",
      hash: toHashAlgorithm(
        $subtle.ImportAlgorithm$ImportHmac$hash(algorithm),
      ),
    };
  }
  if ($subtle.ImportAlgorithm$isImportRsaHashed(algorithm)) {
    return {
      name: toRsaAlgorithm(
        $subtle.ImportAlgorithm$ImportRsaHashed$name(algorithm),
      ),
      hash: toHashAlgorithm(
        $subtle.ImportAlgorithm$ImportRsaHashed$hash(algorithm),
      ),
    };
  }
  if ($subtle.ImportAlgorithm$isImportEc(algorithm)) {
    return {
      name: toEcAlgorithm(
        $subtle.ImportAlgorithm$ImportEc$name(algorithm),
      ),
      namedCurve: toNamedCurve(
        $subtle.ImportAlgorithm$ImportEc$named_curve(algorithm),
      ),
    };
  }
  if ($subtle.ImportAlgorithm$isImportEd25519(algorithm)) return "Ed25519";
  if ($subtle.ImportAlgorithm$isImportX25519(algorithm)) return "X25519";
  if ($subtle.ImportAlgorithm$isImportHkdf(algorithm)) return "HKDF";
  return "PBKDF2";
}

function toKeyPairGenAlgorithm(
  algorithm: $subtle.KeyPairGenAlgorithm$,
): AlgorithmIdentifier | RsaHashedKeyGenParams | EcKeyGenParams {
  if ($subtle.KeyPairGenAlgorithm$isKeyPairGenRsa(algorithm)) {
    return {
      name: toRsaAlgorithm(
        $subtle.KeyPairGenAlgorithm$KeyPairGenRsa$name(algorithm),
      ),
      modulusLength: $subtle.KeyPairGenAlgorithm$KeyPairGenRsa$modulus_length(
        algorithm,
      ),
      publicExponent: toUint8Array(
        $subtle.KeyPairGenAlgorithm$KeyPairGenRsa$public_exponent(algorithm),
      ),
      hash: toHashAlgorithm(
        $subtle.KeyPairGenAlgorithm$KeyPairGenRsa$hash(algorithm),
      ),
    };
  }
  if ($subtle.KeyPairGenAlgorithm$isKeyPairGenEd25519(algorithm)) {
    return "Ed25519";
  }
  if ($subtle.KeyPairGenAlgorithm$isKeyPairGenX25519(algorithm)) {
    return "X25519";
  }
  return {
    name: toEcAlgorithm(
      $subtle.KeyPairGenAlgorithm$KeyPairGenEc$name(algorithm),
    ),
    namedCurve: toNamedCurve(
      $subtle.KeyPairGenAlgorithm$KeyPairGenEc$named_curve(algorithm),
    ),
  };
}

function toSignAlgorithm(
  algorithm: $subtle.SignAlgorithm$,
): AlgorithmIdentifier | RsaPssParams | EcdsaParams {
  if ($subtle.SignAlgorithm$isSignHmac(algorithm)) return "HMAC";
  if ($subtle.SignAlgorithm$isSignRsaSsaPkcs1V15(algorithm)) {
    return "RSASSA-PKCS1-v1_5";
  }
  if ($subtle.SignAlgorithm$isSignRsaPss(algorithm)) {
    return {
      name: "RSA-PSS",
      saltLength: $subtle.SignAlgorithm$SignRsaPss$salt_length(algorithm),
    };
  }
  if ($subtle.SignAlgorithm$isSignEcDsa(algorithm)) {
    return {
      name: "ECDSA",
      hash: toHashAlgorithm(
        $subtle.SignAlgorithm$SignEcDsa$hash(algorithm),
      ),
    };
  }
  return "Ed25519";
}

function toWrapAlgorithm(
  algorithm: $subtle.WrapAlgorithm$,
):
  | AlgorithmIdentifier
  | AesCbcParams
  | AesCtrParams
  | AesGcmParams
  | RsaOaepParams {
  if ($subtle.WrapAlgorithm$isWrapAesCbc(algorithm)) {
    return {
      name: "AES-CBC",
      iv: toUint8Array(
        $subtle.WrapAlgorithm$WrapAesCbc$iv(algorithm),
      ),
    };
  }
  if ($subtle.WrapAlgorithm$isWrapAesCtr(algorithm)) {
    return {
      name: "AES-CTR",
      counter: toUint8Array(
        $subtle.WrapAlgorithm$WrapAesCtr$counter(algorithm),
      ),
      length: $subtle.WrapAlgorithm$WrapAesCtr$length(algorithm),
    };
  }
  if ($subtle.WrapAlgorithm$isWrapAesGcm(algorithm)) {
    const params: AesGcmParams = {
      name: "AES-GCM",
      iv: toUint8Array($subtle.WrapAlgorithm$WrapAesGcm$iv(algorithm)),
      additionalData: toUint8Array(
        $subtle.WrapAlgorithm$WrapAesGcm$additional_data(algorithm),
      ),
    };
    setIfSome(
      params,
      "tagLength",
      $subtle.WrapAlgorithm$WrapAesGcm$tag_length(algorithm),
    );
    return params;
  }
  if ($subtle.WrapAlgorithm$isWrapAesKw(algorithm)) return "AES-KW";
  return {
    name: "RSA-OAEP",
    label: toUint8Array($subtle.WrapAlgorithm$WrapRsaOaep$label(algorithm)),
  };
}

export const digest: typeof $subtle.digest = (algorithm, data) => {
  return toCryptoBitArrayResult(() =>
    subtle.digest(toHashAlgorithm(algorithm), toUint8Array(data))
  );
};

export const encrypt: typeof $subtle.encrypt = (
  algorithm,
  key,
  data,
) => {
  const usageError = checkUsage(key, "encrypt");
  if (usageError) return Promise.resolve(Result$Error(usageError));
  return toCryptoBitArrayResult(() =>
    subtle.encrypt(toEncryptAlgorithm(algorithm), key, toUint8Array(data))
  );
};

export const decrypt: typeof $subtle.decrypt = (
  algorithm,
  key,
  data,
) => {
  const usageError = checkUsage(key, "decrypt");
  if (usageError) return Promise.resolve(Result$Error(usageError));
  return toCryptoBitArrayResult(() =>
    subtle.decrypt(toEncryptAlgorithm(algorithm), key, toUint8Array(data))
  );
};

export const sign: typeof $subtle.sign = (algorithm, key, data) => {
  const usageError = checkUsage(key, "sign");
  if (usageError) return Promise.resolve(Result$Error(usageError));
  return toCryptoBitArrayResult(() =>
    subtle.sign(toSignAlgorithm(algorithm), key, toUint8Array(data))
  );
};

export const verify: typeof $subtle.verify = (
  algorithm,
  key,
  signature,
  data,
) => {
  const usageError = checkUsage(key, "verify");
  if (usageError) return Promise.resolve(Result$Error(usageError));
  return toCryptoResult(() =>
    subtle.verify(
      toSignAlgorithm(algorithm),
      key,
      toUint8Array(signature),
      toUint8Array(data),
    )
  );
};

export const generate_key: typeof $subtle.generate_key = (
  algorithm,
  extractable,
  usages,
) => {
  return toCryptoResult(() =>
    subtle.generateKey(
      toSymmetricKeyParams(algorithm),
      extractable,
      toKeyUsageArray(usages),
    ) as Promise<CryptoKey>
  );
};

export const generate_key_pair: typeof $subtle.generate_key_pair = (
  algorithm,
  extractable,
  usages,
) => {
  return toCryptoResult(async () =>
    toCryptoKeyPair(
      await (subtle.generateKey(
        toKeyPairGenAlgorithm(algorithm),
        extractable,
        toKeyUsageArray(usages),
      ) as Promise<CryptoKeyPair>),
    )
  );
};

export const import_key: typeof $subtle.import_key = (
  format,
  keyData,
  algorithm,
  extractable,
  usages,
) => {
  return toCryptoResult(() =>
    subtle.importKey(
      toKeyFormat(format),
      toUint8Array(keyData),
      toImportAlgorithm(algorithm),
      extractable,
      toKeyUsageArray(usages),
    )
  );
};

export const import_key_jwk: typeof $subtle.import_key_jwk = (
  keyData,
  algorithm,
  extractable,
  usages,
) => {
  return toCryptoResult(() =>
    subtle.importKey(
      "jwk",
      toJsonWebKey(keyData),
      toImportAlgorithm(algorithm),
      extractable,
      toKeyUsageArray(usages),
    )
  );
};

export const export_key: typeof $subtle.export_key = (format, key) => {
  const extractableError = checkExtractable(key);
  if (extractableError) return Promise.resolve(Result$Error(extractableError));
  return toCryptoBitArrayResult(() =>
    subtle.exportKey(toKeyFormat(format), key) as Promise<ArrayBuffer>
  );
};

export const export_key_jwk: typeof $subtle.export_key_jwk = (key) => {
  const extractableError = checkExtractable(key);
  if (extractableError) return Promise.resolve(Result$Error(extractableError));
  return toCryptoResult(async () =>
    fromJsonWebKey(await (subtle.exportKey("jwk", key) as Promise<JsonWebKey>))
  );
};

export const derive_bits: typeof $subtle.derive_bits = (
  algorithm,
  baseKey,
  length,
) => {
  const usageError = checkUsage(baseKey, "deriveBits");
  if (usageError) return Promise.resolve(Result$Error(usageError));
  return toCryptoBitArrayResult(() =>
    subtle.deriveBits(toDeriveAlgorithm(algorithm), baseKey, length)
  );
};

export const derive_key: typeof $subtle.derive_key = (
  algorithm,
  baseKey,
  derived_key_type,
  extractable,
  usages,
) => {
  const usageError = checkUsage(baseKey, "deriveKey");
  if (usageError) return Promise.resolve(Result$Error(usageError));
  return toCryptoResult(() =>
    subtle.deriveKey(
      toDeriveAlgorithm(algorithm),
      baseKey,
      toSymmetricKeyParams(derived_key_type),
      extractable,
      toKeyUsageArray(usages),
    )
  );
};

export const wrap_key: typeof $subtle.wrap_key = (
  format,
  key,
  wrappingKey,
  algorithm,
) => {
  const extractableError = checkExtractable(key);
  if (extractableError) return Promise.resolve(Result$Error(extractableError));
  const usageError = checkUsage(wrappingKey, "wrapKey");
  if (usageError) return Promise.resolve(Result$Error(usageError));
  return toCryptoBitArrayResult(() =>
    subtle.wrapKey(
      toKeyFormat(format),
      key,
      wrappingKey,
      toWrapAlgorithm(algorithm),
    )
  );
};

export const wrap_key_jwk: typeof $subtle.wrap_key_jwk = (
  key,
  wrappingKey,
  algorithm,
) => {
  const extractableError = checkExtractable(key);
  if (extractableError) return Promise.resolve(Result$Error(extractableError));
  const usageError = checkUsage(wrappingKey, "wrapKey");
  if (usageError) return Promise.resolve(Result$Error(usageError));
  return toCryptoBitArrayResult(() =>
    subtle.wrapKey("jwk", key, wrappingKey, toWrapAlgorithm(algorithm))
  );
};

export const unwrap_key: typeof $subtle.unwrap_key = (
  format,
  wrappedKey,
  unwrappingKey,
  unwrapAlgorithm,
  unwrappedKeyAlgorithm,
  extractable,
  usages,
) => {
  const usageError = checkUsage(unwrappingKey, "unwrapKey");
  if (usageError) return Promise.resolve(Result$Error(usageError));
  return toCryptoResult(() =>
    subtle.unwrapKey(
      toKeyFormat(format),
      toUint8Array(wrappedKey),
      unwrappingKey,
      toWrapAlgorithm(unwrapAlgorithm),
      toImportAlgorithm(unwrappedKeyAlgorithm),
      extractable,
      toKeyUsageArray(usages),
    )
  );
};

export const unwrap_key_jwk: typeof $subtle.unwrap_key_jwk = (
  wrappedKey,
  unwrappingKey,
  unwrapAlgorithm,
  unwrappedKeyAlgorithm,
  extractable,
  usages,
) => {
  const usageError = checkUsage(unwrappingKey, "unwrapKey");
  if (usageError) return Promise.resolve(Result$Error(usageError));
  return toCryptoResult(() =>
    subtle.unwrapKey(
      "jwk",
      toUint8Array(wrappedKey),
      unwrappingKey,
      toWrapAlgorithm(unwrapAlgorithm),
      toImportAlgorithm(unwrappedKeyAlgorithm),
      extractable,
      toKeyUsageArray(usages),
    )
  );
};
