import * as $crypto from "$/gossamer/gossamer/crypto.mjs";
import * as $key from "$/gossamer/gossamer/crypto/key.mjs";
import { BitArray$BitArray } from "$/prelude.mjs";
import { fromArrayMapped, toArray } from "~/utils/list.ffi.ts";

export function toAesAlgorithm(value: $crypto.AesAlgorithm$): string {
  if ($crypto.AesAlgorithm$isCbc(value)) return "AES-CBC";
  if ($crypto.AesAlgorithm$isCtr(value)) return "AES-CTR";
  if ($crypto.AesAlgorithm$isKw(value)) return "AES-KW";
  return "AES-GCM";
}

export function fromAesAlgorithm(value: string): $crypto.AesAlgorithm$ {
  switch (value) {
    case "AES-CBC":
      return $crypto.AesAlgorithm$Cbc();
    case "AES-CTR":
      return $crypto.AesAlgorithm$Ctr();
    case "AES-GCM":
      return $crypto.AesAlgorithm$Gcm();
    case "AES-KW":
      return $crypto.AesAlgorithm$Kw();
    default:
      throw new Error(
        `gossamer.crypto: runtime returned unexpected AES algorithm: ${value}`,
      );
  }
}

export function toRsaAlgorithm(value: $crypto.RsaAlgorithm$): string {
  if ($crypto.RsaAlgorithm$isOaep(value)) return "RSA-OAEP";
  if ($crypto.RsaAlgorithm$isPss(value)) return "RSA-PSS";
  return "RSASSA-PKCS1-v1_5";
}

export function fromRsaAlgorithm(value: string): $crypto.RsaAlgorithm$ {
  switch (value) {
    case "RSA-OAEP":
      return $crypto.RsaAlgorithm$Oaep();
    case "RSA-PSS":
      return $crypto.RsaAlgorithm$Pss();
    case "RSASSA-PKCS1-v1_5":
      return $crypto.RsaAlgorithm$SsaPkcs1V15();
    default:
      throw new Error(
        `gossamer.crypto: runtime returned unexpected RSA algorithm: ${value}`,
      );
  }
}

export function toEcAlgorithm(value: $crypto.EcAlgorithm$): string {
  if ($crypto.EcAlgorithm$isDh(value)) return "ECDH";
  return "ECDSA";
}

