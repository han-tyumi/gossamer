import * as $subtleCrypto from "$/gossamer/gossamer/subtle_crypto.mjs";
import { toAesAlgorithm } from "~/gossamer/aes_algorithm.ffi.ts";
import {
  toHashAlgorithm,
  toKeyUsageArray,
  toNamedCurve,
} from "~/gossamer/crypto_key.ffi.ts";
import { toEcAlgorithm } from "~/gossamer/ec_algorithm.ffi.ts";
import { fromJsonWebKey, toJsonWebKey } from "~/gossamer/json_web_key.ffi.ts";
import { toRsaAlgorithm } from "~/gossamer/rsa_algorithm.ffi.ts";
import {
  toBitArrayResult,
  toBufferSource,
  toUint8Array,
} from "~/utils/bit_array.ffi.ts";
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

function toKeyFormat(
  value: $subtleCrypto.KeyFormat$,
): Exclude<KeyFormat, "jwk"> {
  if ($subtleCrypto.KeyFormat$isPkcs8(value)) return "pkcs8";
  if ($subtleCrypto.KeyFormat$isRaw(value)) return "raw";
  if ($subtleCrypto.KeyFormat$isKeyFormatOther(value)) {
    return $subtleCrypto.KeyFormat$KeyFormatOther$0(value) as Exclude<
      KeyFormat,
      "jwk"
    >;
  }
  return "spki";
}

function toDeriveAlgorithm(
  algorithm: $subtleCrypto.DeriveAlgorithm$,
): AlgorithmIdentifier | HkdfParams | Pbkdf2Params | EcdhKeyDeriveParams {
  if ($subtleCrypto.DeriveAlgorithm$isDeriveOther(algorithm)) {
    return $subtleCrypto.DeriveAlgorithm$DeriveOther$0(algorithm);
  }
  if ($subtleCrypto.DeriveAlgorithm$isHkdf(algorithm)) {
    return {
      name: "HKDF",
      hash: toHashAlgorithm(
        $subtleCrypto.DeriveAlgorithm$Hkdf$hash(algorithm),
      ),
      info: toBufferSource(
        $subtleCrypto.DeriveAlgorithm$Hkdf$info(algorithm),
      ),
      salt: toBufferSource(
        $subtleCrypto.DeriveAlgorithm$Hkdf$salt(algorithm),
      ),
    };
  }
  if ($subtleCrypto.DeriveAlgorithm$isPbkdf2(algorithm)) {
    return {
      name: "PBKDF2",
      hash: toHashAlgorithm(
        $subtleCrypto.DeriveAlgorithm$Pbkdf2$hash(algorithm),
      ),
      iterations: $subtleCrypto.DeriveAlgorithm$Pbkdf2$iterations(algorithm),
      salt: toBufferSource(
        $subtleCrypto.DeriveAlgorithm$Pbkdf2$salt(algorithm),
      ),
    };
  }
  return {
    name: "ECDH",
    public: $subtleCrypto.DeriveAlgorithm$Ecdh$public(algorithm),
  };
}

function toDerivedKeyType(
  derivedKeyType: $subtleCrypto.DerivedKeyType$,
): AlgorithmIdentifier | AesDerivedKeyParams | HmacImportParams {
  if ($subtleCrypto.DerivedKeyType$isDerivedKeyOther(derivedKeyType)) {
    return $subtleCrypto.DerivedKeyType$DerivedKeyOther$0(derivedKeyType);
  }
  if ($subtleCrypto.DerivedKeyType$isAesDerived(derivedKeyType)) {
    return {
      name: toAesAlgorithm(
        $subtleCrypto.DerivedKeyType$AesDerived$name(derivedKeyType),
      ),
      length: $subtleCrypto.DerivedKeyType$AesDerived$length(derivedKeyType),
    };
  }
  return {
    name: "HMAC",
    hash: toHashAlgorithm(
      $subtleCrypto.DerivedKeyType$HmacDerived$hash(derivedKeyType),
    ),
  };
}

