import * as $ha from "$/gossamer/gossamer/hash_algorithm.mjs";

export function toHashAlgorithm(value: $ha.HashAlgorithm$): string {
  if ($ha.HashAlgorithm$isSha1(value)) return "SHA-1";
  if ($ha.HashAlgorithm$isSha256(value)) return "SHA-256";
  if ($ha.HashAlgorithm$isSha384(value)) return "SHA-384";
  if ($ha.HashAlgorithm$isOther(value)) return $ha.HashAlgorithm$Other$0(value);
  return "SHA-512";
}

export function fromHashAlgorithm(value: string): $ha.HashAlgorithm$ {
  switch (value) {
    case "SHA-1":
      return $ha.HashAlgorithm$Sha1();
    case "SHA-256":
      return $ha.HashAlgorithm$Sha256();
    case "SHA-384":
      return $ha.HashAlgorithm$Sha384();
    case "SHA-512":
      return $ha.HashAlgorithm$Sha512();
    default:
      return $ha.HashAlgorithm$Other(value);
  }
}
