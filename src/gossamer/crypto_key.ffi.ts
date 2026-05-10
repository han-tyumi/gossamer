import * as $cryptoKey from "$/gossamer/gossamer/crypto_key.mjs";
import { fromAesAlgorithm } from "~/gossamer/aes_algorithm.ffi.ts";
import { fromEcAlgorithm } from "~/gossamer/ec_algorithm.ffi.ts";
import { fromRsaAlgorithm } from "~/gossamer/rsa_algorithm.ffi.ts";
import { fromArrayMapped, toArray } from "~/utils/list.ffi.ts";

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

export function toKeyType(value: KeyType | string): $cryptoKey.KeyType$ {
  switch (value) {
    case "private":
      return $cryptoKey.KeyType$Private();
    case "public":
      return $cryptoKey.KeyType$Public();
    case "secret":
      return $cryptoKey.KeyType$Secret();
    default:
      return $cryptoKey.KeyType$KeyTypeOther(value);
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
  if ($cryptoKey.KeyUsage$isKeyUsageOther(value)) {
    return $cryptoKey.KeyUsage$KeyUsageOther$0(value) as KeyUsage;
  }
  return "wrapKey";
}

export function fromKeyUsage(value: KeyUsage | string): $cryptoKey.KeyUsage$ {
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
      return $cryptoKey.KeyUsage$KeyUsageOther(value);
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