function toEncryptAlgorithm(
  algorithm: $subtleCrypto.EncryptAlgorithm$,
):
  | AlgorithmIdentifier
  | AesCbcParams
  | AesGcmParams
  | AesCtrParams
  | RsaOaepParams {
  if ($subtleCrypto.EncryptAlgorithm$isEncryptOther(algorithm)) {
    return $subtleCrypto.EncryptAlgorithm$EncryptOther$0(algorithm);
  }
  if ($subtleCrypto.EncryptAlgorithm$isEncryptAesCbc(algorithm)) {
    return {
      name: "AES-CBC",
      iv: toBufferSource(
        $subtleCrypto.EncryptAlgorithm$EncryptAesCbc$iv(algorithm),
      ),
    };
  }
  if ($subtleCrypto.EncryptAlgorithm$isAesGcm(algorithm)) {
    return {
      name: "AES-GCM",
      iv: toBufferSource($subtleCrypto.EncryptAlgorithm$AesGcm$iv(algorithm)),
    };
  }
  if ($subtleCrypto.EncryptAlgorithm$isAesGcmWith(algorithm)) {
    return {
      name: "AES-GCM",
      iv: toBufferSource(
        $subtleCrypto.EncryptAlgorithm$AesGcmWith$iv(algorithm),
      ),
      additionalData: toBufferSource(
        $subtleCrypto.EncryptAlgorithm$AesGcmWith$additional_data(algorithm),
      ),
      tagLength: $subtleCrypto.EncryptAlgorithm$AesGcmWith$tag_length(
        algorithm,
      ),
    };
  }
  if ($subtleCrypto.EncryptAlgorithm$isEncryptAesCtr(algorithm)) {
    return {
      name: "AES-CTR",
      counter: toBufferSource(
        $subtleCrypto.EncryptAlgorithm$EncryptAesCtr$counter(algorithm),
      ),
      length: $subtleCrypto.EncryptAlgorithm$EncryptAesCtr$length(algorithm),
    };
  }
  if ($subtleCrypto.EncryptAlgorithm$isEncryptRsaOaepWith(algorithm)) {
    return {
      name: "RSA-OAEP",
      label: toBufferSource(
        $subtleCrypto.EncryptAlgorithm$EncryptRsaOaepWith$label(algorithm),
      ),
    };
  }
  return { name: "RSA-OAEP" };
}

function toImportAlgorithm(
  algorithm: $subtleCrypto.ImportAlgorithm$,
):
  | AlgorithmIdentifier
  | HmacImportParams
  | RsaHashedImportParams
  | EcKeyImportParams {
  if ($subtleCrypto.ImportAlgorithm$isImportOther(algorithm)) {
    return $subtleCrypto.ImportAlgorithm$ImportOther$0(algorithm);
  }
  if ($subtleCrypto.ImportAlgorithm$isHmacImport(algorithm)) {
    return {
      name: "HMAC",
      hash: toHashAlgorithm(
        $subtleCrypto.ImportAlgorithm$HmacImport$hash(algorithm),
      ),
    };
  }
  if ($subtleCrypto.ImportAlgorithm$isRsaHashedImport(algorithm)) {
    return {
      name: toRsaAlgorithm(
        $subtleCrypto.ImportAlgorithm$RsaHashedImport$name(algorithm),
      ),
      hash: toHashAlgorithm(
        $subtleCrypto.ImportAlgorithm$RsaHashedImport$hash(algorithm),
      ),
    };
  }
  return {
    name: toEcAlgorithm(
      $subtleCrypto.ImportAlgorithm$EcImport$name(algorithm),
    ),
    namedCurve: toNamedCurve(
      $subtleCrypto.ImportAlgorithm$EcImport$named_curve(algorithm),
    ),
  };
}

function toKeyGenAlgorithm(
  algorithm: $subtleCrypto.KeyGenAlgorithm$,
): AlgorithmIdentifier | AesKeyGenParams | HmacKeyGenParams {
  if ($subtleCrypto.KeyGenAlgorithm$isKeyGenOther(algorithm)) {
    return $subtleCrypto.KeyGenAlgorithm$KeyGenOther$0(algorithm);
  }
  if ($subtleCrypto.KeyGenAlgorithm$isAes(algorithm)) {
    return {
      name: toAesAlgorithm($subtleCrypto.KeyGenAlgorithm$Aes$name(algorithm)),
      length: $subtleCrypto.KeyGenAlgorithm$Aes$length(algorithm),
    };
  }
  return {
    name: "HMAC",
    hash: toHashAlgorithm(
      $subtleCrypto.KeyGenAlgorithm$HmacGen$hash(algorithm),
    ),
  };
}

