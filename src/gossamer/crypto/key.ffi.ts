import * as $key from "$/gossamer/gossamer/crypto/key.mjs";
import { BitArray$BitArray } from "$/prelude.mjs";
import { fromArrayMapped, toArray } from "~/utils/list.ffi.ts";

export function toAesAlgorithm(value: $key.AesAlgorithm$): string {
  if ($key.AesAlgorithm$isAesCbc(value)) return "AES-CBC";
  if ($key.AesAlgorithm$isAesCtr(value)) return "AES-CTR";
  if ($key.AesAlgorithm$isAesKw(value)) return "AES-KW";
  if ($key.AesAlgorithm$isAesOther(value)) {
    return $key.AesAlgorithm$AesOther$0(value);
  }
  return "AES-GCM";
}

export function fromAesAlgorithm(value: string): $key.AesAlgorithm$ {
  switch (value) {
    case "AES-CBC":
      return $key.AesAlgorithm$AesCbc();
    case "AES-CTR":
      return $key.AesAlgorithm$AesCtr();
    case "AES-GCM":
      return $key.AesAlgorithm$AesGcm();
    case "AES-KW":
      return $key.AesAlgorithm$AesKw();
    default:
      return $key.AesAlgorithm$AesOther(value);
  }
}

export function toRsaAlgorithm(value: $key.RsaAlgorithm$): string {
  if ($key.RsaAlgorithm$isRsaOaep(value)) return "RSA-OAEP";
  if ($key.RsaAlgorithm$isRsaPss(value)) return "RSA-PSS";
  if ($key.RsaAlgorithm$isRsaOther(value)) {
    return $key.RsaAlgorithm$RsaOther$0(value);
  }
  return "RSASSA-PKCS1-v1_5";
}

export function fromRsaAlgorithm(value: string): $key.RsaAlgorithm$ {
  switch (value) {
    case "RSA-OAEP":
      return $key.RsaAlgorithm$RsaOaep();
    case "RSA-PSS":
      return $key.RsaAlgorithm$RsaPss();
    case "RSASSA-PKCS1-v1_5":
      return $key.RsaAlgorithm$RsaSsaPkcs1V15();
    default:
      return $key.RsaAlgorithm$RsaOther(value);
  }
}

export function toEcAlgorithm(value: $key.EcAlgorithm$): string {
  if ($key.EcAlgorithm$isEcDh(value)) return "ECDH";
  if ($key.EcAlgorithm$isEcOther(value)) {
    return $key.EcAlgorithm$EcOther$0(value);
  }
  return "ECDSA";
}

