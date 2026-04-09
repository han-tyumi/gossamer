import * as $ra from "$/gossamer/gossamer/rsa_algorithm.mjs";

export function toRsaAlgorithm(value: $ra.RsaAlgorithm$): string {
  if ($ra.RsaAlgorithm$isRsaOaep(value)) return "RSA-OAEP";
  if ($ra.RsaAlgorithm$isRsaPss(value)) return "RSA-PSS";
  if ($ra.RsaAlgorithm$isOther(value)) {
    return $ra.RsaAlgorithm$Other$0(value);
  }
  return "RSASSA-PKCS1-v1_5";
}

export function fromRsaAlgorithm(value: string): $ra.RsaAlgorithm$ {
  switch (value) {
    case "RSA-OAEP":
      return $ra.RsaAlgorithm$RsaOaep();
    case "RSA-PSS":
      return $ra.RsaAlgorithm$RsaPss();
    case "RSASSA-PKCS1-v1_5":
      return $ra.RsaAlgorithm$RsassaPkcs1V15();
    default:
      return $ra.RsaAlgorithm$Other(value);
  }
}