function toKeyPairGenAlgorithm(
  algorithm: $subtleCrypto.KeyPairGenAlgorithm$,
): AlgorithmIdentifier | RsaHashedKeyGenParams | EcKeyGenParams {
  if ($subtleCrypto.KeyPairGenAlgorithm$isKeyPairGenOther(algorithm)) {
    return $subtleCrypto.KeyPairGenAlgorithm$KeyPairGenOther$0(algorithm);
  }
  if ($subtleCrypto.KeyPairGenAlgorithm$isRsa(algorithm)) {
    return {
      name: toRsaAlgorithm(
        $subtleCrypto.KeyPairGenAlgorithm$Rsa$name(algorithm),
      ),
      modulusLength: $subtleCrypto.KeyPairGenAlgorithm$Rsa$modulus_length(
        algorithm,
      ),
      // @ts-expect-error denoland/deno#32063 (BigInteger)
      publicExponent: toUint8Array(
        $subtleCrypto.KeyPairGenAlgorithm$Rsa$public_exponent(algorithm),
      ),
      hash: toHashAlgorithm(
        $subtleCrypto.KeyPairGenAlgorithm$Rsa$hash(algorithm),
      ),
    };
  }
  if ($subtleCrypto.KeyPairGenAlgorithm$isEd25519(algorithm)) return "Ed25519";
  if ($subtleCrypto.KeyPairGenAlgorithm$isX25519(algorithm)) return "X25519";
  return {
    name: toEcAlgorithm(
      $subtleCrypto.KeyPairGenAlgorithm$Ec$name(algorithm),
    ),
    namedCurve: toNamedCurve(
      $subtleCrypto.KeyPairGenAlgorithm$Ec$named_curve(algorithm),
    ),
  };
}

function toSignAlgorithm(
  algorithm: $subtleCrypto.SignAlgorithm$,
): AlgorithmIdentifier | RsaPssParams | EcdsaParams {
  if ($subtleCrypto.SignAlgorithm$isSignOther(algorithm)) {
    return $subtleCrypto.SignAlgorithm$SignOther$0(algorithm);
  }
  if ($subtleCrypto.SignAlgorithm$isHmac(algorithm)) return "HMAC";
  if ($subtleCrypto.SignAlgorithm$isRsassaPkcs1V15(algorithm)) {
    return "RSASSA-PKCS1-v1_5";
  }
  if ($subtleCrypto.SignAlgorithm$isRsaPss(algorithm)) {
    return {
      name: "RSA-PSS",
      saltLength: $subtleCrypto.SignAlgorithm$RsaPss$salt_length(algorithm),
    };
  }
  return {
    name: "ECDSA",
    hash: toHashAlgorithm(
      $subtleCrypto.SignAlgorithm$Ecdsa$hash(algorithm),
    ),
  };
}

function toWrapAlgorithm(
  algorithm: $subtleCrypto.WrapAlgorithm$,
): AlgorithmIdentifier | AesCbcParams | AesCtrParams | RsaOaepParams {
  if ($subtleCrypto.WrapAlgorithm$isWrapOther(algorithm)) {
    return $subtleCrypto.WrapAlgorithm$WrapOther$0(algorithm);
  }
  if ($subtleCrypto.WrapAlgorithm$isWrapAesCbc(algorithm)) {
    return {
      name: "AES-CBC",
      iv: toBufferSource(
        $subtleCrypto.WrapAlgorithm$WrapAesCbc$iv(algorithm),
      ),
    };
  }
  if ($subtleCrypto.WrapAlgorithm$isWrapAesCtr(algorithm)) {
    return {
      name: "AES-CTR",
      counter: toBufferSource(
        $subtleCrypto.WrapAlgorithm$WrapAesCtr$counter(algorithm),
      ),
      length: $subtleCrypto.WrapAlgorithm$WrapAesCtr$length(algorithm),
    };
  }
  if ($subtleCrypto.WrapAlgorithm$isWrapRsaOaepWith(algorithm)) {
    return {
      name: "RSA-OAEP",
      label: toBufferSource(
        $subtleCrypto.WrapAlgorithm$WrapRsaOaepWith$label(algorithm),
      ),
    };
  }
  return { name: "RSA-OAEP" };
}

