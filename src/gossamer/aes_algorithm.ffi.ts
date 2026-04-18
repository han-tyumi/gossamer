import * as $aa from "$/gossamer/gossamer/aes_algorithm.mjs";

export function toAesAlgorithm(value: $aa.AesAlgorithm$): string {
  if ($aa.AesAlgorithm$isAesCbc(value)) return "AES-CBC";
  if ($aa.AesAlgorithm$isAesCtr(value)) return "AES-CTR";
  if ($aa.AesAlgorithm$isAesKw(value)) return "AES-KW";
  if ($aa.AesAlgorithm$isOther(value)) return $aa.AesAlgorithm$Other$0(value);
  return "AES-GCM";
}

export function fromAesAlgorithm(value: string): $aa.AesAlgorithm$ {
  switch (value) {
    case "AES-CBC":
      return $aa.AesAlgorithm$AesCbc();
    case "AES-CTR":
      return $aa.AesAlgorithm$AesCtr();
    case "AES-GCM":
      return $aa.AesAlgorithm$AesGcm();
    case "AES-KW":
      return $aa.AesAlgorithm$AesKw();
    default:
      return $aa.AesAlgorithm$Other(value);
  }
}
