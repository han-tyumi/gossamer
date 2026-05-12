import * as $key from "$/gossamer/gossamer/crypto/key.mjs";
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
import { toBufferSource, toUint8Array } from "~/utils/bit_array.ffi.ts";

const subtle = globalThis.crypto.subtle;

function toCryptoError(value: unknown): $subtle.CryptoError$ {
  if (value instanceof Error) {
    switch (value.name) {
      case "NotSupportedError":
        return $subtle.CryptoError$AlgorithmNotSupported();
      case "InvalidAccessError":
        return $subtle.CryptoError$InvalidAccess();
      case "OperationError":
        return $subtle.CryptoError$OperationFailed();
      case "DataError":
        return $subtle.CryptoError$DataMalformed();
      case "QuotaExceededError":
        return $subtle.CryptoError$QuotaExceeded();
    }
    return $subtle.CryptoError$OtherError(value.message);
  }
  return $subtle.CryptoError$OtherError(String(value));
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

const keyUsageVariants: Record<KeyUsage, () => $key.KeyUsage$> = {
  encrypt: $key.KeyUsage$Encrypt,
  decrypt: $key.KeyUsage$Decrypt,
  sign: $key.KeyUsage$Sign,
  verify: $key.KeyUsage$Verify,
  deriveKey: $key.KeyUsage$DeriveKey,
  deriveBits: $key.KeyUsage$DeriveBits,
  wrapKey: $key.KeyUsage$WrapKey,
  unwrapKey: $key.KeyUsage$UnwrapKey,
};

function usageMismatch(required: KeyUsage): $subtle.CryptoError$ {
  return $subtle.CryptoError$KeyUsageMismatch(
    keyUsageVariants[required](),
  );
}

function checkUsage(
  key: CryptoKey,
  required: KeyUsage,
): $subtle.CryptoError$ | null {
  return key.usages.includes(required) ? null : usageMismatch(required);
}

function checkExtractable(key: CryptoKey): $subtle.CryptoError$ | null {
  return key.extractable ? null : $subtle.CryptoError$KeyNotExtractable();
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
  if ($subtle.DeriveAlgorithm$isDeriveOther(algorithm)) {
    return $subtle.DeriveAlgorithm$DeriveOther$0(algorithm);
  }
  if ($subtle.DeriveAlgorithm$isHkdf(algorithm)) {
    return {
      name: "HKDF",
      hash: toHashAlgorithm(
        $subtle.DeriveAlgorithm$Hkdf$hash(algorithm),
      ),
      info: toBufferSource(
        $subtle.DeriveAlgorithm$Hkdf$info(algorithm),
      ),
      salt: toBufferSource(
        $subtle.DeriveAlgorithm$Hkdf$salt(algorithm),
      ),
    };
  }
  if ($subtle.DeriveAlgorithm$isPbkdf2(algorithm)) {
    return {
      name: "PBKDF2",
      hash: toHashAlgorithm(
        $subtle.DeriveAlgorithm$Pbkdf2$hash(algorithm),
      ),
      iterations: $subtle.DeriveAlgorithm$Pbkdf2$iterations(algorithm),
      salt: toBufferSource(
        $subtle.DeriveAlgorithm$Pbkdf2$salt(algorithm),
      ),
    };
  }
  return {
    name: "ECDH",
    public: $subtle.DeriveAlgorithm$EcDh$public(algorithm),
  };
}

function toDerivedKeyType(
  derivedKeyType: $subtle.DerivedKeyType$,
): AlgorithmIdentifier | AesDerivedKeyParams | HmacImportParams {
  if ($subtle.DerivedKeyType$isDerivedKeyOther(derivedKeyType)) {
    return $subtle.DerivedKeyType$DerivedKeyOther$0(derivedKeyType);
  }
  if ($subtle.DerivedKeyType$isAesDerived(derivedKeyType)) {
    return {
      name: toAesAlgorithm(
        $subtle.DerivedKeyType$AesDerived$name(derivedKeyType),
      ),
      length: $subtle.DerivedKeyType$AesDerived$length(derivedKeyType),
    };
  }
  return {
    name: "HMAC",
    hash: toHashAlgorithm(
      $subtle.DerivedKeyType$HmacDerived$hash(derivedKeyType),
    ),
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
  if ($subtle.EncryptAlgorithm$isEncryptOther(algorithm)) {
    return $subtle.EncryptAlgorithm$EncryptOther$0(algorithm);
  }
  if ($subtle.EncryptAlgorithm$isEncryptAesCbc(algorithm)) {
    return {
      name: "AES-CBC",
      iv: toBufferSource(
        $subtle.EncryptAlgorithm$EncryptAesCbc$iv(algorithm),
      ),
    };
  }
  if ($subtle.EncryptAlgorithm$isAesGcm(algorithm)) {
    return {
      name: "AES-GCM",
      iv: toBufferSource($subtle.EncryptAlgorithm$AesGcm$iv(algorithm)),
    };
  }
  if ($subtle.EncryptAlgorithm$isAesGcmWith(algorithm)) {
    return {
      name: "AES-GCM",
      iv: toBufferSource(
        $subtle.EncryptAlgorithm$AesGcmWith$iv(algorithm),
      ),
      additionalData: toBufferSource(
        $subtle.EncryptAlgorithm$AesGcmWith$additional_data(algorithm),
      ),
      tagLength: $subtle.EncryptAlgorithm$AesGcmWith$tag_length(
        algorithm,
      ),
    };
  }
  if ($subtle.EncryptAlgorithm$isEncryptAesCtr(algorithm)) {
    return {
      name: "AES-CTR",
      counter: toBufferSource(
        $subtle.EncryptAlgorithm$EncryptAesCtr$counter(algorithm),
      ),
      length: $subtle.EncryptAlgorithm$EncryptAesCtr$length(algorithm),
    };
  }
  if ($subtle.EncryptAlgorithm$isEncryptRsaOaepWith(algorithm)) {
    return {
      name: "RSA-OAEP",
      label: toBufferSource(
        $subtle.EncryptAlgorithm$EncryptRsaOaepWith$label(algorithm),
      ),
    };
  }
  return { name: "RSA-OAEP" };
}

function toImportAlgorithm(
  algorithm: $subtle.ImportAlgorithm$,
):
  | AlgorithmIdentifier
  | HmacImportParams
  | RsaHashedImportParams
  | EcKeyImportParams {
  if ($subtle.ImportAlgorithm$isImportOther(algorithm)) {
    return $subtle.ImportAlgorithm$ImportOther$0(algorithm);
  }
  if ($subtle.ImportAlgorithm$isHmacImport(algorithm)) {
    return {
      name: "HMAC",
      hash: toHashAlgorithm(
        $subtle.ImportAlgorithm$HmacImport$hash(algorithm),
      ),
    };
  }
  if ($subtle.ImportAlgorithm$isRsaHashedImport(algorithm)) {
    return {
      name: toRsaAlgorithm(
        $subtle.ImportAlgorithm$RsaHashedImport$name(algorithm),
      ),
      hash: toHashAlgorithm(
        $subtle.ImportAlgorithm$RsaHashedImport$hash(algorithm),
      ),
    };
  }
  return {
    name: toEcAlgorithm(
      $subtle.ImportAlgorithm$EcImport$name(algorithm),
    ),
    namedCurve: toNamedCurve(
      $subtle.ImportAlgorithm$EcImport$named_curve(algorithm),
    ),
  };
}

function toKeyGenAlgorithm(
  algorithm: $subtle.KeyGenAlgorithm$,
): AlgorithmIdentifier | AesKeyGenParams | HmacKeyGenParams {
  if ($subtle.KeyGenAlgorithm$isKeyGenOther(algorithm)) {
    return $subtle.KeyGenAlgorithm$KeyGenOther$0(algorithm);
  }
  if ($subtle.KeyGenAlgorithm$isAes(algorithm)) {
    return {
      name: toAesAlgorithm($subtle.KeyGenAlgorithm$Aes$name(algorithm)),
      length: $subtle.KeyGenAlgorithm$Aes$length(algorithm),
    };
  }
  return {
    name: "HMAC",
    hash: toHashAlgorithm(
      $subtle.KeyGenAlgorithm$HmacGen$hash(algorithm),
    ),
  };
}

function toKeyPairGenAlgorithm(
  algorithm: $subtle.KeyPairGenAlgorithm$,
): AlgorithmIdentifier | RsaHashedKeyGenParams | EcKeyGenParams {
  if ($subtle.KeyPairGenAlgorithm$isKeyPairGenOther(algorithm)) {
    return $subtle.KeyPairGenAlgorithm$KeyPairGenOther$0(algorithm);
  }
  if ($subtle.KeyPairGenAlgorithm$isRsa(algorithm)) {
    return {
      name: toRsaAlgorithm(
        $subtle.KeyPairGenAlgorithm$Rsa$name(algorithm),
      ),
      modulusLength: $subtle.KeyPairGenAlgorithm$Rsa$modulus_length(
        algorithm,
      ),
      // @ts-expect-error denoland/deno#32063 (BigInteger)
      publicExponent: toUint8Array(
        $subtle.KeyPairGenAlgorithm$Rsa$public_exponent(algorithm),
      ),
      hash: toHashAlgorithm(
        $subtle.KeyPairGenAlgorithm$Rsa$hash(algorithm),
      ),
    };
  }
  if ($subtle.KeyPairGenAlgorithm$isEd25519(algorithm)) return "Ed25519";
  if ($subtle.KeyPairGenAlgorithm$isX25519(algorithm)) return "X25519";
  return {
    name: toEcAlgorithm(
      $subtle.KeyPairGenAlgorithm$Ec$name(algorithm),
    ),
    namedCurve: toNamedCurve(
      $subtle.KeyPairGenAlgorithm$Ec$named_curve(algorithm),
    ),
  };
}

function toSignAlgorithm(
  algorithm: $subtle.SignAlgorithm$,
): AlgorithmIdentifier | RsaPssParams | EcdsaParams {
  if ($subtle.SignAlgorithm$isSignOther(algorithm)) {
    return $subtle.SignAlgorithm$SignOther$0(algorithm);
  }
  if ($subtle.SignAlgorithm$isHmac(algorithm)) return "HMAC";
  if ($subtle.SignAlgorithm$isRsaSsaPkcs1V15(algorithm)) {
    return "RSASSA-PKCS1-v1_5";
  }
  if ($subtle.SignAlgorithm$isRsaPss(algorithm)) {
    return {
      name: "RSA-PSS",
      saltLength: $subtle.SignAlgorithm$RsaPss$salt_length(algorithm),
    };
  }
  return {
    name: "ECDSA",
    hash: toHashAlgorithm(
      $subtle.SignAlgorithm$EcDsa$hash(algorithm),
    ),
  };
}

function toWrapAlgorithm(
  algorithm: $subtle.WrapAlgorithm$,
): AlgorithmIdentifier | AesCbcParams | AesCtrParams | RsaOaepParams {
  if ($subtle.WrapAlgorithm$isWrapOther(algorithm)) {
    return $subtle.WrapAlgorithm$WrapOther$0(algorithm);
  }
  if ($subtle.WrapAlgorithm$isWrapAesCbc(algorithm)) {
    return {
      name: "AES-CBC",
      iv: toBufferSource(
        $subtle.WrapAlgorithm$WrapAesCbc$iv(algorithm),
      ),
    };
  }
  if ($subtle.WrapAlgorithm$isWrapAesCtr(algorithm)) {
    return {
      name: "AES-CTR",
      counter: toBufferSource(
        $subtle.WrapAlgorithm$WrapAesCtr$counter(algorithm),
      ),
      length: $subtle.WrapAlgorithm$WrapAesCtr$length(algorithm),
    };
  }
  if ($subtle.WrapAlgorithm$isWrapRsaOaepWith(algorithm)) {
    return {
      name: "RSA-OAEP",
      label: toBufferSource(
        $subtle.WrapAlgorithm$WrapRsaOaepWith$label(algorithm),
      ),
    };
  }
  return { name: "RSA-OAEP" };
}

export const digest: typeof $subtle.digest = (algorithm, data) => {
  return toCryptoBitArrayResult(() =>
    subtle.digest(toHashAlgorithm(algorithm), toBufferSource(data))
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
    subtle.encrypt(toEncryptAlgorithm(algorithm), key, toBufferSource(data))
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
    subtle.decrypt(toEncryptAlgorithm(algorithm), key, toBufferSource(data))
  );
};

export const sign: typeof $subtle.sign = (algorithm, key, data) => {
  const usageError = checkUsage(key, "sign");
  if (usageError) return Promise.resolve(Result$Error(usageError));
  return toCryptoBitArrayResult(() =>
    subtle.sign(toSignAlgorithm(algorithm), key, toBufferSource(data))
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
      toBufferSource(signature),
      toBufferSource(data),
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
      toKeyGenAlgorithm(algorithm),
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
      toBufferSource(keyData),
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
  derivedKeyType,
  extractable,
  usages,
) => {
  const usageError = checkUsage(baseKey, "deriveKey");
  if (usageError) return Promise.resolve(Result$Error(usageError));
  return toCryptoResult(() =>
    subtle.deriveKey(
      toDeriveAlgorithm(algorithm),
      baseKey,
      toDerivedKeyType(derivedKeyType),
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
      toBufferSource(wrappedKey),
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
      toBufferSource(wrappedKey),
      unwrappingKey,
      toWrapAlgorithm(unwrapAlgorithm),
      toImportAlgorithm(unwrappedKeyAlgorithm),
      extractable,
      toKeyUsageArray(usages),
    )
  );
};