export const digest: typeof $subtleCrypto.digest = (algorithm, data) => {
  return toBitArrayResult(() =>
    subtle.digest(toHashAlgorithm(algorithm), toBufferSource(data))
  );
};

export const encrypt: typeof $subtleCrypto.encrypt = (
  algorithm,
  key,
  data,
) => {
  return toBitArrayResult(() =>
    subtle.encrypt(toEncryptAlgorithm(algorithm), key, toBufferSource(data))
  );
};

export const decrypt: typeof $subtleCrypto.decrypt = (
  algorithm,
  key,
  data,
) => {
  return toBitArrayResult(() =>
    subtle.decrypt(toEncryptAlgorithm(algorithm), key, toBufferSource(data))
  );
};

export const sign: typeof $subtleCrypto.sign = (algorithm, key, data) => {
  return toBitArrayResult(() =>
    subtle.sign(toSignAlgorithm(algorithm), key, toBufferSource(data))
  );
};

export const verify: typeof $subtleCrypto.verify = (
  algorithm,
  key,
  signature,
  data,
) => {
  return toResult.fromAsync(() =>
    subtle.verify(
      toSignAlgorithm(algorithm),
      key,
      toBufferSource(signature),
      toBufferSource(data),
    )
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
  return toResult.fromAsync(async () =>
    toCryptoKeyPair(
      await (subtle.generateKey(
        toKeyPairGenAlgorithm(algorithm),
        extractable,
        toKeyUsageArray(usages),
      ) as Promise<CryptoKeyPair>),
    )
  );
};

export const import_key: typeof $subtleCrypto.import_key = (
  format,
  keyData,
  algorithm,
  extractable,
  usages,
) => {
  return toResult.fromAsync(() =>
    subtle.importKey(
      toKeyFormat(format),
      toBufferSource(keyData),
      toImportAlgorithm(algorithm),
      extractable,
      toKeyUsageArray(usages),
    )
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
  return toBitArrayResult(() =>
    subtle.exportKey(toKeyFormat(format), key) as Promise<ArrayBuffer>
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
  return toBitArrayResult(() =>
    subtle.deriveBits(toDeriveAlgorithm(algorithm), baseKey, length)
  );
};

export const derive_key: typeof $subtleCrypto.derive_key = (
  algorithm,
  baseKey,
  derivedKeyType,
  extractable,
  usages,
) => {
  return toResult.fromAsync(() =>
    subtle.deriveKey(
      toDeriveAlgorithm(algorithm),
      baseKey,
      toDerivedKeyType(derivedKeyType),
      extractable,
      toKeyUsageArray(usages),
    )
  );
};

export const wrap_key: typeof $subtleCrypto.wrap_key = (
  format,
  key,
  wrappingKey,
  algorithm,
) => {
  return toBitArrayResult(() =>
    subtle.wrapKey(
      toKeyFormat(format),
      key,
      wrappingKey,
      toWrapAlgorithm(algorithm),
    )
  );
};

export const wrap_key_jwk: typeof $subtleCrypto.wrap_key_jwk = (
  key,
  wrappingKey,
  algorithm,
) => {
  return toBitArrayResult(() =>
    subtle.wrapKey("jwk", key, wrappingKey, toWrapAlgorithm(algorithm))
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
  return toResult.fromAsync(() =>
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

export const unwrap_key_jwk: typeof $subtleCrypto.unwrap_key_jwk = (
  wrappedKey,
  unwrappingKey,
  unwrapAlgorithm,
  unwrappedKeyAlgorithm,
  extractable,
  usages,
) => {
  return toResult.fromAsync(() =>
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
