import * as $keyUsage from "$/gossamer/gossamer/key_usage.mjs";
import { toArray } from "~/utils/list.ffi.ts";

export function toKeyUsage(value: $keyUsage.KeyUsage$): KeyUsage {
  if ($keyUsage.KeyUsage$isDecrypt(value)) return "decrypt";
  if ($keyUsage.KeyUsage$isDeriveBits(value)) return "deriveBits";
  if ($keyUsage.KeyUsage$isDeriveKey(value)) return "deriveKey";
  if ($keyUsage.KeyUsage$isEncrypt(value)) return "encrypt";
  if ($keyUsage.KeyUsage$isSign(value)) return "sign";
  if ($keyUsage.KeyUsage$isUnwrapKey(value)) return "unwrapKey";
  if ($keyUsage.KeyUsage$isVerify(value)) return "verify";
  if ($keyUsage.KeyUsage$isOther(value)) {
    return $keyUsage.KeyUsage$Other$0(value) as KeyUsage;
  }
  return "wrapKey";
}

export function fromKeyUsage(value: KeyUsage | string): $keyUsage.KeyUsage$ {
  switch (value) {
    case "decrypt":
      return $keyUsage.KeyUsage$Decrypt();
    case "deriveBits":
      return $keyUsage.KeyUsage$DeriveBits();
    case "deriveKey":
      return $keyUsage.KeyUsage$DeriveKey();
    case "encrypt":
      return $keyUsage.KeyUsage$Encrypt();
    case "sign":
      return $keyUsage.KeyUsage$Sign();
    case "unwrapKey":
      return $keyUsage.KeyUsage$UnwrapKey();
    case "verify":
      return $keyUsage.KeyUsage$Verify();
    case "wrapKey":
      return $keyUsage.KeyUsage$WrapKey();
    default:
      return $keyUsage.KeyUsage$Other(value);
  }
}

export function toKeyUsageArray(
  usages: Parameters<typeof toArray>[0],
): KeyUsage[] {
  return (toArray(usages) as $keyUsage.KeyUsage$[]).map(toKeyUsage);
}
