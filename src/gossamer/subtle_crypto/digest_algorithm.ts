import * as $alg from "$/gossamer/gossamer/subtle_crypto/digest_algorithm.mjs";

export function toDigestAlgorithm(
  algorithm: $alg.DigestAlgorithm$,
): AlgorithmIdentifier {
  if ($alg.DigestAlgorithm$isSha1(algorithm)) return "SHA-1";
  if ($alg.DigestAlgorithm$isSha256(algorithm)) return "SHA-256";
  if ($alg.DigestAlgorithm$isSha384(algorithm)) return "SHA-384";
  if ($alg.DigestAlgorithm$isOther(algorithm)) {
    return $alg.DigestAlgorithm$Other$0(algorithm);
  }
  return "SHA-512";
}