export function fromEcAlgorithm(value: string): $key.EcAlgorithm$ {
  switch (value) {
    case "ECDH":
      return $key.EcAlgorithm$EcDh();
    case "ECDSA":
      return $key.EcAlgorithm$EcDsa();
    default:
      return $key.EcAlgorithm$EcOther(value);
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

export function toHashAlgorithm(value: $key.HashAlgorithm$): string {
  if ($key.HashAlgorithm$isSha1(value)) return "SHA-1";
  if ($key.HashAlgorithm$isSha256(value)) return "SHA-256";
  if ($key.HashAlgorithm$isSha384(value)) return "SHA-384";
  if ($key.HashAlgorithm$isHashOther(value)) {
    return $key.HashAlgorithm$HashOther$0(value);
  }
  return "SHA-512";
}

export function fromHashAlgorithm(value: string): $key.HashAlgorithm$ {
  switch (value) {
    case "SHA-1":
      return $key.HashAlgorithm$Sha1();
    case "SHA-256":
      return $key.HashAlgorithm$Sha256();
    case "SHA-384":
      return $key.HashAlgorithm$Sha384();
    case "SHA-512":
      return $key.HashAlgorithm$Sha512();
    default:
      return $key.HashAlgorithm$HashOther(value);
  }
}

export function toKeyType(value: KeyType): $key.KeyType$ {
  switch (value) {
    case "private":
      return $key.KeyType$Private();
    case "public":
      return $key.KeyType$Public();
    case "secret":
      return $key.KeyType$Secret();
    default:
      throw new Error(
        `gossamer.crypto.key.type_: runtime returned unexpected CryptoKey.type: ${value}`,
      );
  }
}

export function toKeyUsage(value: $key.KeyUsage$): KeyUsage {
  if ($key.KeyUsage$isDecrypt(value)) return "decrypt";
  if ($key.KeyUsage$isDeriveBits(value)) return "deriveBits";
  if ($key.KeyUsage$isDeriveKey(value)) return "deriveKey";
  if ($key.KeyUsage$isEncrypt(value)) return "encrypt";
  if ($key.KeyUsage$isSign(value)) return "sign";
  if ($key.KeyUsage$isUnwrapKey(value)) return "unwrapKey";
  if ($key.KeyUsage$isVerify(value)) return "verify";
  return "wrapKey";
}

export function fromKeyUsage(value: KeyUsage): $key.KeyUsage$ {
  switch (value) {
    case "decrypt":
      return $key.KeyUsage$Decrypt();
    case "deriveBits":
      return $key.KeyUsage$DeriveBits();
    case "deriveKey":
      return $key.KeyUsage$DeriveKey();
    case "encrypt":
      return $key.KeyUsage$Encrypt();
    case "sign":
      return $key.KeyUsage$Sign();
    case "unwrapKey":
      return $key.KeyUsage$UnwrapKey();
    case "verify":
      return $key.KeyUsage$Verify();
    case "wrapKey":
      return $key.KeyUsage$WrapKey();
    default:
      throw new Error(
        `gossamer.crypto.key.usages: runtime returned unexpected KeyUsage: ${value}`,
      );
  }
}

export function toKeyUsageArray(
  usages: Parameters<typeof toArray>[0],
): KeyUsage[] {
  return (toArray(usages) as $key.KeyUsage$[]).map(toKeyUsage);
}

export function toNamedCurve(value: $key.NamedCurve$): string {
  if ($key.NamedCurve$isP256(value)) return "P-256";
  if ($key.NamedCurve$isP384(value)) return "P-384";
  if ($key.NamedCurve$isNamedCurveOther(value)) {
    return $key.NamedCurve$NamedCurveOther$0(value);
  }
  return "P-521";
}

export function fromNamedCurve(value: string): $key.NamedCurve$ {
  switch (value) {
    case "P-256":
      return $key.NamedCurve$P256();
    case "P-384":
      return $key.NamedCurve$P384();
    case "P-521":
      return $key.NamedCurve$P521();
    default:
      return $key.NamedCurve$NamedCurveOther(value);
  }
}

export function toKeyAlgorithm(
  algorithm: KeyAlgorithm,
): $key.KeyAlgorithm$ {
  const name = algorithm.name;

  if ("namedCurve" in algorithm) {
    return $key.KeyAlgorithm$Ec(
      fromEcAlgorithm(name),
      fromNamedCurve((algorithm as EcKeyAlgorithmShape).namedCurve),
    );
  }

  if ("modulusLength" in algorithm) {
    const rsa = algorithm as RsaKeyAlgorithmShape;
    return $key.KeyAlgorithm$Rsa(
      fromRsaAlgorithm(name),
      rsa.modulusLength,
      BitArray$BitArray(new Uint8Array(rsa.publicExponent)),
      fromHashAlgorithm(hashName(rsa.hash)),
    );
  }

  if ("hash" in algorithm) {
    const hmac = algorithm as HmacKeyAlgorithmShape;
    return $key.KeyAlgorithm$Hmac(
      fromHashAlgorithm(hashName(hmac.hash)),
      hmac.length,
    );
  }

  return $key.KeyAlgorithm$Aes(
    fromAesAlgorithm(name),
    (algorithm as AesKeyAlgorithmShape).length,
  );
}

export const algorithm: typeof $key.algorithm = (key) => {
  return toKeyAlgorithm(key.algorithm);
};

export const is_extractable: typeof $key.is_extractable = (key) => {
  return key.extractable;
};

export const type_: typeof $key.type_ = (key) => {
  return toKeyType(key.type);
};

export const usages: typeof $key.usages = (key) => {
  return fromArrayMapped(key.usages, fromKeyUsage);
};
