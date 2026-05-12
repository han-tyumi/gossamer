import * as $cryptoKey from "$/gossamer/gossamer/crypto_key.mjs";
import { BitArray$BitArray } from "$/prelude.mjs";
import { fromArrayMapped, toArray } from "~/utils/list.ffi.ts";

export function toAesAlgorithm(value: $cryptoKey.AesAlgorithm$): string {
  if ($cryptoKey.AesAlgorithm$isAesCbc(value)) return "AES-CBC";
  if ($cryptoKey.AesAlgorithm$isAesCtr(value)) return "AES-CTR";
  if ($cryptoKey.AesAlgorithm$isAesKw(value)) return "AES-KW";
  if ($cryptoKey.AesAlgorithm$isAesOther(value)) {
    return $cryptoKey.AesAlgorithm$AesOther$0(value);
  }
  return "AES-GCM";
}

export function fromAesAlgorithm(value: string): $cryptoKey.AesAlgorithm$ {
  switch (value) {
    case "AES-CBC":
      return $cryptoKey.AesAlgorithm$AesCbc();
    case "AES-CTR":
      return $cryptoKey.AesAlgorithm$AesCtr();
    case "AES-GCM":
      return $cryptoKey.AesAlgorithm$AesGcm();
    case "AES-KW":
      return $cryptoKey.AesAlgorithm$AesKw();
    default:
      return $cryptoKey.AesAlgorithm$AesOther(value);
  }
}

export function toRsaAlgorithm(value: $cryptoKey.RsaAlgorithm$): string {
  if ($cryptoKey.RsaAlgorithm$isRsaOaep(value)) return "RSA-OAEP";
  if ($cryptoKey.RsaAlgorithm$isRsaPss(value)) return "RSA-PSS";
  if ($cryptoKey.RsaAlgorithm$isRsaOther(value)) {
    return $cryptoKey.RsaAlgorithm$RsaOther$0(value);
  }
  return "RSASSA-PKCS1-v1_5";
}

export function fromRsaAlgorithm(value: string): $cryptoKey.RsaAlgorithm$ {
  switch (value) {
    case "RSA-OAEP":
      return $cryptoKey.RsaAlgorithm$RsaOaep();
    case "RSA-PSS":
      return $cryptoKey.RsaAlgorithm$RsaPss();
    case "RSASSA-PKCS1-v1_5":
      return $cryptoKey.RsaAlgorithm$RsaSsaPkcs1V15();
    default:
      return $cryptoKey.RsaAlgorithm$RsaOther(value);
  }
}

export function toEcAlgorithm(value: $cryptoKey.EcAlgorithm$): string {
  if ($cryptoKey.EcAlgorithm$isEcDh(value)) return "ECDH";
  if ($cryptoKey.EcAlgorithm$isEcOther(value)) {
    return $cryptoKey.EcAlgorithm$EcOther$0(value);
  }
  return "ECDSA";
}

export function fromEcAlgorithm(value: string): $cryptoKey.EcAlgorithm$ {
  switch (value) {
    case "ECDH":
      return $cryptoKey.EcAlgorithm$EcDh();
    case "ECDSA":
      return $cryptoKey.EcAlgorithm$EcDsa();
    default:
      return $cryptoKey.EcAlgorithm$EcOther(value);
  }
}

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

export function toHashAlgorithm(value: $cryptoKey.HashAlgorithm$): string {
  if ($cryptoKey.HashAlgorithm$isSha1(value)) return "SHA-1";
  if ($cryptoKey.HashAlgorithm$isSha256(value)) return "SHA-256";
  if ($cryptoKey.HashAlgorithm$isSha384(value)) return "SHA-384";
  if ($cryptoKey.HashAlgorithm$isHashOther(value)) {
    return $cryptoKey.HashAlgorithm$HashOther$0(value);
  }
  return "SHA-512";
}

export function fromHashAlgorithm(value: string): $cryptoKey.HashAlgorithm$ {
  switch (value) {
    case "SHA-1":
      return $cryptoKey.HashAlgorithm$Sha1();
    case "SHA-256":
      return $cryptoKey.HashAlgorithm$Sha256();
    case "SHA-384":
      return $cryptoKey.HashAlgorithm$Sha384();
    case "SHA-512":
      return $cryptoKey.HashAlgorithm$Sha512();
    default:
      return $cryptoKey.HashAlgorithm$HashOther(value);
  }
}

export function toKeyType(value: KeyType): $cryptoKey.KeyType$ {
  switch (value) {
    case "private":
      return $cryptoKey.KeyType$Private();
    case "public":
      return $cryptoKey.KeyType$Public();
    case "secret":
      return $cryptoKey.KeyType$Secret();
    default:
      throw new Error(
        `gossamer.crypto_key.type_: runtime returned unexpected CryptoKey.type: ${value}`,
      );
  }
}

export function toKeyUsage(value: $cryptoKey.KeyUsage$): KeyUsage {
  if ($cryptoKey.KeyUsage$isDecrypt(value)) return "decrypt";
  if ($cryptoKey.KeyUsage$isDeriveBits(value)) return "deriveBits";
  if ($cryptoKey.KeyUsage$isDeriveKey(value)) return "deriveKey";
  if ($cryptoKey.KeyUsage$isEncrypt(value)) return "encrypt";
  if ($cryptoKey.KeyUsage$isSign(value)) return "sign";
  if ($cryptoKey.KeyUsage$isUnwrapKey(value)) return "unwrapKey";
  if ($cryptoKey.KeyUsage$isVerify(value)) return "verify";
  return "wrapKey";
}

export function fromKeyUsage(value: KeyUsage): $cryptoKey.KeyUsage$ {
  switch (value) {
    case "decrypt":
      return $cryptoKey.KeyUsage$Decrypt();
    case "deriveBits":
      return $cryptoKey.KeyUsage$DeriveBits();
    case "deriveKey":
      return $cryptoKey.KeyUsage$DeriveKey();
    case "encrypt":
      return $cryptoKey.KeyUsage$Encrypt();
    case "sign":
      return $cryptoKey.KeyUsage$Sign();
    case "unwrapKey":
      return $cryptoKey.KeyUsage$UnwrapKey();
    case "verify":
      return $cryptoKey.KeyUsage$Verify();
    case "wrapKey":
      return $cryptoKey.KeyUsage$WrapKey();
    default:
      throw new Error(
        `gossamer.crypto_key.usages: runtime returned unexpected KeyUsage: ${value}`,
      );
  }
}

export function toKeyUsageArray(
  usages: Parameters<typeof toArray>[0],
): KeyUsage[] {
  return (toArray(usages) as $cryptoKey.KeyUsage$[]).map(toKeyUsage);
}

export function toNamedCurve(value: $cryptoKey.NamedCurve$): string {
  if ($cryptoKey.NamedCurve$isP256(value)) return "P-256";
  if ($cryptoKey.NamedCurve$isP384(value)) return "P-384";
  if ($cryptoKey.NamedCurve$isNamedCurveOther(value)) {
    return $cryptoKey.NamedCurve$NamedCurveOther$0(value);
  }
  return "P-521";
}

export function fromNamedCurve(value: string): $cryptoKey.NamedCurve$ {
  switch (value) {
    case "P-256":
      return $cryptoKey.NamedCurve$P256();
    case "P-384":
      return $cryptoKey.NamedCurve$P384();
    case "P-521":
      return $cryptoKey.NamedCurve$P521();
    default:
      return $cryptoKey.NamedCurve$NamedCurveOther(value);
  }
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
      BitArray$BitArray(new Uint8Array(rsa.publicExponent)),
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