export function fromEcAlgorithm(value: string): $crypto.EcAlgorithm$ {
  switch (value) {
    case "ECDH":
      return $crypto.EcAlgorithm$Dh();
    case "ECDSA":
      return $crypto.EcAlgorithm$Dsa();
    default:
      throw new Error(
        `gossamer.crypto: runtime returned unexpected EC algorithm: ${value}`,
      );
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

export function toHashAlgorithm(value: $crypto.HashAlgorithm$): string {
  if ($crypto.HashAlgorithm$isSha1(value)) return "SHA-1";
  if ($crypto.HashAlgorithm$isSha256(value)) return "SHA-256";
  if ($crypto.HashAlgorithm$isSha384(value)) return "SHA-384";
  return "SHA-512";
}

export function fromHashAlgorithm(value: string): $crypto.HashAlgorithm$ {
  switch (value) {
    case "SHA-1":
      return $crypto.HashAlgorithm$Sha1();
    case "SHA-256":
      return $crypto.HashAlgorithm$Sha256();
    case "SHA-384":
      return $crypto.HashAlgorithm$Sha384();
    case "SHA-512":
      return $crypto.HashAlgorithm$Sha512();
    default:
      throw new Error(
        `gossamer.crypto: runtime returned unexpected hash algorithm: ${value}`,
      );
  }
}

export function toKeyKind(value: KeyType): $crypto.KeyKind$ {
  switch (value) {
    case "private":
      return $crypto.KeyKind$Private();
    case "public":
      return $crypto.KeyKind$Public();
    case "secret":
      return $crypto.KeyKind$Secret();
    default:
      throw new Error(
        `gossamer.crypto.key.kind: runtime returned unexpected CryptoKey.type: ${value}`,
      );
  }
}

export function toKeyUsage(value: $crypto.KeyUsage$): KeyUsage {
  if ($crypto.KeyUsage$isDecrypt(value)) return "decrypt";
  if ($crypto.KeyUsage$isDeriveBits(value)) return "deriveBits";
  if ($crypto.KeyUsage$isDeriveKey(value)) return "deriveKey";
  if ($crypto.KeyUsage$isEncrypt(value)) return "encrypt";
  if ($crypto.KeyUsage$isSign(value)) return "sign";
  if ($crypto.KeyUsage$isUnwrapKey(value)) return "unwrapKey";
  if ($crypto.KeyUsage$isVerify(value)) return "verify";
  return "wrapKey";
}

export function fromKeyUsage(value: KeyUsage): $crypto.KeyUsage$ {
  switch (value) {
    case "decrypt":
      return $crypto.KeyUsage$Decrypt();
    case "deriveBits":
      return $crypto.KeyUsage$DeriveBits();
    case "deriveKey":
      return $crypto.KeyUsage$DeriveKey();
    case "encrypt":
      return $crypto.KeyUsage$Encrypt();
    case "sign":
      return $crypto.KeyUsage$Sign();
    case "unwrapKey":
      return $crypto.KeyUsage$UnwrapKey();
    case "verify":
      return $crypto.KeyUsage$Verify();
    case "wrapKey":
      return $crypto.KeyUsage$WrapKey();
    default:
      throw new Error(
        `gossamer.crypto.key.usages: runtime returned unexpected KeyUsage: ${value}`,
      );
  }
}

export function toKeyUsageArray(
  usages: Parameters<typeof toArray>[0],
): KeyUsage[] {
  return (toArray(usages) as $crypto.KeyUsage$[]).map(toKeyUsage);
}

export function toNamedCurve(value: $crypto.NamedCurve$): string {
  if ($crypto.NamedCurve$isP256(value)) return "P-256";
  if ($crypto.NamedCurve$isP384(value)) return "P-384";
  return "P-521";
}

export function fromNamedCurve(value: string): $crypto.NamedCurve$ {
  switch (value) {
    case "P-256":
      return $crypto.NamedCurve$P256();
    case "P-384":
      return $crypto.NamedCurve$P384();
    case "P-521":
      return $crypto.NamedCurve$P521();
    default:
      throw new Error(
        `gossamer.crypto: runtime returned unexpected named curve: ${value}`,
      );
  }
}

export function toKeyAlgorithm(
  algorithm: KeyAlgorithm,
): $crypto.KeyAlgorithm$ {
  const name = algorithm.name;

  if (name === "Ed25519") return $crypto.KeyAlgorithm$Ed25519();
  if (name === "X25519") return $crypto.KeyAlgorithm$X25519();
  if (name === "HKDF") return $crypto.KeyAlgorithm$Hkdf();
  if (name === "PBKDF2") return $crypto.KeyAlgorithm$Pbkdf2();

  if ("namedCurve" in algorithm) {
    return $crypto.KeyAlgorithm$Ec(
      fromEcAlgorithm(name),
      fromNamedCurve((algorithm as EcKeyAlgorithmShape).namedCurve),
    );
  }

  if ("modulusLength" in algorithm) {
    const rsa = algorithm as RsaKeyAlgorithmShape;
    return $crypto.KeyAlgorithm$Rsa(
      fromRsaAlgorithm(name),
      rsa.modulusLength,
      BitArray$BitArray(new Uint8Array(rsa.publicExponent)),
      fromHashAlgorithm(hashName(rsa.hash)),
    );
  }

  if ("hash" in algorithm) {
    const hmac = algorithm as HmacKeyAlgorithmShape;
    return $crypto.KeyAlgorithm$Hmac(
      fromHashAlgorithm(hashName(hmac.hash)),
      hmac.length,
    );
  }

  return $crypto.KeyAlgorithm$Aes(
    fromAesAlgorithm(name),
    (algorithm as AesKeyAlgorithmShape).length,
  );
}

export const info: typeof $key.info = (key) => {
  return $key.Info$Info(
    toKeyAlgorithm(key.algorithm),
    toKeyKind(key.type),
    fromArrayMapped(key.usages, fromKeyUsage),
    key.extractable,
  );
};
